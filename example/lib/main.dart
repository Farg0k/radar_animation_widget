import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:radar_animation_widget/radar_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<bool> darkMode = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkMode,
      builder: (BuildContext context, bool value, child) {
        return MaterialApp(
          title: 'Radar Widget Demo',
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
          ),
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
          themeMode: value == true ? ThemeMode.dark : ThemeMode.light,
          home: MyHomePage(title: 'Radar Widget Demo', darkMode: darkMode),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.darkMode});
  final String title;
  final ValueNotifier<bool> darkMode;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _useLens = true;
  double _dimension = 300;
  Color _backgroundColor = Colors.black;
  Duration _duration = const Duration(seconds: 10);
  int _numberPoints = 2;
  double _pointRadius = 5;
  Color _pointColor = Colors.green;
  Color _sectorColor = Colors.green;
  bool _paintSector = true;
  Color _gridColor = Colors.green;
  double? _gridStrokeWidth = 1;
  int _gridCircleCount = 6;
  int _gridCircleLinesCount = 12;
  double? _waveStrokeWidth = 5;
  Color _waveColor = Colors.green;
  int _waveCount = 3;
  double? _radarLineStrokeWidth = 3;
  Color _radarLineColor = Colors.green;
  double? _centerDotRadius = 5;
  Color _centerDotColor = Colors.green;
  Color _lensColor = Colors.cyan;
  Color _borderColor = Colors.white70;
  double _lensBlur = 0.4;
  bool _lensGlow = true;
  RadarController controller = RadarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [Switch(value: widget.darkMode.value, onChanged: (value) => widget.darkMode.value = value)],
      ),
      floatingActionButton: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              controller.setNumberPoints(numberPoints: controller.numberPoints + 1);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("numberPoints: ${controller.numberPoints}")));
            },
            child: Icon(Icons.plus_one),
          ),
          FloatingActionButton(
            onPressed: () {
              controller.toggle();
              setState(() {});
            },
            child: controller.isAnimating == true ? Icon(Icons.toggle_off) : Icon(Icons.toggle_on_outlined),
          ),
          FloatingActionButton(
            onPressed: () {
              controller.setNumberPoints(numberPoints: controller.numberPoints - 1);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("numberPoints: ${controller.numberPoints}")));
            },
            child: Icon(Icons.exposure_minus_1),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: <Widget>[
            RadarAnimationWidget(
              key: Key(_duration.inSeconds.toString()),
              controller: controller,
              useLens: _useLens,
              dimension: _dimension,
              backgroundColor: _backgroundColor,
              duration: _duration,
              numberPoints: _numberPoints,
              pointRadius: _pointRadius,
              pointColor: _pointColor,
              sectorColor: _sectorColor,
              paintSector: _paintSector,
              gridColor: _gridColor,
              gridStrokeWidth: _gridStrokeWidth,
              gridCircleCount: _gridCircleCount,
              gridCircleLinesCount: _gridCircleLinesCount,
              waveStrokeWidth: _waveStrokeWidth,
              waveColor: _waveColor,
              waveCount: _waveCount,
              radarLineStrokeWidth: _radarLineStrokeWidth,
              radarLineColor: _radarLineColor,
              centerDotRadius: _centerDotRadius,
              centerDotColor: _centerDotColor,
              lensColor: _lensColor,
              borderColor: _borderColor,
              lensBlur: _lensBlur,
              lensGlow: _lensGlow,
            ),
            const Text('Settings:'),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SwitchListTile(
                    title: const Text("useLens"),
                    value: _useLens,
                    onChanged: (val) {
                      setState(() => _useLens = val);
                    },
                  ),
                  _buildSlider(
                    label: "dimension",
                    value: _dimension,
                    min: 100,
                    max: 350,
                    onChanged: (val) {
                      setState(() => _dimension = val);
                    },
                  ),
                  ListTile(
                    title: Text('backgroundColor'),
                    trailing: Container(width: 24, height: 24, color: _backgroundColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _backgroundColor);
                      if (color != null) {
                        setState(() => _backgroundColor = color);
                      }
                    },
                  ),
                  _buildSlider(
                    label: "duration",
                    value: _duration.inSeconds.toDouble(),
                    min: 1,
                    max: 20,
                    onChanged: (val) {
                      setState(() => _duration = Duration(seconds: val.toInt()));
                    },
                  ),
                  _buildSlider(
                    label: "numberPoints",
                    value: _numberPoints.toDouble(),
                    min: 0,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _numberPoints = val.toInt());
                    },
                  ),
                  _buildSlider(
                    label: "pointRadius",
                    value: _pointRadius,
                    min: 1,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _pointRadius = val);
                    },
                  ),
                  ListTile(
                    title: Text('pointColor'),
                    trailing: Container(width: 24, height: 24, color: _pointColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _pointColor);
                      if (color != null) {
                        setState(() => _pointColor = color);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('sectorColor'),
                    trailing: Container(width: 24, height: 24, color: _sectorColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _sectorColor);
                      if (color != null) {
                        setState(() => _sectorColor = color);
                      }
                    },
                  ),
                  SwitchListTile(
                    title: const Text("paintSector"),
                    value: _paintSector,
                    onChanged: (val) {
                      setState(() => _paintSector = val);
                    },
                  ),
                  ListTile(
                    title: Text('gridColor'),
                    trailing: Container(width: 24, height: 24, color: _gridColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _gridColor);
                      if (color != null) {
                        setState(() => _gridColor = color);
                      }
                    },
                  ),
                  _buildSlider(
                    label: "gridStrokeWidth",
                    value: _gridStrokeWidth,
                    min: 0,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _gridStrokeWidth = val == 0 ? null : val);
                    },
                  ),
                  _buildSlider(
                    label: "gridCircleCount",
                    value: _gridCircleCount.toDouble(),
                    min: 1,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _gridCircleCount = val.toInt());
                    },
                  ),
                  _buildSlider(
                    label: "gridCircleLinesCount",
                    value: _gridCircleLinesCount.toDouble(),
                    min: 1,
                    max: 20,
                    onChanged: (val) {
                      setState(() => _gridCircleLinesCount = val.toInt());
                    },
                  ),
                  _buildSlider(
                    label: "waveStrokeWidth",
                    value: _waveStrokeWidth,
                    min: 0,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _waveStrokeWidth = val == 0 ? null : val);
                    },
                  ),
                  ListTile(
                    title: Text('waveColor'),
                    trailing: Container(width: 24, height: 24, color: _waveColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _waveColor);
                      if (color != null) {
                        setState(() => _waveColor = color);
                      }
                    },
                  ),
                  _buildSlider(
                    label: "waveCount",
                    value: _waveCount.toDouble(),
                    min: 1,
                    max: 20,
                    onChanged: (val) {
                      setState(() => _waveCount = val.toInt());
                    },
                  ),
                  _buildSlider(
                    label: "radarLineStrokeWidth",
                    value: _radarLineStrokeWidth,
                    min: 0,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _radarLineStrokeWidth = val == 0 ? null : val);
                    },
                  ),
                  ListTile(
                    title: Text('radarLineColor'),
                    trailing: Container(width: 24, height: 24, color: _radarLineColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _radarLineColor);
                      if (color != null) {
                        setState(() => _radarLineColor = color);
                      }
                    },
                  ),
                  _buildSlider(
                    label: "centerDotRadius",
                    value: _centerDotRadius,
                    min: 0,
                    max: 10,
                    onChanged: (val) {
                      setState(() => _centerDotRadius = val == 0 ? null : val);
                    },
                  ),
                  ListTile(
                    title: Text('centerDotColor'),
                    trailing: Container(width: 24, height: 24, color: _centerDotColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _centerDotColor);
                      if (color != null) {
                        setState(() => _centerDotColor = color);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('lensColor'),
                    trailing: Container(width: 24, height: 24, color: _lensColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _lensColor);
                      if (color != null) {
                        setState(() => _lensColor = color);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('borderColor'),
                    trailing: Container(width: 24, height: 24, color: _borderColor),
                    onTap: () async {
                      Color? color = await _pickColor(context, _borderColor);
                      if (color != null) {
                        setState(() => _borderColor = color);
                      }
                    },
                  ),
                  _buildSlider(
                    label: "lensBlur",
                    value: _lensBlur,
                    min: 0,
                    max: 3,
                    onChanged: (val) {
                      setState(() => _lensBlur = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text("lensGlow"),
                    value: _lensGlow,
                    onChanged: (val) {
                      setState(() => _lensGlow = val);
                    },
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildSlider({
    required String label,
    double? value,
    required double min,
    required double max,
    required Function(double) onChanged,
    int? divisions,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(value == null ? '$label: null' : "$label: ${(value).toStringAsFixed(1)}"),
        Expanded(
          child: Slider(
            value: value ?? 0,
            min: min,
            max: max,
            divisions: divisions ?? (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<Color?> _pickColor(BuildContext context, Color currentColor) async {
    return showDialog<Color>(
      context: context,
      builder: (context) {
        Color selectedColor = currentColor;
        return AlertDialog(
          title: Text('Pick Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
            TextButton(child: Text('Ok'), onPressed: () => Navigator.pop(context, selectedColor)),
          ],
        );
      },
    );
  }
}
