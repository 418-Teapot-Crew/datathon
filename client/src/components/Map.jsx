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
        minZoom={7}
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
