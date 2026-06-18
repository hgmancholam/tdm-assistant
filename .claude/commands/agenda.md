# agenda

Revisa el calendario de Outlook y genera un briefing del día o la semana con prep de reuniones.

## Usage

```
/agenda [today | tomorrow | week | <fecha: YYYY-MM-DD>]
```

## Behavior

1. Obtener eventos del calendario:
   ```powershell
   # Hoy
   pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 1
   # Esta semana
   pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 7
   # Fecha específica
   pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 1 -StartDate "2026-06-20"
   ```
2. Para cada reunión, generar:
   - Objetivo probable de la reunión (basado en título y notas)
   - Quién asiste y su rol probable
   - Puntos clave que Harol debería llevar preparados
   - Preguntas que probablemente surjan
3. Detectar y alertar sobre:
   - Back-to-backs (sin tiempo de buffer)
   - Reuniones sin agenda/notas definidas
   - Conflictos de horario
   - Reuniones que requieren prep urgente (en < 1 hora)

## Output format

```
# Agenda — [Fecha o rango]
**Total reuniones:** X  |  **Horas en reunión:** X.X h

## ⚠️ Alertas
- [09:00-11:00] Back-to-back — sin tiempo de buffer
- [14:00] Sin agenda definida — pedir orden del día

## Reuniones del día

### 09:00 — [Título] (Xmin) 📍[Ubicación / Teams]
**Organiza:** [nombre]  |  **Asistentes:** X personas
**Objetivo probable:** ...
**Llevar preparado:**
- ...
**Preguntas que pueden surgir:**
- ...

### 10:30 — ...

## Bloqueos de tiempo libre
- 11:00 - 14:00 → disponible para deep work / emails
```

## Notes

- Default = today
- Usar la zona horaria local del sistema
- Si una reunión tiene Teams link, incluirlo en el output para acceso rápido
- Tono: briefing ejecutivo — conciso, accionable
- Outlook Desktop debe estar abierto

