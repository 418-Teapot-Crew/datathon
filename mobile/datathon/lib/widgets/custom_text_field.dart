import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.textEditingController,
      this.icon,
      required this.hint});

  final TextEditingController textEditingController;
  final Icon? icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: icon,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
      ),
    );
  }
}
