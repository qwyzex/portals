import 'package:flutter/material.dart';

// This function displays a custom sliding SnackBar with fade-in animation.
void customSnackbar({
  required String message, // The message to display in the SnackBar
  required BuildContext context, // The BuildContext to show the SnackBar within
  Duration? duration, // Optional: Duration for which the SnackBar is displayed
  TextStyle? textStyle, // Optional: Text style for the message text
  Color? textColor, // Optional: Text color for the message text
  Color? backgroundColor, // Optional: Background color of the SnackBar
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => SlidingSnackBarWidget(
      message: message,
      duration: duration ?? const Duration(milliseconds: 4500),
      textStyle: textStyle,
      textColor: textColor,
      backgroundColor: backgroundColor,
    ),
  );

  // Insert the overlay entry to display the snack bar
  overlay.insert(overlayEntry);

  // Remove the snack bar after the specified duration
  Future.delayed(duration ?? const Duration(milliseconds: 4500), () {
    overlayEntry.remove();
  });
}

// Custom sliding SnackBar widget with sliding and fade-in animation
class SlidingSnackBarWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;

  const SlidingSnackBarWidget({
    super.key,
    required this.message,
    required this.duration,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
  });

  @override
  State<SlidingSnackBarWidget> createState() => _SlidingSnackBarWidgetState();
}

class _SlidingSnackBarWidgetState extends State<SlidingSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and set the animation duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Define the sliding animation from bottom to top
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start below the screen
      end: const Offset(0.0, 0.0), // End in place
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Define the fade-in animation (opacity)
    _opacityAnimation = Tween<double>(
      begin: 0.0, // Start fully transparent
      end: 1.0, // End fully opaque
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start the animations
    _controller.forward();
  }

  @override
  void dispose() {
    // Clean up the animation controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40.0, // Position the SnackBar above the bottom of the screen
      left: 20.0,
      right: 20.0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation, // Apply the opacity animation here
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(10.0),
            color: widget.backgroundColor ?? Colors.black.withAlpha(200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                widget.message,
                style: widget.textStyle ??
                    TextStyle(
                      color: widget.textColor ?? Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
