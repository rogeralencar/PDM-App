import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isBig;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    this.isBig = true,
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
        padding: EdgeInsets.symmetric(
          horizontal: isBig ? 60 : 15,
          vertical: isBig ? 6 : 4,
        ),
        elevation: 20,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: isBig ? 20 : 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
