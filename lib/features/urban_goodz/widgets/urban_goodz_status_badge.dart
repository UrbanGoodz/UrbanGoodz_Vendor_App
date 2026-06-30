import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class UrbanGoodzStatusBadge extends StatelessWidget {
  final String status;
  final bool isCompact;

  const UrbanGoodzStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final String lowerStatus = status.toLowerCase();
    final bool isLive = lowerStatus == 'live';
    final bool isPreview = lowerStatus == 'preview' || lowerStatus == 'early access' || lowerStatus == 'coming soon';
    
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isLive) {
      backgroundColor = AppConstants.seasoningOrange;
      borderColor = AppConstants.seasoningOrange;
      textColor = AppConstants.ugBlack;
    } else if (isPreview) {
      backgroundColor = const Color(0xFFE5E276).withValues(alpha: 0.25); // Dijon alpha
      borderColor = const Color(0xFFE5E276); // Dijon
      textColor = AppConstants.ugBlack;
    } else {
      backgroundColor = AppConstants.canvas.withValues(alpha: 0.4);
      borderColor = AppConstants.ugBlack.withValues(alpha: 0.2);
      textColor = AppConstants.ugBlack.withValues(alpha: 0.8);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isLive ? [
          BoxShadow(
            color: AppConstants.seasoningOrange.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppConstants.ugBlack,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
