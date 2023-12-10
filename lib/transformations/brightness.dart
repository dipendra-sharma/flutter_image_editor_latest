import 'dart:ui';

import 'package:flutter_image_editor/editor/core/shaders.dart';
import 'package:flutter_image_editor/editor/core/transformation.dart';

class BrightnessTransformation extends Transformation
    with ShadersTransformation {
  final FragmentShader brightnessShader;
  final double brightness;

  BrightnessTransformation(
      {required this.brightnessShader, required this.brightness});

  @override
  Map<String, dynamic> get params => {'brightness': brightness};

  @override
  Iterable<double> get uniforms => [brightness];

  @override
  FragmentShader get shader => brightnessShader;
}
