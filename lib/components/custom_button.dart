import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0xFFFCDCB7),
    this.textColor = const Color(0xFF897558),
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: buttonColor,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 18, color: textColor, letterSpacing: 2),
          ),
          const SizedBox(width: 15), // Spacing between text and icon
          Icon(
            Icons.logout, // Right arrow icon
            color: textColor,
          ),
        ],
      ),
    );
  }
}
