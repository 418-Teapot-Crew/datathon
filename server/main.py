from fastapi import FastAPI, HTTPException
from fastapi.params import Query
from shapely.geometry import Point, shape
import json
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

app = FastAPI()

geojson_file_path = "C:\\Users\\sugrado\\Desktop\\datathon\\server\\konya_mahalleler.geojson"

def get_neighborhood_from_coords(lat: float = Query(None, description="Latitude of the location"),
                     long: float = Query(None, description="Longitude of the location")):
    with open(geojson_file_path, encoding="UTF-8") as f:
        data = json.load(f)

    point = Point(long, lat)

    for feature in data['features']:
        polygon = shape(feature['geometry'])

        if point.within(polygon):
            neighborhood_name = feature['properties']['ADI_NUMARA']
            return neighborhood_name

    raise HTTPException(status_code=404, detail="No neighborhood found for the given coordinates")

def get_neighborhood_info(neighborhood_name: str ):
    res = {"description": f"{neighborhood_name} cok iyi bir mekandir", "suggested_products": ['elma', 'armut', 'üzüm']}
    return JSONResponse(content=jsonable_encoder(res))


@app.get("/get_neighborhood_info")
async def read_item(lat: float | None = None, long: float| None = None, neighborhood_name: str| None = None):
    if neighborhood_name:
        res = get_neighborhood_info(neighborhood_name)
        return res
    elif lat and long:
        res = get_neighborhood_info(get_neighborhood_from_coords(lat=lat, long=long))
        return res
    else:
        raise HTTPException(status_code=404, detail="No neighborhood found for the given coordinates")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
