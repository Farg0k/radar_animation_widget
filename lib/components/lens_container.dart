import 'dart:ui';

import 'package:flutter/material.dart';

class LensContainer extends StatelessWidget {
  const LensContainer({
    super.key,
    required this.child,
    required this.dimension,
    required this.lensColor,
    required this.borderColor,
    required this.lensBlur,
    required this.lensGlow,
  });
  final double dimension;
  final Widget child;
  final Color lensColor;
  final Color borderColor;
  final double lensBlur;
  final bool lensGlow;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: dimension,
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              child,
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: lensBlur, sigmaY: lensBlur),
                child: Container(
                  decoration: BoxDecoration(
                    color: lensColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(dimension / 2),
                    border: Border.all(color: borderColor, width: 4),
                  ),
                ),
              ),
              if (lensGlow == true)
                Positioned(
                  top: 30,
                  left: 30,
                  child: Container(
                    width: dimension / 3,
                    height: dimension / 3,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.0,
                        colors: [Colors.white.withValues(alpha: 0.4), Colors.transparent],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (lensGlow == true)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: dimension / 5,
                    height: dimension / 5,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.bottomRight,
                        radius: 1.0,
                        colors: [Colors.white.withValues(alpha: 0.7), Colors.transparent],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
