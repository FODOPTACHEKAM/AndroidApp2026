import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isFullWidth;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isOutlined = false,
    this.isFullWidth = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF667eea),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: Colors.white),
              label: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
              style: buttonStyle,
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: const Color(0xFF667eea)),
              label: Text(text),
              style: buttonStyle,
            ),
    );
  }
}