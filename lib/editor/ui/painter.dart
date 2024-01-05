import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:flutter/rendering.dart';
import 'package:flutter_image_editor/editor/utils.dart';

class ImageShaderPainter extends CustomPainter {
  final Image image;
  final FragmentShader shader;
  final Iterable<double> uniforms;

  ImageShaderPainter(
      {super.repaint,
      required this.shader,
      required this.image,
      required this.uniforms});

  @override
  bool shouldRepaint(ImageShaderPainter oldDelegate) =>
      image != oldDelegate.image || shader != oldDelegate.shader;

  @override
  void paint(Canvas canvas, Size size) {
    [...uniforms, size.width, size.height].forEachIndexed((index, value) {
      shader.setFloat(index, value);
    });
    shader.setImageSampler(0, image);
      final paint = Paint()..shader = ui.Gradient.radial( Offset(size.width / 2, size.height / 2),
          size.width / 3,
          [Colors.transparent, Colors.blue],
          [0.0, 1.0],
          TileMode.clamp,
          null,
          Offset(size.width / 4, size.height / 4));

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
    final paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant EditorImagePainter oldDelegate) =>
      image != oldDelegate.image;
}
