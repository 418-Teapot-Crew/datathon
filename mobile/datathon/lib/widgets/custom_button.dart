import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onClick, required this.text});

  final VoidCallback onClick;
  final String text;
  final double width = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // 5 birimlik border radius
            )),
        child: Text(text));
  }
}
