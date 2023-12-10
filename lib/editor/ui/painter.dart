import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_image_editor/editor/utils.dart';

class ShaderPainter extends CustomPainter {
  final Image? image;
  final FragmentShader shader;
  final Iterable<double> uniforms;

  ShaderPainter(
      {super.repaint,
      required this.shader,
      this.image,
      required this.uniforms});

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) =>
      image != oldDelegate.image || shader != oldDelegate.shader;

  @override
  void paint(Canvas canvas, Size size) {
    [...uniforms, size.width, size.height].forEachIndexed((index, value) {
      shader.setFloat(index, value);
    });
    if (image != null) {
      shader.setImageSampler(0, image!);
    }
    final paint = Paint()..shader = shader;

    var vertices = Vertices(
      VertexMode.triangleStrip,
      [
        Offset(0, size.height),
        Offset(size.width, size.height),
        const Offset(0, 0),
        Offset(size.width, 0),
      ],
      textureCoordinates: [
        Offset(0, size.height),
        Offset(size.width, size.height),
        const Offset(0, 0),
        Offset(size.width, 0),
      ],
    );
    canvas.drawVertices(vertices, BlendMode.src, paint);
  }
}

class EditorImagePainter extends CustomPainter {
  final Image image;

  EditorImagePainter({super.repaint, required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant EditorImagePainter oldDelegate) =>
      image != oldDelegate.image;
}
