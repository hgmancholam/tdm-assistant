# priorities

Gestiona las prioridades personales del TDM — las 3-5 cosas más importantes en las que debes enfocarte esta semana. El asistente las lee en cada briefing para calibrar alertas y recomendaciones.

## Usage

```
/priorities
/priorities set [lista de prioridades]
/priorities add [nueva prioridad]
/priorities done [número o texto]
/priorities clear
```

## Examples

```
/priorities
/priorities set cerrar sprint 12 de ALPHA, preparar propuesta de BETA, revisar presupuesto Q3
/priorities add revisar scope change con el cliente antes del viernes
/priorities done 2
/priorities done "cerrar sprint 12"
/priorities clear
```

## Behavior

### `/priorities` — Ver prioridades actuales

1. Leer `priorities.json`
2. Mostrar lista ordenada

```
**Prioridades actuales**
Última actualización: [fecha]

1. [prioridad 1] [· [proyecto] si aplica]
2. [prioridad 2]
3. [prioridad 3]

Para actualizar: /priorities set [lista]
Para añadir: /priorities add [nueva]
Para marcar como completada: /priorities done [número]
```

Si no hay prioridades:
```
No hay prioridades configuradas.
¿Cuáles son tus top 3-5 prioridades esta semana?
```

---

### `/priorities set` — Establecer prioridades

Reemplaza la lista completa con las nuevas prioridades.

1. Parsear la lista que da el usuario (separadas por coma, punto y coma, o líneas nuevas)
2. Inferir el proyecto relacionado si se menciona un código
3. Escribir `priorities.json`:

```json
{
  "lastUpdated": "YYYY-MM-DD",
  "items": [
    {
      "rank": 1,
      "text": "texto de la prioridad",
      "project": "CODE o null",
      "dueDate": "YYYY-MM-DD o null",
      "status": "active"
    }
  ]
}
```

Confirmar:
```
Prioridades actualizadas:
1. [prioridad 1]
2. [prioridad 2]
3. [prioridad 3]
```

---

### `/priorities add` — Añadir una prioridad

1. Leer `priorities.json`
2. Añadir el nuevo item al final de la lista (o donde indique el usuario)
3. Escribir `priorities.json` actualizado
4. Confirmar

---

### `/priorities done [N]` — Marcar como completada

1. Leer `priorities.json`
2. Encontrar el item por número o texto (búsqueda fuzzy)
3. Cambiar `status` a `"completed"`
4. Escribir `priorities.json`
5. Mostrar lista actualizada

```
✅ "[texto]" marcada como completada.

Prioridades restantes:
1. [prioridad]
2. [prioridad]
```

---

### `/priorities clear` — Limpiar lista

Pedir confirmación antes de borrar:
```
¿Confirmas que quieres borrar todas las prioridades actuales? (sí/no)
```
Si confirma, escribir `priorities.json` con lista vacía.

---

## Structure de priorities.json

```json
{
  "lastUpdated": "2026-06-17",
  "items": [
    {
      "rank": 1,
      "text": "Cerrar Sprint 12 de ALPHA antes del viernes",
      "project": "ALPHA",
      "dueDate": "2026-06-20",
      "status": "active"
    },
    {
      "rank": 2,
      "text": "Preparar propuesta técnica para BETA",
      "project": "BETA",
      "dueDate": null,
      "status": "active"
    }
  ]
}
```

---

## Notes

- Las prioridades son leídas por `/tdm` y `/brief` para calibrar alertas y recomendaciones
- Máximo recomendado: 5 prioridades activas (más de eso, nada es prioridad)
- Los items completados se guardan en el historial — no se borran, solo cambian de status
- Actualizarlas al inicio de cada semana o sprint es un buen hábito
