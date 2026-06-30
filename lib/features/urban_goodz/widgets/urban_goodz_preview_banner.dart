import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class UrbanGoodzPreviewBanner extends StatelessWidget {
  final String message;
  final IconData icon;

  const UrbanGoodzPreviewBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E276).withValues(alpha: 0.15), // Dijon background alpha
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: const Color(0xFFE5E276).withValues(alpha: 0.7), // Dijon border
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E276).withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppConstants.ugBlack,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PREVIEW ACTIVE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppConstants.ugBlack,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.ugBlack.withValues(alpha: 0.8),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppConstants.seasoningOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Urban Goodz is preparing this feature for your market.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.ugBlack.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
