import 'package:datathon/add/add_screen.dart';
import 'package:datathon/const/color.dart';
import 'package:datathon/places/places_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _children = [const AddScreen(), const PlacesScreen()];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? const Text("Alan Ekle")
            : const Text("Alanlar"),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          selectedItemColor: CustomColors.primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ekle"),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: "Alanlarım"),
          ]),
      body: _children[_currentIndex],
    );
  }
}
