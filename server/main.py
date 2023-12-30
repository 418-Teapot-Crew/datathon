from fastapi import FastAPI

# FastAPI uygulamasını oluşturma
app = FastAPI()

def recommend_products(location):
    if location == 'bozkir':
        return {
            'aciklama': 'bu mekan cok iyi bir mekandir',
            'onerilen urunler': ['elma', 'armut', 'mal tunahan']
        }
    else:
        return {
            'aciklama': 'bu mekan cok kotu bir mekandir',
            'onerilen urunler': ['cilek', 'armut tunahan']
        }


# Basit bir GET endpoint'i
@app.get("/")
def read_root():
    return recommend_products('bozkir')

# Başka bir GET endpoint'i
@app.get("/hello/{name}")
def say_hello(name: str):
    return {"message": f"Merhaba, {name}!"}

# Uygulamayı çalıştırma
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
