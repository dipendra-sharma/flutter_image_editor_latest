import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import '../main.dart';

abstract class DrawableItem {
  Offset position;
  double scale;
  bool isSelected;
  Paint selectionPaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

  DrawableItem({
    required this.position,
    this.scale = 1.0,
    this.isSelected = false,
  });

  // Method to draw the item on the canvas.
  void draw(Canvas canvas);

  // Method to check if a point is within the item's bounds (for selection).
  bool hitTest(Offset point);

  // Method to update the item's position.
  void updatePosition(Offset newPosition) {
    position = newPosition;
  }

  // Method to update the item's scale.
  void updateScale(double newScale) {
    scale = newScale;
  }

  // Method to select or deselect the item.
  void toggleSelection() {
    isSelected = !isSelected;
  }

  // Draw a selection box around the item if it is selected.
  void drawSelectionBox(Canvas canvas, Rect bounds) {
    if (isSelected) {
      canvas.drawRect(bounds, selectionPaint);
    }
  }
}

// Implementation for an image drawable item.
class ImageDrawableItem extends DrawableItem {
  Image image;

  ImageDrawableItem({
    required this.image,
    required super.position,
    super.scale,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.scale(scale);
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.restore();

    // Draw selection box if selected.
    if (isSelected) {
      drawSelectionBox(
          canvas,
          Rect.fromLTWH(position.dx, position.dy, image.width.toDouble(),
              image.height.toDouble()));
    }
  }

  @override
  bool hitTest(Offset point) {
    final imageRect = Rect.fromLTWH(position.dx, position.dy,
        image.width.toDouble() * scale, image.height.toDouble() * scale);
    return imageRect.contains(point);
  }
}

// // Implementation for a text drawable item.
// class TextDrawableItem extends DrawableItem {
//   String text;
//   TextStyle style;
//   TextPainter textPainter;
//
//   TextDrawableItem({
//     required this.text,
//     required super.position,
//     this.style = const TextStyle(color: Colors.black),
//     super.scale,
//     super.isSelected,
//   }) : textPainter = TextPainter(
//           text: TextSpan(text: text, style: style),
//           textDirection: TextDirection.ltr,
//         );
//
//   @override
//   void draw(Canvas canvas) {
//     canvas.save();
//     canvas.translate(position.dx, position.dy);
//     canvas.scale(scale);
//     textPainter.layout();
//     textPainter.paint(canvas, Offset.zero);
//     canvas.restore();
//
//     // Draw selection box if selected.
//     if (isSelected) {
//       drawSelectionBox(
//           canvas,
//           Rect.fromLTWH(
//               position.dx, position.dy, textPainter.width, textPainter.height));
//     }
//   }
//
//   @override
//   bool hitTest(Offset point) {
//     final textRect = Rect.fromLTWH(position.dx, position.dy,
//         textPainter.width * scale, textPainter.height * scale);
//     return textRect.contains(point);
//   }
// }
//
// // Implementation for an emoji drawable item (treated as text).
// class EmojiDrawableItem extends TextDrawableItem {
//   EmojiDrawableItem({
//     required String emoji,
//     required super.position,
//     super.style = const TextStyle(fontFamily: 'EmojiOne', fontSize: 32),
//     super.scale,
//     super.isSelected,
//   }) : super(text: emoji);
// }
//
// // Implementation for a shape drawable item.
// class ShapeDrawableItem extends DrawableItem {
//   Paint paint;
//   Path path;
//
//   ShapeDrawableItem({
//     required this.path,
//     required this.paint,
//     required super.position,
//     super.scale,
//     super.isSelected,
//   });
//
//   @override
//   void draw(Canvas canvas) {
//     canvas.save();
//     canvas.translate(position.dx, position.dy);
//     canvas.scale(scale);
//     canvas.drawPath(path, paint);
//     canvas.restore();
//
//     // Draw selection box if selected.
//     if (isSelected) {
//       final bounds = path.getBounds();
//       drawSelectionBox(
//           canvas,
//           Rect.fromLTWH(position.dx + bounds.left, position.dy + bounds.top,
//               bounds.width, bounds.height));
//     }
//   }
//
//   @override
//   bool hitTest(Offset point) {
//     // For simplicity, we're using the bounding box of the path.
//     // A more accurate hit test would involve checking if the point is within the path itself.
//     final bounds = path.getBounds();
//     final scaledBounds = Rect.fromLTWH(
//         position.dx + bounds.left * scale,
//         position.dy + bounds.top * scale,
//         bounds.width * scale,
//         bounds.height * scale);
//     return scaledBounds.contains(point);
//   }
// }
//
// // Implementation for a path drawable item.
// class PathDrawableItem extends DrawableItem {
//   Paint paint;
//   Path path;
//
//   PathDrawableItem({
//     required this.path,
//     required this.paint,
//     required super.position,
//     super.scale,
//     super.isSelected,
//   });
//
//   @override
//   void draw(Canvas canvas) {
//     canvas.save();
//     canvas.translate(position.dx, position.dy);
//     canvas.scale(scale);
//     canvas.drawPath(path, paint);
//     canvas.restore();
//
//     // Draw selection box if selected.
//     if (isSelected) {
//       final bounds = path.getBounds();
//       drawSelectionBox(
//           canvas,
//           Rect.fromLTWH(position.dx + bounds.left, position.dy + bounds.top,
//               bounds.width, bounds.height));
//     }
//   }
//
//   @override
//   bool hitTest(Offset point) {
//     // Similar to ShapeDrawableItem, we use the bounding box for hit testing.
//     final bounds = path.getBounds();
//     final scaledBounds = Rect.fromLTWH(
//         position.dx + bounds.left * scale,
//         position.dy + bounds.top * scale,
//         bounds.width * scale,
//         bounds.height * scale);
//     return scaledBounds.contains(point);
//   }
// }

class AppCanvasWidget extends StatefulWidget {
  const AppCanvasWidget({super.key});

  @override
  State<AppCanvasWidget> createState() => _AppCanvasWidgetState();
}

// ... (Other imports and DrawableItem classes)

class _AppCanvasWidgetState extends State<AppCanvasWidget> {
  List<DrawableItem> items = []; // List of drawable items
  DrawableItem? selectedItem;
  Rect? selectionRect; // Rectangle for the selection box

  @override
  void initState() {
    super.initState();
    // Initialize your items here
    // Example:
    items.add(ImageDrawableItem(image: image, position: const Offset(0,0), scale: 0.5));
  }

  void updateSelection(DrawableItem item) {
    setState(() {
      selectedItem = item;
      // Calculate the selection rectangle based on the item's properties
      // Assuming width and height are defined in DrawableItem
      selectionRect = Rect.fromLTWH(
        item.position.dx,
        item.position.dy,
        item.scale * image.width,
        item.scale * image.height,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final Offset position = details.localPosition;
        selectedItem = null;
        for (var item in items.reversed) {
          if (item.hitTest(position)) {
            selectedItem = item;
            item.toggleSelection();
            updateSelection(item);
            break;
          }
        }
      },
      onPanUpdate: (details) {
        print(details.delta);
        print(details.globalPosition);
        print(details.localPosition);
        print(details.primaryDelta);
        if (selectedItem != null) {
          setState(() {
            selectedItem!.updatePosition(selectedItem!.position + details.delta);
            updateSelection(selectedItem!);
          });
        }
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: CanvasPainter(items),
            size: Size(300, 300),
          ),
          if (selectionRect != null)
            Positioned.fromRect(
              rect: selectionRect!,
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ... (CanvasPainter and other classes)


class CanvasPainter extends CustomPainter {
  final List<DrawableItem> items;

  // final DrawableItem? selectedItem;

  CanvasPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in items) {
      item.draw(canvas);
      // if (selectedItem == item) {
      //   item.drawSelectionBox(canvas,
      //       item.getBounds()); // Assuming getBounds() method is implemented
      // }
    }
    canvas.drawColor(Colors.grey, BlendMode.dstIn);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class InteractiveViewerWithRotation extends StatefulWidget {
  final Widget child;

  const InteractiveViewerWithRotation({super.key, required this.child});

  @override
  State<InteractiveViewerWithRotation> createState() =>
      _InteractiveViewerWithRotationState();
}

class _InteractiveViewerWithRotationState
    extends State<InteractiveViewerWithRotation> {
  Offset _position = Offset.zero;
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset? _lastFocalPoint;
  double _startRotation = 0.0;

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _startRotation = _rotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Pan
      if (_lastFocalPoint != null) {
        _position += (details.focalPoint - _lastFocalPoint!);
        _lastFocalPoint = details.focalPoint;
      }

      // Scale with minimum and maximum limits
      double minScale = 0.5; // Set your desired minimum scale factor
      double maxScale = 1.0; // Set your desired maximum scale factor
      double newScale = _scale * details.scale;
      _scale = newScale.clamp(
          minScale, maxScale); // Clamp the scale to stay within the limits

      // Rotation
      if (details.rotation != 0.0) {
        _rotation = _startRotation + details.rotation;
      }
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(_position.dx, _position.dy)
          ..rotateZ(_rotation)
          ..scale(_scale),
        child: widget.child,
      ),
    );
  }

  double calculateImageScaleFactor({
    required double canvasWidth,
    required double canvasHeight,
    required double imageWidth,
    required double imageHeight,
    required double marginPercentage,
  }) {
    // Calculate the available space for the image
    double availableWidth = canvasWidth * (1 - marginPercentage);
    double availableHeight = canvasHeight * (1 - marginPercentage);

    // Calculate the scale factors for width and height separately
    double scaleFactorWidth = availableWidth / imageWidth;
    double scaleFactorHeight = availableHeight / imageHeight;

    // The final scale factor is the minimum of the two scale factors
    double scaleFactor = scaleFactorWidth < scaleFactorHeight
        ? scaleFactorWidth
        : scaleFactorHeight;

    return scaleFactor;
  }
}

// ChangeNotifier class to manage the state of the rotation and position
class RotationPositionNotifier with ChangeNotifier {
  double _previousAngle = 0.0;
  double _angle = 0.0;
  Offset _position = Offset.zero;
  double _scale = 1.0; // Add a variable to keep track of the scale

  double get previousAngle => _previousAngle;

  double get angle => _angle;

  Offset get position => _position;

  double get scale => _scale; // Getter for the scale

  // Method to update the angle and notify listeners
  void updateRotation(double newAngle) {
    _angle = newAngle;
    notifyListeners();
  }

  void updatePreviousAngle(double newAngle) {
    _previousAngle = newAngle;
    notifyListeners();
  }

  // Method to update the position and notify listeners
  void updatePosition(Offset newPositionDelta) {
    _position += newPositionDelta;
    notifyListeners();
  }

  // Method to update the scale and notify listeners
  void updateScale(double newScale) {
    _scale = newScale;
    notifyListeners();
  }
}
