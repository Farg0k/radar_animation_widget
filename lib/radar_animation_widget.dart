import 'package:flutter/material.dart';

import 'components/lens_container.dart';
import 'components/radar_animation.dart';
export 'components/radar_animation.dart';

class RadarAnimationWidget extends StatelessWidget {
  const RadarAnimationWidget({
    super.key,
    this.controller,
    this.useLens = true,
    this.dimension = 300,
    this.backgroundColor = Colors.black,
    this.duration = const Duration(seconds: 10),
    this.numberPoints = 2,
    this.pointRadius = 5,
    this.pointColor = Colors.green,
    this.sectorColor = Colors.green,
    this.paintSector = true,
    this.gridColor = Colors.green,
    this.gridStrokeWidth = 1,
    this.gridCircleCount = 6,
    this.gridCircleLinesCount = 12,
    this.waveStrokeWidth = 5,
    this.waveColor = Colors.green,
    this.waveCount = 3,
    this.radarLineStrokeWidth = 3,
    this.radarLineColor = Colors.green,
    this.centerDotRadius = 5,
    this.centerDotColor = Colors.green,
    this.lensColor = Colors.cyan,
    this.borderColor = Colors.white70,
    this.lensBlur = 0.4,
    this.lensGlow = true,
  });
  final RadarController? controller;
  final bool useLens;
  final double dimension;
  final Color backgroundColor;
  final Duration duration;
  final int numberPoints;
  final double pointRadius;
  final Color pointColor;
  final Color sectorColor;
  final bool paintSector;
  final Color gridColor;
  final double? gridStrokeWidth;
  final int gridCircleCount;
  final int gridCircleLinesCount;
  final double? waveStrokeWidth;
  final Color waveColor;
  final int waveCount;
  final double? radarLineStrokeWidth;
  final Color radarLineColor;
  final double? centerDotRadius;
  final Color centerDotColor;
  final Color lensColor;
  final Color borderColor;
  final double lensBlur;
  final bool lensGlow;
  @override
  Widget build(BuildContext context) {
    Widget radarAnimation = RadarAnimation(
      controller: controller,
      dimension: dimension,
      backgroundColor: backgroundColor,
      duration: duration,
      numberPoints: numberPoints,
      pointRadius: pointRadius,
      pointColor: pointColor,
      sectorColor: sectorColor,
      paintSector: paintSector,
      gridColor: gridColor,
      gridStrokeWidth: gridStrokeWidth,
      gridCircleCount: gridCircleCount,
      gridCircleLinesCount: gridCircleLinesCount,
      waveStrokeWidth: waveStrokeWidth,
      waveColor: waveColor,
      waveCount: waveCount,
      radarLineStrokeWidth: radarLineStrokeWidth,
      radarLineColor: radarLineColor,
      centerDotRadius: centerDotRadius,
      centerDotColor: centerDotColor,
    );
    return useLens == false
        ? radarAnimation
        : LensContainer(
      dimension: dimension,
      lensColor: lensColor,
      borderColor: borderColor,
      lensBlur: lensBlur,
      lensGlow: lensGlow,
      child: radarAnimation,
    );
  }
}