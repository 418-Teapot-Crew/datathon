from fastapi import FastAPI, HTTPException
from fastapi.params import Query
from shapely.geometry import Point, shape
import json
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

geojson_file_path = "C:\\Users\\sugrado\\Desktop\\datathon\\server\\konya_mahalleler.geojson"
prepared_data_file_path = "C:\\Users\\sugrado\\Desktop\\datathon\\data\\model_data.xlsx"
categorized_data_file_path = "C:\\Users\\sugrado\\Desktop\\datathon\\data\\product_category.csv"

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
    df = pd.read_excel(prepared_data_file_path)
    selected_rows = df[df['mahalle_adi'] == neighborhood_name].to_dict('records')

    df2 = pd.read_csv(categorized_data_file_path)

    for row in selected_rows:
        category = row["product_category"]
        suggested_products_list = df2[df2['Category'] == category]["Product"].tolist()
        row["suggested_products"] = suggested_products_list
        
    return JSONResponse(content=jsonable_encoder(selected_rows))

@app.get("/get_neighborhood_info")
async def read_item(lat: float | None = None, long: float| None = None, neighborhood_name: str| None = None):
    if neighborhood_name:
        res = get_neighborhood_info(neighborhood_name)
    elif lat and long:
        res = get_neighborhood_info(get_neighborhood_from_coords(lat=lat, long=long))
    else:
        raise HTTPException(status_code=404, detail="No neighborhood found for the given coordinates")
    return res

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
