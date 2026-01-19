import os
import subprocess
import json
from fastapi import FastAPI, HTTPException, Body
from pydantic import BaseModel

app = FastAPI()

class ExtractRequest(BaseModel):
    url: str

class VideoResponse(BaseModel):
    title: str | None = None
    thumbnail: str | None = None
    direct_url: str | None = None
    duration: int | None = None

@app.get("/")
def health_check():
    return {"status": "ok", "service": "Fluxo Extractor"}

@app.post("/extract", response_model=VideoResponse)
def extract_video(req: ExtractRequest = Body(...)):
    """
    Extracts direct video URL using yt-dlp binary directly.
    """
    try:
        print(f"Processing URL: {req.url}")
        
        # Command to get JSON metadata
        # -J: Dump JSON
        # --no-warnings: Clean output
        cmd = [
            "yt-dlp",
            "-J",
            "--no-warnings",
            req.url
        ]

        # Sync execution (simple for cloud run instance)
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=45)
        
        if result.returncode != 0:
            print(f"Error extracting {req.url}: {result.stderr}")
            raise HTTPException(status_code=400, detail="Could not extract video info")

        data = json.loads(result.stdout)
        
        # Select best url
        direct_url = data.get("url")
        
        # Fallback logic: find best mp4 with audio if direct url is not immediately apparent
        if not direct_url:
             formats = data.get("formats", [])
             for f in formats:
                 if f.get("ext") == "mp4" and f.get("acodec") != "none":
                     direct_url = f.get("url")
                     # Prefer the one found, or keep searching for better quality? 
                     # Usually the last one compatible is best quality in flattened list.
         
        if not direct_url:
            raise HTTPException(status_code=422, detail="No direct URL found")

        return VideoResponse(
            title=data.get("title"),
            thumbnail=data.get("thumbnail"),
            direct_url=direct_url,
            duration=data.get("duration")
        )

    except subprocess.TimeoutExpired:
        print("Timeout expired for extraction")
        raise HTTPException(status_code=504, detail="Extraction timed out")
    except Exception as e:
        print(f"Internal error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
