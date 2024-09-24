import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: const Color(0xFFFCDCB7),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 18, color: Color(0xFF897558), letterSpacing: 2),
          ),
          const SizedBox(width: 5), // Spacing between text and icon
          const Icon(
            Icons.keyboard_arrow_right_rounded, // Right arrow icon
            color: Color(0xFF897558),
          ),
        ],
      ),
    );
  }
}
