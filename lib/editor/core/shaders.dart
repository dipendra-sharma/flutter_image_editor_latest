// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:ui';

import 'package:flutter_image_editor/editor/core/transformation.dart';

import '../ui/painter.dart';

mixin ShadersTransformation on Transformation {
  abstract final Iterable<double> uniforms;

  // Better to cache shader, this will cause high processing time
  abstract final FragmentShader shader;

  @override
  Future<Image> apply(Image image) async {
    PictureRecorder recorder = PictureRecorder();
    Size size = Size(image.width.toDouble(), image.height.toDouble());
    Canvas canvas = Canvas(recorder);
    final painter =
        ImageShaderPainter(shader: shader, uniforms: uniforms, image: image);
    painter.paint(canvas, size);
    Image renderedImage = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
    return renderedImage;
  }
}
