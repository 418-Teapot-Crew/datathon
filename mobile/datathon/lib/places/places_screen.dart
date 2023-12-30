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
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.location_on),
            title: Text(places[index].name),
            subtitle: Text("${places[index].lat},${places[index].lon}"),
          );
        },
      ),
    );
  }
}
