# Fluxo Backend API

Servicio ligero en Python/FastAPI para extraer enlaces de video directos usando `yt-dlp`.

## Estructura
- `main.py`: Código de la API.
- `Dockerfile`: Configuración para despliegue (Cloud Run/Render).

## Despliegue Rápido (Recomendado)

### Opción 1: Render / Railway
1. Sube esta carpeta `backend` a un nuevo repo (o monorepo).
2. Conecta el repo a Render/Railway.
3. ¡Listo! Detectará el `Dockerfile` automáticamente.

### Opción 2: Google Cloud Run
```bash
gcloud run deploy fluxo-backend --source . --allow-unauthenticated
```

## Uso Local (Testing)
```bash
pip install -r requirements.txt
uvicorn main:app --reload
```

## Endpoint
`POST /extract`
```json
{
  "url": "https://fb.watch/..."
}
```
