import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_editor/generated/assets.dart';
import 'package:flutter_image_editor/preset.dart';

void main() async {
  runApp(MaterialApp(
    title: 'Image Editor',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      useMaterial3: true,
    ),
    home: const FilterPage(),
  ));
}

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ColorFilter Example'),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 1, crossAxisSpacing: 1),
          padding: const EdgeInsets.all(1),
          itemBuilder: (context, position) => AppColorFiltered.merged(
            colorFilters: presetFiltersList[position],
            child: Image.asset(
              Assets.assetsSample,
              fit: BoxFit.cover,
            ),
          ),
          itemCount: presetFiltersList.length,
        ),
      ),
    );
  }
}

class AppColorFilter extends ColorFilter {
// | R' |   | a00 a01 a02 a03 a04 |   | R |
// | G' |   | a10 a11 a22 a33 a44 |   | G |
// | B' | = | a20 a21 a22 a33 a44 | * | B |
// | A' |   | a30 a31 a22 a33 a44 |   | A |
// | 1  |   |  0   0   0   0   1  |   | 1 |

  const AppColorFilter.mode(Color color, BlendMode blendMode)
      : super.mode(color, blendMode);

  const AppColorFilter.matrix(List<double> matrix) : super.matrix(matrix);

  const AppColorFilter.linearToSrgbGamma() : super.linearToSrgbGamma();

  const AppColorFilter.srgbToLinearGamma() : super.srgbToLinearGamma();

  AppColorFilter.colorOverlay(
      double red, double green, double blue, double scale)
      : super.matrix([
          ...[(1 - scale), 0, 0, 0, red * scale],
          ...[0, (1 - scale), 0, 0, green * scale],
          ...[0, 0, (1 - scale), 0, blue * scale],
          ...[0, 0, 0, 1, 0]
        ]);

  AppColorFilter.rgbScale(double r, double g, double b)
      : super.matrix([
          ...[r, 0, 0, 0, 0],
          ...[0, g, 0, 0, 0],
          ...[0, 0, b, 0, 0],
          ...[0, 0, 0, 1, 0]
        ]);

  AppColorFilter.addictiveColor(double r, double g, double b)
      : super.matrix([
          ...[1, 0, 0, 0, r],
          ...[0, 1, 0, 0, g],
          ...[0, 0, 1, 0, b],
          ...[0, 0, 0, 1, 0]
        ]);

  AppColorFilter.grayscale()
      : super.matrix([
          ...[0.2126, 0.7152, 0.0722, 0, 0],
          ...[0.2126, 0.7152, 0.0722, 0, 0],
          ...[0.2126, 0.7152, 0.0722, 0, 0],
          ...[0, 0, 0, 1, 0]
        ]);

  AppColorFilter.sepia(double value)
      : super.matrix([
          ...[(1 - (0.607 * value)), 0.769 * value, 0.189 * value, 0, 0],
          ...[0.349 * value, (1 - (0.314 * value)), 0.168 * value, 0, 0],
          ...[0.272 * value, 0.534 * value, (1 - (0.869 * value)), 0, 0],
          ...[0, 0, 0, 1, 0]
        ]);

  AppColorFilter.invert()
      : super.matrix([
          ...[-1, 0, 0, 0, 255],
          ...[0, -1, 0, 0, 255],
          ...[0, 0, -1, 0, 255],
          ...[0, 0, 0, 1, 0]
        ]);

  AppColorFilter.contrast(double value) : super.matrix(_contrast(value));

  static List<double> _contrast(double value) {
    double adj = value * 255;
    double factor = (259 * (adj + 255)) / (255 * (259 - adj));
    return [
      ...[factor, 0, 0, 0, 128 * (1 - factor)],
      ...[0, factor, 0, 0, 128 * (1 - factor)],
      ...[0, 0, factor, 0, 128 * (1 - factor)],
      ...[0, 0, 0, 1, 0],
    ];
  }

  AppColorFilter.brightness(double value) : super.matrix(_brightness(value));

  static List<double> _brightness(double value) {
    if (value <= 0) {
      value = value * 255;
    } else {
      value = value * 100;
    }

    if (value == 0) {
      return [
        ...[1, 0, 0, 0, 0],
        ...[0, 1, 0, 0, 0],
        ...[0, 0, 1, 0, 0],
        ...[0, 0, 0, 1, 0],
      ];
    }

    return List<double>.from(<double>[
      ...[1, 0, 0, 0, value],
      ...[0, 1, 0, 0, value],
      ...[0, 0, 1, 0, value],
      ...[0, 0, 0, 1, 0]
    ]).map((i) => i.toDouble()).toList();
  }

  AppColorFilter.hue(double value) : super.matrix(_hue(value));

  static List<double> _hue(double value) {
    value = value * pi;

    if (value == 0) {
      return [
        ...[1, 0, 0, 0, 0],
        ...[0, 1, 0, 0, 0],
        ...[0, 0, 1, 0, 0],
        ...[0, 0, 0, 1, 0],
      ];
    }

    var cosVal = cos(value);
    var sinVal = sin(value);
    var lumR = 0.213;
    var lumG = 0.715;
    var lumB = 0.072;

    return List<double>.from(<double>[
      ...[
        (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
        (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
        (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
        0,
        0
      ],
      ...[
        (lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
        (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
        (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
        0,
        0
      ],
      ...[
        (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
        (lumG + (cosVal * (-lumG))) + (sinVal * lumG),
        (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
        0,
        0
      ],
      ...[0, 0, 0, 1, 0],
    ]).map((i) => i.toDouble()).toList();
  }

  AppColorFilter.saturation(double value) : super.matrix(_saturation(value));

  static List<double> _saturation(double value) {
    value = value * 100;
    if (value == 0) {
      return [
        ...[1, 0, 0, 0, 0],
        ...[0, 1, 0, 0, 0],
        ...[0, 0, 1, 0, 0],
        ...[0, 0, 0, 1, 0],
      ];
    }

    var x =
        ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
    var lumR = 0.3086;
    var lumG = 0.6094;
    var lumB = 0.082;

    return List<double>.from(<double>[
      ...[(lumR * (1 - x)) + x, lumG * (1 - x), lumB * (1 - x), 0, 0],
      ...[lumR * (1 - x), (lumG * (1 - x)) + x, lumB * (1 - x), 0, 0],
      ...[lumR * (1 - x), lumG * (1 - x), (lumB * (1 - x)) + x, 0, 0],
      ...[0, 0, 0, 1, 0],
    ]).map((i) => i.toDouble()).toList();
  }

  AppColorFilter.temperature(double value)
      : super.matrix([
          ...[1, 0, 0, 0, 128 * value],
          ...[0, 1, 0, 0, 0],
          ...[0, 0, 1, 0, -128 * value],
          ...[0, 0, 0, 1, 0],
        ]);

  // Need to test
  AppColorFilter.gamma(double gamma)
      : super.matrix([
          ...[pow(255, 1 - 1 / gamma).toDouble(), 0, 0, 0, 0],
          ...[0, pow(255, 1 - 1 / gamma).toDouble(), 0, 0, 0],
          ...[0, 0, pow(255, 1 - 1 / gamma).toDouble(), 0, 0],
          ...[0, 0, 0, 1, 0],
        ]);

  AppColorFilter.opacity(double opacity)
      : super.matrix([
          ...[1, 0, 0, 0, 0],
          ...[0, 1, 0, 0, 0],
          ...[0, 0, 1, 0, 0],
          ...[0, 0, 0, opacity, 0], // Adjust alpha channel
        ]);
}

class AppColorFiltered extends ColorFiltered {
  const AppColorFiltered({super.child, super.key, required super.colorFilter});

  static Widget merged(
      {required Widget child,
      Key? key,
      required List<ColorFilter> colorFilters}) {
    Widget tree = child;
    for (int i = 0; i < colorFilters.length; i++) {
      tree = ColorFiltered(
        colorFilter: colorFilters[i],
        child: tree,
      );
    }
    return tree;
  }
}
