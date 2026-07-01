import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class UrbanGoodzFeatureAssetImage extends StatelessWidget {
  final String assetPath;
  final double? aspectRatio;
  final double? maxHeight;
  final double? width;
  final BoxFit fit;
  final double? borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool hasBorder;
  final bool hasShadow;
  final bool fillWidth;
  final bool expandContainToWidth;
  final AlignmentGeometry alignment;

  const UrbanGoodzFeatureAssetImage({
    super.key,
    required this.assetPath,
    this.aspectRatio,
    this.maxHeight,
    this.width,
    this.fit = BoxFit.contain,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.all(8),
    this.margin,
    this.backgroundColor,
    this.hasBorder = true,
    this.hasShadow = false,
    this.fillWidth = false,
    this.expandContainToWidth = true,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? Dimensions.radiusDefault;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        assetPath,
        fit: (fillWidth && fit == BoxFit.contain && expandContainToWidth)
            ? BoxFit.fitWidth
            : fit,
        alignment: alignment,
        filterQuality: FilterQuality.high,
      ),
    );

    if (aspectRatio != null) {
      image = AspectRatio(aspectRatio: aspectRatio!, child: image);
    }

    if (fillWidth && maxHeight != null && aspectRatio == null) {
      image = SizedBox(width: double.infinity, height: maxHeight, child: image);
    } else if (maxHeight != null) {
      image = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: image,
      );
    }

    Widget container = Container(
      width: fillWidth ? double.infinity : width,
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
                ),
              ]
            : null,
      ),
      child: image,
    );

    return (width == double.infinity || fillWidth)
        ? container
        : Center(child: container);
  }
}
