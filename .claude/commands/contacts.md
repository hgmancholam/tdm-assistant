# contacts

Busca, consulta y gestiona contactos de Outlook.

## Usage

```
/contacts <acción o búsqueda>
```

## Examples

```
/contacts busca a Sarah Johnson
/contacts quién es el contacto de Microsoft en mi lista
/contacts todos los contactos de Arroyo Consulting
/contacts agrega a John Smith, PM en Acme Corp, john@acme.com
/contacts actualiza el teléfono de María López
```

## Behavior

### Buscar / consultar
1. Interpretar la búsqueda y ejecutar:
   ```powershell
   # Por nombre o keyword general
   pwsh -File ".agents/skills/outlook/get-contacts.ps1" -Query "Sarah" -Count 10

   # Por empresa
   pwsh -File ".agents/skills/outlook/get-contacts.ps1" -Company "Microsoft" -Count 10

   # Listar todos
   pwsh -File ".agents/skills/outlook/get-contacts.ps1" -Count 50
   ```
2. Mostrar resultados en tabla con email, empresa y teléfono
3. Si hay un único resultado, mostrar ficha completa

### Crear contacto
1. Recopilar campos necesarios (nombre, empresa, email, teléfono, cargo)
2. Confirmar datos antes de guardar
3. Ejecutar:
   ```powershell
   pwsh -File ".agents/skills/outlook/create-contact.ps1" `
     -FirstName "John" -LastName "Smith" `
     -Company "Acme Corp" -JobTitle "PM" `
     -Email "john@acme.com" -Phone "+1-555-0100"
   ```

### Actualizar contacto
1. Buscar el contacto existente para obtener su EntryID
2. Mostrar datos actuales y confirmar cambios
3. Ejecutar con `-EntryID` para actualizar en lugar de crear

## Output format

**Búsqueda (múltiples resultados):**
```
# Contactos — "[búsqueda]"
**Encontrados:** X

| Nombre | Empresa | Cargo | Email | Teléfono |
|--------|---------|-------|-------|----------|
| ...    | ...     | ...   | ...   | ...      |
```

**Ficha individual:**
```
👤 [Nombre completo]
🏢 [Cargo] — [Empresa] / [Departamento]
📧 [Email principal]
📞 [Teléfono] | 📱 [Móvil]
```

**Crear / Actualizar:**
```
✅ Contacto [creado / actualizado]: [Nombre] — [Empresa]
```

## Notes

- Outlook Desktop debe estar abierto
- SIEMPRE confirmar datos antes de crear o actualizar un contacto
- Si el nombre es ambiguo, mostrar lista para que el usuario elija

