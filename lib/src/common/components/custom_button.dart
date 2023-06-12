import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double fontSize;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    this.fontSize = 20,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 60,
          vertical: 6,
        ),
        elevation: 20,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
