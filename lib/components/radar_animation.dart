import 'dart:math';
import 'package:flutter/material.dart';

class RadarAnimation extends StatefulWidget {
  const RadarAnimation({
    super.key,
    this.controller,
    required this.dimension,
    required this.backgroundColor,
    required this.duration,
    required this.numberPoints,
    required this.pointRadius,
    required this.pointColor,
    required this.sectorColor,
    required this.paintSector,
    required this.gridColor,
    required this.gridStrokeWidth,
    required this.gridCircleCount,
    required this.gridCircleLinesCount,
    required this.waveStrokeWidth,
    required this.waveColor,
    required this.waveCount,
    required this.radarLineStrokeWidth,
    required this.radarLineColor,
    required this.centerDotRadius,
    required this.centerDotColor,
  });
  final RadarController? controller;
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
  @override
  State<RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation> with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _offsetEndPoint = ValueNotifier<Offset>(Offset(0, 0));
  final ValueNotifier<Offset> _offsetCenter = ValueNotifier<Offset>(Offset(0, 0));
  late AnimationController _controller;
  bool _isAnimating = true;
  late bool _paintSector;
  late double? _radarLineStrokeWidth;
  late double? _waveStrokeWidth;
  late int _numberPoints;
  final Random _random = Random();
  final List<RadarPoint> _points = [];

  @override
  void initState() {
    _paintSector = widget.paintSector;
    _radarLineStrokeWidth = widget.radarLineStrokeWidth;
    _waveStrokeWidth = widget.waveStrokeWidth;
    _numberPoints = widget.numberPoints;

    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..addListener(() {
      _generateRandomPoint();
      setState(() {});
    });
    widget.controller?._attach(this);
    if (_isAnimating) _controller.repeat();
  }

  void _generateRandomPoint() {
    if (_random.nextDouble() < 0.05) {
      if (_points.length < _numberPoints) {
        _points.add(
          RadarPoint.random(
            lifetime: _random.nextDouble(),
            offsetEndPoint: _offsetEndPoint,
            offsetCenter: _offsetCenter,
          ),
        );
      }
    }
    _points.removeWhere((point) => point.age > point.lifetime);
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColoredBox(
        color: widget.backgroundColor,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: RadarPainter(
                sectorColor: widget.sectorColor,
                paintSector: _paintSector,
                gridColor: widget.gridColor,
                gridStrokeWidth: widget.gridStrokeWidth,
                gridCircleCount: widget.gridCircleCount,
                gridCircleLinesCount: widget.gridCircleLinesCount,
                waveStrokeWidth: _waveStrokeWidth,
                waveColor: widget.waveColor,
                waveCount: widget.waveCount,
                radarLineStrokeWidth: _radarLineStrokeWidth,
                radarLineColor: widget.radarLineColor,
                centerDotRadius: widget.centerDotRadius,
                centerDotColor: widget.centerDotColor,
                pointRadius: widget.pointRadius,
                pointColor: widget.pointColor,
                animationValue: _controller.value,
                points: _points,
                offsetEndPoint: _offsetEndPoint,
                offsetCenter: _offsetCenter,
              ),
              size: Size.square(widget.dimension),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _controller.dispose();
    _offsetCenter.dispose();
    _offsetEndPoint.dispose();
    super.dispose();
  }

  void _setAnimationState(bool? shouldAnimate) {
    setState(() {
      _isAnimating = shouldAnimate ?? !_isAnimating;
      if (_isAnimating) {
        _paintSector = widget.paintSector;
        _radarLineStrokeWidth = widget.radarLineStrokeWidth;
        _waveStrokeWidth = widget.waveStrokeWidth;
        _controller.repeat();
      } else {
        _controller.stop();
        _paintSector = false;
        _radarLineStrokeWidth = null;
        _waveStrokeWidth = null;
      }
    });
  }

  void _setNumberPoints({required int numberPoints}) {
    if (numberPoints > 0) {
      _numberPoints = numberPoints;
      setState(() {});
    }
  }
}

class RadarController {
  _RadarAnimationState? _state;
  bool _isAnimating = false;
  int _numberPoints = 0;
  bool get isAnimating => _isAnimating;
  int get numberPoints => _numberPoints;

  void _attach(_RadarAnimationState state) {
    _state = state;
    _isAnimating = state._isAnimating;
    _numberPoints = state._numberPoints;
  }

  void _detach() {
    _state = null;
  }

  void start() {
    _state?._setAnimationState(true);
    _isAnimating = _state?._isAnimating ?? false;
  }

  void stop() {
    _state?._setAnimationState(false);
    _isAnimating = _state?._isAnimating ?? false;
  }

  void toggle() {
    _state?._setAnimationState(null);
    _isAnimating = _state?._isAnimating ?? false;
  }

  void setNumberPoints({required int numberPoints}) {
    _state?._setNumberPoints(numberPoints: numberPoints);
    _numberPoints = _state?._numberPoints ?? 0;
  }
}

class RadarPoint {
  final Offset position;
  final double lifetime;
  double age = 0;
  RadarPoint(this.position, this.lifetime);

  factory RadarPoint.random({
    required double lifetime,
    required ValueNotifier<Offset> offsetEndPoint,
    required ValueNotifier<Offset> offsetCenter,
  }) {
    Offset start = offsetCenter.value;
    Offset end = offsetEndPoint.value;
    final Random random = Random();
    double t = random.nextDouble();
    double x = start.dx + t * (end.dx - start.dx);
    double y = start.dy + t * (end.dy - start.dy);
    Offset offset = Offset(x, y);
    return RadarPoint(offset, lifetime);
  }
}

class RadarPainter extends CustomPainter {
  final double animationValue;
  final List<RadarPoint> points;
  ValueNotifier<Offset> offsetEndPoint;
  ValueNotifier<Offset> offsetCenter;
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
  final double pointRadius;
  final Color pointColor;
  RadarPainter({
    required this.sectorColor,
    required this.paintSector,
    required this.gridColor,
    required this.gridStrokeWidth,
    required this.gridCircleCount,
    required this.gridCircleLinesCount,
    required this.waveStrokeWidth,
    required this.waveColor,
    required this.waveCount,
    required this.animationValue,
    required this.points,
    required this.offsetEndPoint,
    required this.offsetCenter,
    required this.radarLineStrokeWidth,
    required this.radarLineColor,
    required this.centerDotRadius,
    required this.centerDotColor,
    required this.pointRadius,
    required this.pointColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double maxRadius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double angle = animationValue * 2 * pi;
    final double sweepAngle = 180 * pi / 180;
    final Offset startPoint = Offset(center.dx + cos(angle) * maxRadius, center.dy + sin(angle) * maxRadius);
    final Offset endPoint = Offset(
      center.dx + cos(angle + sweepAngle) * maxRadius,
      center.dy + sin(angle + sweepAngle) * maxRadius,
    );
    offsetEndPoint.value = endPoint;
    offsetCenter.value = center;

    if (gridStrokeWidth != null) {
      _paintGrid(canvas: canvas, center: center, maxRadius: maxRadius);
    }

    if (waveStrokeWidth != null) {
      _paintWave(canvas: canvas, center: center, maxRadius: maxRadius);
    }

    if (paintSector == true) {
      _paintSector(
        angle: angle,
        center: center,
        maxRadius: maxRadius,
        startPoint: startPoint,
        sweepAngle: sweepAngle,
        endPoint: endPoint,
        canvas: canvas,
      );
    }

    if (radarLineStrokeWidth != null) {
      _paintRadarLine(canvas: canvas, center: center, endPoint: endPoint);
    }

    if (centerDotRadius != null) {
      _paintCenterDot(canvas: canvas, center: center);
    }

    final Paint pointPaint = Paint();
    for (var point in points) {
      point.age += 0.001;
      final double opacity = (1 - (point.age / point.lifetime)).clamp(0.0, 1.0);
      pointPaint.color = pointColor.withValues(alpha: opacity);

      canvas.drawCircle(point.position, pointRadius - point.age, pointPaint);
    }
  }

  void _paintCenterDot({required Canvas canvas, required Offset center}) {
    final Paint centerPaint = Paint();
    centerPaint.color = centerDotColor;
    canvas.drawCircle(center, centerDotRadius!, centerPaint);
  }

  void _paintRadarLine({required Canvas canvas, required Offset center, required Offset endPoint}) {
    final Paint linePaint =
        Paint()
          ..color = radarLineColor
          ..strokeWidth = radarLineStrokeWidth!;
    canvas.drawLine(center, endPoint, linePaint);
  }

  void _paintSector({
    required double angle,
    required Offset center,
    required double maxRadius,
    required Offset startPoint,
    required double sweepAngle,
    required Offset endPoint,
    required Canvas canvas,
  }) {
    final Paint sectorPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            transform: GradientRotation(angle),
            colors: [
              sectorColor.withValues(alpha: 1.0),
              sectorColor.withValues(alpha: 0.0),
              sectorColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(center.dx - maxRadius, center.dy - maxRadius, maxRadius * 2, maxRadius * 2))
          ..style = PaintingStyle.fill;

    Path path =
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(startPoint.dx, startPoint.dy)
          ..arcTo(Rect.fromCircle(center: center, radius: maxRadius), angle, sweepAngle, false)
          ..lineTo(center.dx, center.dy);

    canvas.drawPath(path, sectorPaint);
  }

  void _paintWave({required Canvas canvas, required Offset center, required double maxRadius}) {
    final Paint wavePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = waveStrokeWidth!;

    for (int i = 0; i < waveCount; i++) {
      double waveRadius = ((animationValue + i * 0.3) % 1) * maxRadius;
      wavePaint.color = waveColor.withAlpha((150 - waveRadius / maxRadius * 150).toInt());
      canvas.drawCircle(center, waveRadius, wavePaint);
    }
  }

  void _paintGrid({required Canvas canvas, required Offset center, required double maxRadius}) {
    final Paint gridPaint =
        Paint()
          ..color = gridColor.withAlpha(100)
          ..style = PaintingStyle.stroke
          ..strokeWidth = gridStrokeWidth!;

    // gridCircle
    for (int i = 1; i <= gridCircleCount; i++) {
      canvas.drawCircle(center, (maxRadius / gridCircleCount) * i, gridPaint);
    }

    //gridCircleLines
    for (int i = 0; i < gridCircleLinesCount; i++) {
      double angle = (pi / (gridCircleLinesCount / 2)) * i;
      final Offset endPoint = Offset(center.dx + cos(angle) * maxRadius, center.dy + sin(angle) * maxRadius);
      canvas.drawLine(center, endPoint, gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
