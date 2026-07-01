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

  IconData? _resolveIconForLabel(String btnLabel) {
    if (icon != null) return icon;
    final String clean = btnLabel.trim().toLowerCase();
    
    if (clean.contains('earn money')) return Icons.paid_outlined;
    if (clean.contains('logistics')) return Icons.local_shipping_outlined;
    if (clean.contains('load board')) return Icons.view_list_outlined;
    if (clean.contains('medical courier')) return Icons.medical_services_outlined;
    if (clean.contains('book anything') || clean.contains('book services')) return Icons.event_available_outlined;
    if (clean.contains('events')) return Icons.celebration_outlined;
    if (clean.contains('community')) return Icons.groups_outlined;
    if (clean.contains('creators')) return Icons.storefront_outlined;
    if (clean.contains('ask ug') || clean.contains('concierge') || clean.contains('ai')) return Icons.auto_awesome_outlined;
    if (clean.contains('ug+') || clean.contains('plus')) return Icons.star_outline;
    if (clean.contains('start')) return Icons.play_arrow_outlined;
    if (clean.contains('submit another')) return Icons.replay_outlined;
    if (clean.contains('submit') || clean.contains('request')) return Icons.send_outlined;
    if (clean.contains('keep searching')) return Icons.search_outlined;
    if (clean.contains('explore')) return Icons.explore_outlined;
    if (clean.contains('waitlist')) return Icons.app_registration_outlined;
    if (clean.contains('apply')) return Icons.how_to_reg_outlined;
    if (clean.contains('benefits')) return Icons.visibility_outlined;
    if (clean.contains('unlock') || clean.contains('perks')) return Icons.lock_open_outlined;
    if (clean.contains('back to hub') || clean.contains('back')) return Icons.arrow_back_outlined;
    if (clean.contains('try again')) return Icons.refresh_outlined;
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final IconData? resolvedIcon = _resolveIconForLabel(label);

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: isSecondary ? AppConstants.ugBlack : AppConstants.seasoningOrange,
      foregroundColor: isSecondary ? AppConstants.seasoningOrange : AppConstants.ugBlack,
      disabledBackgroundColor: AppConstants.ugBlack.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: isSecondary ? 0 : 3,
      shadowColor: AppConstants.ugBlack.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        side: BorderSide(
          color: AppConstants.seasoningOrange,
          width: 1.5,
        ),
      ),
    );

    final Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (resolvedIcon != null) ...[
          Icon(resolvedIcon, size: 18, color: isSecondary ? AppConstants.seasoningOrange : AppConstants.ugBlack),
          const SizedBox(width: 10),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: isSecondary ? AppConstants.seasoningOrange : AppConstants.ugBlack,
          ),
        ),
      ],
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48), // tap target size
        child: ElevatedButton(
          style: style,
          onPressed: onPressed,
          child: buttonContent,
        ),
      ),
    );
  }
}
