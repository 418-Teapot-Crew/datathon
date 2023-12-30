import 'package:datathon/places/place.dart';
import 'package:datathon/places/places_screen.dart';
import 'package:datathon/widgets/custom_button.dart';
import 'package:datathon/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController nameTec = TextEditingController();
  final TextEditingController latTec = TextEditingController();
  final TextEditingController lonTec = TextEditingController();

  final String lat = "Enlem";
  final String lon = "Boylam";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(textEditingController: nameTec, hint: "Name"),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                        textEditingController: latTec, hint: "Enlem")
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                        textEditingController: lonTec, hint: "Boylam")
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
                onClick: () {
                  if (nameTec.text.isNotEmpty &&
                      latTec.text.isNotEmpty &&
                      lonTec.text.isNotEmpty) {
                    setState(() {
                      places.add(Place(nameTec.text, double.parse(latTec.text),
                          double.parse(lonTec.text)));
                      nameTec.text = "";
                      latTec.text = "";
                      lonTec.text = "";
                    });
                  }
                },
                text: "Kaydet")
          ],
        ),
      ),
    );
  }
}
