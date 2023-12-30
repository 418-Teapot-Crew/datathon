import 'package:datathon/const/color.dart';
import 'package:datathon/places/place.dart';
import 'package:flutter/material.dart';

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  String lorem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry." *
          5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              partBox("Sulak alan miktarı", "%50", 0),
              partBox(
                  "En çok yetiştirilen ürünler", "Buğday, Şeker Pancarı", 1),
              partBox("Sulama suyu kaynağı yönetimi", "Şahsi Kuyular", 0),
              partBox("Sulanabilir alanda yetiştirilen ürünler",
                  "Elma, Kiraz, Vişne", 1),
              partBox("Sulama suyu kaynağı", "Yeraltı Suları", 0),
              partBox("Açıklama", lorem, 1),
              partBox("Bu bölge için önerilen ürünler",
                  "Kiraz, Elma, Çilek, Bilmem", 0),
            ],
          ),
        ),
      ),
    );
  }

  Container partBox(String title, String body, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 20),
      decoration: BoxDecoration(
        color: index == 1 ? CustomColors.secondaryColor : null,
        border: const Border(
          bottom: BorderSide(
            color: CustomColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CustomColors.primaryColor, fontWeight: FontWeight.bold),
          ),
          Text(body, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
