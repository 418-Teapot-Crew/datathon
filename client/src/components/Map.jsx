import { MapContainer } from 'react-leaflet/MapContainer';
import { TileLayer } from 'react-leaflet/TileLayer';
import 'leaflet/dist/leaflet.css';
import { useMap } from 'react-leaflet/hooks';
import L, { latLng, latLngBounds } from 'leaflet';
import { useState } from 'react';
import * as turf from '@turf/turf';
const Map = () => {
  const [test, setTest] = useState(false);
  const mapBoundaries = {
    southWest: latLng(35.71529801212532, 28.992919921875004),
    northEast: latLng(39.707186656826565, 36.06811523437501),
  };

  const bounds = latLngBounds(mapBoundaries.southWest, mapBoundaries.northEast);
  return (
    <div className="w-full h-[100vh] flex flex-col justify-center items-center gap-5 relative">
      <MapContainer
        center={[39.1560158, 35.0479979]}
        zoom={7}
        scrollWheelZoom={true}
        className="w-full h-full z-10"
        zoomSnap={1}
        zoomDelta={1}
        maxBounds={bounds}
        maxZoom={18}
        minZoom={8.3}
      >
        <TileLayer
          attribution="418 Teapot Datathon 2"
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        <Counties />
      </MapContainer>
      <button
        className="bg-black text-white tracking-widest border border-black py-2 px-6 rounded absolute text-base cursor-pointer right-5 top-5 z-20 font-extralight"
        onClick={() => {
          setTest(!test);
        }}
      >
        Reset Map
      </button>
    </div>
  );
};

const Counties = () => {
  const map = useMap();
  drawCountyBoundary(map);
};

function drawCountyBoundary(map) {
  fetch(`/assets/Konya_ilceler.geojson`)
    .then(function (response) {
      return response.json();
    })
    .then(function (json) {
      map.fitBounds(
        [
          [35.71529801212532, 28.992919921875004],
          [39.707186656826565, 36.06811523437501],
        ],
        {
          animate: false,
        }
      );
      map.eachLayer((layer) => {
        if (layer instanceof L.GeoJSON) {
          map.removeLayer(layer);
        }
      });
      const array = json.features;
      const features = [];
      for (let index = 0; index < array.length; index++) {
        const element = array[index];
        features.push(
          L.geoJSON(element.geometry, {
            style: {
              color: 'black',
              fillColor: 'yellow',
              weight: 1,
            },
          }).on('click', (e) => {
            map.fitBounds(e.target.getBounds(), {
              animate: true,
            });
            map.eachLayer((layer) => {
              if (layer instanceof L.GeoJSON) {
                map.removeLayer(layer);
              }
            });
            drawNeighbourhoodBoundary(map, element);
          })
        );
      }
      L.featureGroup(features).addTo(map);
    });
}

function drawNeighbourhoodBoundary(map, bounds) {
  fetch(`/assets/konya_mahalleler.geojson`)
    .then(function (response) {
      return response.json();
    })
    .then(function (json) {
      const array = json.features.filter((p) => isPolygonInPolygon(p, bounds));
      const features = [];
      for (let index = 0; index < array.length; index++) {
        const element = array[index];
        features.push(
          L.geoJSON(element.geometry, {
            style: {
              color: 'black',
              fillColor: 'blue',
              weight: 1,
            },
          }).on('click', async (e) => {
            // e.target.setStyle({
            //   fillColor: 'purple',
            //   weight: 1,
            // });
            map.fitBounds(e.target.getBounds(), {
              animate: true,
              maxZoom: 12,
            });
            let response = await fetch(
              `http://localhost:8000/get_neighborhood_info?neighborhood_name=${element.properties.ADI_NUMARA}`
            );
            response = (await response.json())[0];
            if (!response) {
              map.openPopup(
                `<div class="w-full h-min">
                  Bu mahalle için veri setinde veri bulunmamaktadır.
                </div>`,
                e.latlng
              );
            } else {
              map.openPopup(
                `<div class="w-full h-min">
                <div class="text-center text-green-500 text-2xl mb-3">
                  ${element.properties.ADI_NUMARA} Mahallesi
                </div>
                <table class="w-full border border-green-400 table-fixed">
                <thead class="bg-green-400 text-white">
                  <tr>
                    <th class="py-2 ps-2">Bilgi</th>  
                    <th class="py-2 ps-2">Veri</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="bg-white-100 text-black border border-green-400">
                    <td class="py-2 ps-2">Sulak alan miktarı</td>
                    <td class="py-2 ps-2">${response?.sulak_alan_miktari}</td>
                  </tr>
                  <tr class="bg-green-100 text-black border border-green-400">
                    <td class="py-2 ps-2">En çok yetiştirilen ürünler</td>
                    <td class="py-2 ps-2">${
                      response?.en_cok_yetistirilen_urunler
                    }</td>
                  </tr>
                  <tr class="bg-white text-black border border-green-400">
                    <td class="py-2 ps-2">Sulama Suyu Kaynağı Yönetimi</td>
                    <td class="py-2 ps-2">${
                      response?.sulama_suyu_kaynagi_yonetimi
                    }</td>
                  </tr>
                  <tr class="bg-green-100 text-black border border-green-400">
                    <td class="py-2 ps-2">Sulanabilir alanda yetiştirilen ürünler</td>
                    <td class="py-2 ps-2">${
                      response?.sulanabilir_alanda_yetistirilen_urunler
                    }</td>
                  </tr>
                  <tr class="bg-white text-black border border-green-400">
                    <td class="py-2 ps-2">Tarımsal sulama suyu kaynağı</td>
                    <td class="py-2 ps-2">${
                      response?.tarimsal_sulama_suyu_kaynagi
                    }</td>
                  </tr>
                  <tr class="bg-green-100 text-black border border-green-400">
                    <td class="py-2 ps-2">Talep edilen tarımsal eğitimler</td>
                    <td class="py-2 ps-2">${
                      response?.talep_edilen_tarimsal_egitimler
                    }</td>
                  </tr>
                  <tr class="bg-white text-black border border-green-400">
                    <td class="py-2 ps-2">Tarımsal sulama suyu</td>
                    <td class="py-2 ps-2">${response?.tarimsal_sulama_suyu}</td>
                  </tr>
                  <tr class="bg-green-100 text-black border border-green-400">
                    <td class="py-2 ps-2">Toprak tipi</td>
                    <td class="py-2 ps-2">${response?.toprak_tipi}</td>
                  </tr>
                  <tr class="bg-white text-black border border-green-400">
                    <td class="py-2 ps-2">Yağış Miktarı (mm)</td>
                    <td class="py-2 ps-2">${response['yagis_miktari (mm)']}</td>
                  </tr>
                  <tr class="bg-green-100 text-black border border-green-400">
                    <td class="py-2 ps-2">Açıklama</td>
                    <td class="py-2 ps-2">Bu kategori, verimli toprak türlerini temsil eder ve bu topraklar yüksek su ihtiyacına sahiptir. Bu topraklarda bitkilerin sağlıklı bir şekilde büyümesi için düzenli sulama gereklidir.
                  </td>
                  </tr>
                  <tr class="bg-white-100 text-black border border-green-400">
                    <td class="py-2 ps-2">Bu bölge için önerilen ürünler</td>
                    <td class="py-2 ps-2">${response?.suggested_products
                      .map((a) => `${a}<br>`)
                      .join('')}</td>
                  </tr>
                </tbody>
              </table></div>`,
                e.latlng,
                {
                  minWidth: 500,
                  maxWidth: 1000,
                  maxHeight: 1000,
                  keepInView: true,
                }
              );
            }
          })
        );
      }
      L.featureGroup(features).addTo(map);
    });
}

const isPolygonInPolygon = (point, geoJSONCoordinates) =>
  turf.intersect(point, geoJSONCoordinates);

export default Map;
