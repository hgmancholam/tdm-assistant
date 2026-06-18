"""
memory.py — Unified memory service for the TDM Assistant.

Single entry point for all memory read/write operations.
Abstracts storage so the backend can be swapped without changing
any other part of the system.

Current backend : file (Markdown + JSON files on disk)
Future backends : sqlite | postgresql | mongodb | vector

Backend is selected via MEMORY_BACKEND env var (default: "file").

─────────────────────────────────────────────────────────────────
CLI USAGE
─────────────────────────────────────────────────────────────────
  python memory.py --op read   --type profile
  python memory.py --op read   --type session
  python memory.py --op read   --type project-context  --project ALPHA
  python memory.py --op read   --type weekly            --week 2026-25
  python memory.py --op read   --type reminders
  python memory.py --op read   --type priorities

  python memory.py --op write  --type session           --content '...'
  python memory.py --op write  --type project-context   --project ALPHA --content '...'
  python memory.py --op write  --type reminders         --content '[...]'
  python memory.py --op write  --type priorities        --content '{...}'
  python memory.py --op write  --type weekly            --week 2026-25 --content '...'

  python memory.py --op append --type log    --project ALPHA --entry 'Did X'
  python memory.py --op append --type session --entry 'Follow up: check Y'

  python memory.py --op search --query 'sprint velocity' [--project ALPHA] [--type log]

  python memory.py --op list   --type sessions
  python memory.py --op list   --type weekly
  python memory.py --op list   --type logs  --project ALPHA

─────────────────────────────────────────────────────────────────
MIGRATION GUIDE (when moving to a new backend)
─────────────────────────────────────────────────────────────────
  1. Implement a class extending MemoryStore (see bottom of file)
  2. Register it in the BACKENDS dict
  3. Set MEMORY_BACKEND=<key> in .env
  4. Zero changes required in any other skill or command

  The rest of the system calls this script exclusively —
  no other file reads memory files directly.
"""

from __future__ import annotations

import abc
import argparse
import json
import os
import re
import sys
from datetime import date, datetime
from pathlib import Path


# ── Helpers ───────────────────────────────────────────────────────────────────

ROOT = Path(__file__).resolve().parents[3]   # project root


def _ok(data: dict) -> None:
    print(json.dumps({"success": True, **data}, indent=2, ensure_ascii=False))


def _err(message: str) -> None:
    print(json.dumps({"success": False, "error": message}, indent=2, ensure_ascii=False))
    sys.exit(1)


def _iso(path: Path) -> str | None:
    try:
        return datetime.fromtimestamp(path.stat().st_mtime).isoformat(timespec="seconds")
    except Exception:
        return None


def _current_week() -> str:
    """Return ISO week string, e.g. '2026-25'."""
    iso = date.today().isocalendar()
    return f"{iso.year}-{iso.week:02d}"


# ── Abstract interface ────────────────────────────────────────────────────────

class MemoryStore(abc.ABC):
    """
    Contract that every backend must satisfy.

    All methods return a dict that will be serialised to JSON.
    Raise ValueError for user errors (bad type, missing params).
    Raise RuntimeError for infrastructure errors (file not found, DB down).
    """

    # ── Read ──────────────────────────────────────────────────────────────────

    @abc.abstractmethod
    def read_profile(self) -> dict:
        ...

    @abc.abstractmethod
    def read_session(self) -> dict:
        ...

    @abc.abstractmethod
    def read_project_context(self, project: str) -> dict:
        ...

    @abc.abstractmethod
    def read_weekly(self, week: str) -> dict:
        ...

    @abc.abstractmethod
    def read_reminders(self) -> dict:
        ...

    @abc.abstractmethod
    def read_priorities(self) -> dict:
        ...

    # ── Write ─────────────────────────────────────────────────────────────────

    @abc.abstractmethod
    def write_profile(self, content: str) -> dict:
        ...

    @abc.abstractmethod
    def write_session(self, content: str) -> dict:
        ...

    @abc.abstractmethod
    def write_project_context(self, project: str, content: str) -> dict:
        ...

    @abc.abstractmethod
    def write_weekly(self, week: str, content: str) -> dict:
        ...

    @abc.abstractmethod
    def write_reminders(self, content: str) -> dict:
        ...

    @abc.abstractmethod
    def write_priorities(self, content: str) -> dict:
        ...

    # ── Append ────────────────────────────────────────────────────────────────

    @abc.abstractmethod
    def append_log(self, project: str, entry: str) -> dict:
        ...

    @abc.abstractmethod
    def append_session(self, entry: str) -> dict:
        ...

    # ── Search ────────────────────────────────────────────────────────────────

    @abc.abstractmethod
    def search(self, query: str, project: str | None, memory_type: str | None) -> dict:
        ...

    # ── List ──────────────────────────────────────────────────────────────────

    @abc.abstractmethod
    def list_sessions(self) -> dict:
        ...

    @abc.abstractmethod
    def list_weekly(self) -> dict:
        ...

    @abc.abstractmethod
    def list_logs(self, project: str) -> dict:
        ...


# ── File-based implementation (current default) ───────────────────────────────

class FileMemoryStore(MemoryStore):
    """
    Stores memory as Markdown and JSON files on disk.

    Directory layout:
      <root>/user.profile.md
      <root>/reminders.json
      <root>/priorities.json
      <root>/memory/last-session.md
      <root>/memory/sessions/session-YYYY-MM-DD-HHmm.md   (archives)
      <root>/memory/weekly/weekly-YYYY-WW.md
      <root>/projects/<CODE>/context.md
      <root>/projects/<CODE>/logs/YYYY-MM-DD.md
    """

    def __init__(self, root: Path = ROOT):
        self.root          = root
        self.memory_dir    = root / "memory"
        self.sessions_dir  = self.memory_dir / "sessions"
        self.weekly_dir    = self.memory_dir / "weekly"
        self.profile_path  = root / "user.profile.md"
        self.session_path  = self.memory_dir / "last-session.md"
        self.reminders_path = root / "reminders.json"
        self.priorities_path = root / "priorities.json"

    def _projects_dir(self, project: str) -> Path:
        return self.root / "projects" / project

    def _context_path(self, project: str) -> Path:
        return self._projects_dir(project) / "context.md"

    def _log_path(self, project: str, day: str | None = None) -> Path:
        day = day or date.today().isoformat()
        return self._projects_dir(project) / "logs" / f"{day}.md"

    def _weekly_path(self, week: str) -> Path:
        return self.weekly_dir / f"weekly-{week}.md"

    # ── Helpers ───────────────────────────────────────────────────────────────

    def _read_text(self, path: Path) -> dict:
        if not path.exists():
            return {"found": False, "content": "", "path": str(path)}
        return {
            "found":        True,
            "content":      path.read_text(encoding="utf-8"),
            "path":         str(path),
            "lastModified": _iso(path),
        }

    def _write_text(self, path: Path, content: str) -> dict:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        return {"path": str(path), "size": len(content), "lastModified": _iso(path)}

    def _read_json(self, path: Path) -> dict:
        if not path.exists():
            return {"found": False, "data": None, "path": str(path)}
        raw  = path.read_text(encoding="utf-8")
        data = json.loads(raw)
        return {"found": True, "data": data, "path": str(path), "lastModified": _iso(path)}

    def _write_json(self, path: Path, content: str) -> dict:
        data = json.loads(content)   # validate JSON before writing
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        return {"path": str(path), "lastModified": _iso(path)}

    # ── Read ──────────────────────────────────────────────────────────────────

    def read_profile(self) -> dict:
        return self._read_text(self.profile_path)

    def read_session(self) -> dict:
        return self._read_text(self.session_path)

    def read_project_context(self, project: str) -> dict:
        return self._read_text(self._context_path(project))

    def read_weekly(self, week: str) -> dict:
        return self._read_text(self._weekly_path(week))

    def read_reminders(self) -> dict:
        return self._read_json(self.reminders_path)

    def read_priorities(self) -> dict:
        return self._read_json(self.priorities_path)

    # ── Write ─────────────────────────────────────────────────────────────────

    def write_profile(self, content: str) -> dict:
        return self._write_text(self.profile_path, content)

    def write_session(self, content: str) -> dict:
        # Archive previous session before overwriting
        if self.session_path.exists():
            self.sessions_dir.mkdir(parents=True, exist_ok=True)
            ts       = datetime.now().strftime("%Y-%m-%d-%H%M")
            archive  = self.sessions_dir / f"session-{ts}.md"
            archive.write_text(self.session_path.read_text(encoding="utf-8"), encoding="utf-8")
        return self._write_text(self.session_path, content)

    def write_project_context(self, project: str, content: str) -> dict:
        return self._write_text(self._context_path(project), content)

    def write_weekly(self, week: str, content: str) -> dict:
        return self._write_text(self._weekly_path(week), content)

    def write_reminders(self, content: str) -> dict:
        return self._write_json(self.reminders_path, content)

    def write_priorities(self, content: str) -> dict:
        return self._write_json(self.priorities_path, content)

    # ── Append ────────────────────────────────────────────────────────────────

    def append_log(self, project: str, entry: str) -> dict:
        path = self._log_path(project)
        path.parent.mkdir(parents=True, exist_ok=True)
        ts   = datetime.now().strftime("%H:%M")
        line = f"\n- {ts} — {entry}\n"
        if not path.exists():
            path.write_text(f"# Log — {date.today().isoformat()}\n{line}", encoding="utf-8")
        else:
            with open(path, "a", encoding="utf-8") as f:
                f.write(line)
        return {"path": str(path), "entry": entry}

    def append_session(self, entry: str) -> dict:
        self.session_path.parent.mkdir(parents=True, exist_ok=True)
        ts   = datetime.now().strftime("%H:%M")
        line = f"\n- {ts} — {entry}\n"
        if not self.session_path.exists():
            self.session_path.write_text(
                f"# Session Memory — {date.today().isoformat()}\n{line}", encoding="utf-8"
            )
        else:
            with open(self.session_path, "a", encoding="utf-8") as f:
                f.write(line)
        return {"path": str(self.session_path), "entry": entry}

    # ── Search ────────────────────────────────────────────────────────────────

    def search(self, query: str, project: str | None, memory_type: str | None) -> dict:
        pattern = re.compile(re.escape(query), re.IGNORECASE)
        results = []

        def _search_file(path: Path, source_type: str, source_project: str | None = None):
            if not path.exists():
                return
            lines = path.read_text(encoding="utf-8").splitlines()
            for i, line in enumerate(lines):
                if pattern.search(line):
                    context_lines = lines[max(0, i-1):i+3]
                    results.append({
                        "type":    source_type,
                        "project": source_project,
                        "path":    str(path),
                        "line":    i + 1,
                        "match":   line.strip(),
                        "context": "\n".join(context_lines),
                    })

        search_all = memory_type is None

        if search_all or memory_type == "profile":
            _search_file(self.profile_path, "profile")

        if search_all or memory_type == "session":
            _search_file(self.session_path, "session")
            for f in sorted(self.sessions_dir.glob("session-*.md")) if self.sessions_dir.exists() else []:
                _search_file(f, "session-archive")

        if search_all or memory_type == "weekly":
            for f in sorted(self.weekly_dir.glob("weekly-*.md")) if self.weekly_dir.exists() else []:
                _search_file(f, "weekly")

        projects_to_search = [project] if project else []
        if not projects_to_search and (search_all or memory_type in ("log", "project-context")):
            p = self.root / "projects"
            if p.exists():
                projects_to_search = [d.name for d in p.iterdir()
                                       if d.is_dir() and d.name != "_template"]

        for proj in projects_to_search:
            if search_all or memory_type == "project-context":
                _search_file(self._context_path(proj), "project-context", proj)
            if search_all or memory_type == "log":
                logs_dir = self._projects_dir(proj) / "logs"
                if logs_dir.exists():
                    for log_file in sorted(logs_dir.glob("*.md"), reverse=True)[:30]:
                        _search_file(log_file, "log", proj)

        return {"query": query, "count": len(results), "results": results}

    # ── List ──────────────────────────────────────────────────────────────────

    def list_sessions(self) -> dict:
        items = []
        if self.session_path.exists():
            items.append({"file": "last-session.md", "path": str(self.session_path),
                          "lastModified": _iso(self.session_path), "isCurrent": True})
        if self.sessions_dir.exists():
            for f in sorted(self.sessions_dir.glob("session-*.md"), reverse=True):
                items.append({"file": f.name, "path": str(f),
                              "lastModified": _iso(f), "isCurrent": False})
        return {"count": len(items), "sessions": items}

    def list_weekly(self) -> dict:
        items = []
        if self.weekly_dir.exists():
            for f in sorted(self.weekly_dir.glob("weekly-*.md"), reverse=True):
                items.append({"file": f.name, "week": f.stem.replace("weekly-", ""),
                              "path": str(f), "lastModified": _iso(f)})
        return {"count": len(items), "weeklies": items}

    def list_logs(self, project: str) -> dict:
        logs_dir = self._projects_dir(project) / "logs"
        items    = []
        if logs_dir.exists():
            for f in sorted(logs_dir.glob("*.md"), reverse=True):
                items.append({"file": f.name, "date": f.stem,
                              "path": str(f), "lastModified": _iso(f),
                              "sizeBytes": f.stat().st_size})
        return {"project": project, "count": len(items), "logs": items}


# ── Backend registry ──────────────────────────────────────────────────────────
# To add a new backend:
#   1. Write a class that extends MemoryStore
#   2. Add it here: BACKENDS["mydb"] = MyDBMemoryStore
#   3. Set MEMORY_BACKEND=mydb in .env

BACKENDS: dict[str, type[MemoryStore]] = {
    "file": FileMemoryStore,
    # "sqlite":     SQLiteMemoryStore,       # future
    # "postgresql": PostgreSQLMemoryStore,   # future
    # "mongodb":    MongoMemoryStore,        # future
    # "vector":     VectorMemoryStore,       # future (semantic search)
}


def get_store() -> MemoryStore:
    backend = os.environ.get("MEMORY_BACKEND", "file").lower()
    cls     = BACKENDS.get(backend)
    if cls is None:
        raise ValueError(f"Unknown MEMORY_BACKEND='{backend}'. Available: {list(BACKENDS)}")
    return cls()


# ── CLI dispatcher ────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(description="TDM Assistant memory service")
    parser.add_argument("--op",      required=True,
                        choices=["read", "write", "append", "search", "list"])
    parser.add_argument("--type",    default=None,
                        choices=["profile", "session", "project-context", "weekly",
                                 "reminders", "priorities", "log",
                                 "sessions", "logs"])
    parser.add_argument("--project", default=None, help="Project code (e.g. ALPHA)")
    parser.add_argument("--week",    default=None, help="ISO week e.g. 2026-25")
    parser.add_argument("--content", default=None, help="Content to write (string)")
    parser.add_argument("--entry",   default=None, help="Text to append")
    parser.add_argument("--query",   default=None, help="Search query")
    args = parser.parse_args()

    try:
        store = get_store()

        # ── READ ────────────────────────────────────────────────────────────
        if args.op == "read":
            if   args.type == "profile":          _ok(store.read_profile())
            elif args.type == "session":          _ok(store.read_session())
            elif args.type == "project-context":
                if not args.project: _err("--project required for type=project-context")
                _ok(store.read_project_context(args.project))
            elif args.type == "weekly":
                _ok(store.read_weekly(args.week or _current_week()))
            elif args.type == "reminders":        _ok(store.read_reminders())
            elif args.type == "priorities":       _ok(store.read_priorities())
            else: _err(f"Unsupported --type for read: {args.type}")

        # ── WRITE ───────────────────────────────────────────────────────────
        elif args.op == "write":
            if args.content is None: _err("--content is required for write")
            if   args.type == "profile":         _ok(store.write_profile(args.content))
            elif args.type == "session":         _ok(store.write_session(args.content))
            elif args.type == "project-context":
                if not args.project: _err("--project required")
                _ok(store.write_project_context(args.project, args.content))
            elif args.type == "weekly":
                _ok(store.write_weekly(args.week or _current_week(), args.content))
            elif args.type == "reminders":       _ok(store.write_reminders(args.content))
            elif args.type == "priorities":      _ok(store.write_priorities(args.content))
            else: _err(f"Unsupported --type for write: {args.type}")

        # ── APPEND ──────────────────────────────────────────────────────────
        elif args.op == "append":
            if args.entry is None: _err("--entry is required for append")
            if   args.type == "log":
                if not args.project: _err("--project required for type=log")
                _ok(store.append_log(args.project, args.entry))
            elif args.type == "session":         _ok(store.append_session(args.entry))
            else: _err(f"Unsupported --type for append: {args.type}")

        # ── SEARCH ──────────────────────────────────────────────────────────
        elif args.op == "search":
            if not args.query: _err("--query is required for search")
            _ok(store.search(args.query, args.project, args.type))

        # ── LIST ────────────────────────────────────────────────────────────
        elif args.op == "list":
            if   args.type == "sessions":        _ok(store.list_sessions())
            elif args.type == "weekly":          _ok(store.list_weekly())
            elif args.type == "logs":
                if not args.project: _err("--project required for list logs")
                _ok(store.list_logs(args.project))
            else: _err(f"Unsupported --type for list: {args.type}")

    except ValueError as e:
        _err(str(e))
    except Exception as e:
        _err(f"Unexpected error: {e}")


if __name__ == "__main__":
    main()
