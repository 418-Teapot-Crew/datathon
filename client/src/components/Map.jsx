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
          attribution="418 Teapot Askerleri"
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
              fillColor: getColorByCounty(element.properties.ILCEADI),
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
      console.log(array.length);
      for (let index = 0; index < array.length; index++) {
        const element = array[index];
        features.push(
          L.geoJSON(element.geometry, {
            style: {
              color: 'black',
              fillColor: 'red',
              weight: 1,
            },
          }).on('click', (e) => {
            map.fitBounds(e.target.getBounds(), {
              animate: true,
            });
            map.openPopup(
              `<div class="w-full h-min">
              <div class="text-center text-blue-500 text-2xl mb-3">
                ${element.properties.ADI_NUMARA} Mahallesi
              </div>
              <table class="w-full border border-blue-400 table-fixed">
              <thead class="bg-blue-400 text-white">
                <tr>
                  <th class="py-2 ps-2">Bilgi</th>  
                  <th class="py-2 ps-2">Veri</th>
                </tr>
              </thead>
              <tbody>
                <tr class="bg-blue-100 text-black border border-blue-400">
                  <td class="py-2 ps-2">Sulak alan miktarı</td>
                  <td class="py-2 ps-2">50%</td>
                </tr>
                <tr class="bg-blue-100 text-black border border-blue-400">
                  <td class="py-2 ps-2">En çok yetiştirilen ürünler</td>
                  <td class="py-2 ps-2">Buğday, Şeker Pancarı</td>
                </tr>
                <tr class="bg-white text-black border border-blue-400">
                  <td class="py-2 ps-2">Sulama Suyu Kaynağı Yönetimi</td>
                  <td class="py-2 ps-2">Şahsi Kuyular</td>
                </tr>
                <tr class="bg-blue-100 text-black border border-blue-400">
                  <td class="py-2 ps-2">Sulanabilir alanda yetiştirilen ürünler</td>
                  <td class="py-2 ps-2">Elma, Kiraz, Vişne</td>
                </tr>
                <tr class="bg-white text-black border border-blue-400">
                  <td class="py-2 ps-2">Sulama suyu kaynağı</td>
                  <td class="py-2 ps-2">Yeraltı Suları</td>
                </tr>
                <tr class="bg-blue-100 text-black border border-blue-400">
                  <td class="py-2 ps-2">Sulama suyu durum bilgisi</td>
                  <td class="py-2 ps-2">Var</td>
                </tr>
                <tr class="bg-blue-100 text-black border border-blue-400">
                  <td class="py-2 ps-2">Açıklama</td>
                  <td class="py-2 ps-2">Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book</td>
                </tr>
                <tr class="bg-blue-100 text-black border border-blue-400">
                  <td class="py-2 ps-2">Bu bölge için önerilen ürünler</td>
                  <td class="py-2 ps-2">KİRAZ, ELMA, ÇİLEK, BİLMEM NEY</td>
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
          })
        );
      }
      L.featureGroup(features).addTo(map);
    });
}

function getColorByCounty(county) {
  switch (county) {
    case county:
      return 'yellow';
    case 'MERAM':
    case 'EREĞLİ':
      return 'yellow';
    case 'SELÇUKLU':
    case 'KARATAY':
      return 'green';
    default:
      return 'red';
  }
}

function isPolygonInPolygon(point, geoJSONCoordinates) {
  const isInside = turf.intersect(point, geoJSONCoordinates);
  return isInside;
}

export default Map;
