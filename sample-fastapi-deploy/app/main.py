from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "App running"}

@app.get("/healthz")
def health():
    return {"status": "ok"}
