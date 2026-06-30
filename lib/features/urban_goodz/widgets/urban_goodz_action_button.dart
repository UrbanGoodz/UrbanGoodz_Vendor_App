import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class UrbanGoodzActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final IconData? icon;

  const UrbanGoodzActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: isSecondary ? AppConstants.ugWhite : AppConstants.ugBlack,
      foregroundColor: isSecondary ? AppConstants.ugBlack : AppConstants.ugWhite,
      disabledBackgroundColor: AppConstants.ugBlack.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        side: isSecondary
            ? BorderSide(color: AppConstants.ugBlack.withValues(alpha: 0.2), width: 1.5)
            : BorderSide.none,
      ),
      elevation: isSecondary ? 0 : 2,
      shadowColor: AppConstants.ugBlack.withValues(alpha: 0.2),
    );

    final Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: buttonContent,
    );
  }
}
