import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class UrbanGoodzFeatureAssetImage extends StatelessWidget {
  final String assetPath;
  final double? aspectRatio;
  final double? maxHeight;
  final BoxFit fit;
  final double? borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool hasBorder;
  final bool hasShadow;

  const UrbanGoodzFeatureAssetImage({
    super.key,
    required this.assetPath,
    this.aspectRatio,
    this.maxHeight,
    this.fit = BoxFit.contain,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.all(8),
    this.margin,
    this.backgroundColor,
    this.hasBorder = true,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? Dimensions.radiusDefault;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        assetPath,
        fit: fit,
        filterQuality: FilterQuality.high,
      ),
    );

    if (aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: aspectRatio!,
        child: image,
      );
    }

    if (maxHeight != null) {
      image = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: image,
      );
    }

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.canvas,
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder
            ? Border.all(
                color: AppConstants.seasoningOrange.withValues(alpha: 0.22),
                width: 1,
              )
            : null,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppConstants.ugBlack.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: image,
    );
  }
}
