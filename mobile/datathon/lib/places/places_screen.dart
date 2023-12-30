import 'package:datathon/place_detail/place_detail.dart';
import 'package:datathon/places/place.dart';
import 'package:flutter/material.dart';

List<Place> places = [];

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            Place place = places[index];
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return PlaceDetail(
                      place: Place(place.name, place.lat, place.lon),
                    );
                  },
                ));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2.0,
                  ),
                  borderRadius:
                      BorderRadius.circular(10.0), // Kenar yuvarlaklığı
                ),
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    place.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${place.lat}, ${place.lon}"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
