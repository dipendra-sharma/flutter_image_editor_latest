import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_image_editor/editor/ui/painter.dart';

class EditorImagePreview extends StatefulWidget {
  final Image image;

  const EditorImagePreview({super.key, required this.image});

  @override
  State<EditorImagePreview> createState() => _EditorImagePreviewState();
}

class _EditorImagePreviewState extends State<EditorImagePreview> {
  @override
  Widget build(BuildContext context) {
    final image = widget.image;
    return InteractiveViewer(
      child: Center(
        child: FittedBox(
            fit: BoxFit.contain,
            child: CustomPaint(
              painter: EditorImagePainter(image: image),
              size: Size(
                image.width.toDouble(),
                image.height.toDouble(),
              ),
            )),
      ),
    );
  }
}
