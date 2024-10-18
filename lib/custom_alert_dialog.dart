import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final Color color;
  final IconData icon;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _containerScaleAnimation;
  late Animation<Offset> _yAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _iconScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _containerScaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _containerScaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: SlideTransition(
          position: _yAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _iconScaleAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            widget.color.withOpacity(0.2)),
                        strokeWidth: 8,
                      ),
                    ),
                    Icon(
                      widget.icon,
                      color: widget.color,
                      size: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.message,
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show the custom alert dialog
void showCustomAlert(
  BuildContext context, {
  required String title,
  required String message,
  required Color color,
  required IconData icon,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        message: message,
        color: color,
        icon: icon,
      );
    },
  );
}

// Usage examples
void showSuccessLogin(BuildContext context) {
  showCustomAlert(
    context,
    title: 'Login Successful',
    message: 'Welcome back! You have successfully logged in.',
    color: Colors.green,
    icon: Icons.check_circle,
  );
}

void showFailedLogin(BuildContext context) {
  showCustomAlert(
    context,
    title: 'Login Failed',
    message: 'Incorrect email or password. Please try again.',
    color: Colors.red,
    icon: Icons.error,
  );
}

void showNetworkError(BuildContext context) {
  showCustomAlert(
    context,
    title: 'Network Error',
    message:
        'Unable to connect to the server. Please check your internet connection.',
    color: Colors.orange,
    icon: Icons.wifi_off,
  );
}
