import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_editor/generated/assets.dart';
import 'package:flutter_image_editor/home.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'editor/constants.dart';
import 'editor/core/editor.dart';

late ui.Image image;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  image = await imageFromAssets('assets/sample.jpg');
  final fragmentProgram =
      await Editor.shared.getFragmentProgram(Shaders.brightness);
  Editor.shared.createProject('sample.jpg', image);

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
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.sizeOf(context).width);
    return TransformableImageCanvas(
      canvasWidth: 1000,
      canvasHeight: 1000,
      imageWidth: image.width.toDouble(),
      imageHeight: image.height.toDouble(),
    );
  }
}

class TransformableImageCanvas extends StatefulWidget {
  final double canvasWidth;
  final double canvasHeight;

  final double imageWidth;
  final double imageHeight;

  const TransformableImageCanvas(
      {Key? key,
      required this.canvasWidth,
      required this.canvasHeight,
      required this.imageWidth,
      required this.imageHeight})
      : super(key: key);

  @override
  State<TransformableImageCanvas> createState() =>
      _TransformableImageCanvasState();
}

class _TransformableImageCanvasState extends State<TransformableImageCanvas> {
  Offset _position = Offset.zero;
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset? _lastFocalPoint;
  double _startRotation = 0.0;

  // Scale factors
  late final double _initialScale;
  late final double _minScale;
  late final double _maxScale;

  @override
  void initState() {
    super.initState();

    // Calculate the initial scale factor based on the image size relative to the canvas size
    // The initial scale should fit the image within the canvas
    _initialScale = calculateInitialScale(widget.imageWidth, widget.imageHeight,
        widget.canvasWidth, widget.canvasHeight);
    _minScale =
        _initialScale * 0.3; // Minimum scale is 10% of the initial scale
    _maxScale = 10.0; // Maximum scale is 500% of the initial scale

    // Set the initial scale
    _scale = _initialScale;
  }

  double calculateInitialScale(double imageWidth, double imageHeight,
      double canvasWidth, double canvasHeight) {
    // Calculate the scale factors for width and height separately
    double scaleFactorWidth = canvasWidth / imageWidth;
    double scaleFactorHeight = canvasHeight / imageHeight;

    // The initial scale factor is the minimum of the two scale factors
    return min(scaleFactorWidth, scaleFactorHeight);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _startRotation = _rotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Sensitivity factors
      double panSensitivity = 5.0; // Adjust this value as needed for panning.
      double scaleSensitivity = 0.5; // Adjust this value as needed for scaling.
      double rotationSensitivity =
          1.0; // Adjust this value as needed for rotation.

      // Pan
      if (_lastFocalPoint != null) {
        Offset panDelta =
            (details.focalPoint - _lastFocalPoint!) * panSensitivity;
        _position += panDelta;
        _lastFocalPoint = details.focalPoint;
      }

      // Scale with minimum and maximum limits and sensitivity
      double scaleDelta = (details.scale - 1.0) * scaleSensitivity;
      double newScale =
          _scale * (1 + scaleDelta); // Apply the delta as a percentage
      _scale = newScale.clamp(_minScale, _maxScale);

      // Rotation
      if (details.rotation != 0.0) {
        double rotationDelta = details.rotation * rotationSensitivity;
        _rotation = _startRotation + rotationDelta;
      }
    });

    if (kDebugMode) {
      print(
          'Rotation: $_rotation, Scale: $_scale, Max Scale: $_maxScale, Min Scale: $_minScale, Position: $_position');
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
  }

  GlobalKey _repaintBoundaryKey = GlobalKey();

  Matrix4 getTransformationMatrix() {
    // Create a new matrix for transformations
    final matrix = Matrix4.identity();
    // Translate to center the transformations around the image center
    matrix.translate(widget.canvasWidth / 2, widget.canvasHeight / 2);
    // Apply the rotation
    matrix.rotateZ(_rotation);
    // Apply the scale
    matrix.scale(_scale, _scale);
    // Translate back after transformations
    matrix.translate(-widget.canvasWidth / 2, -widget.canvasHeight / 2);
    // Apply the final translation
    matrix.translate(_position.dx, _position.dy);
    return matrix;
  }

  // Assuming you have a GlobalKey for your widget that you want to export.
  GlobalKey _globalKey = GlobalKey();

  // Define the main algorithm for saving the transformed image.
  Future<void> _saveImage() async {
    // Step 1: Obtain the pixel ratio of the device to ensure the image has the correct resolution.
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Step 2: Get the size of the widget on the screen after layout.
    final RenderBox renderBox = _globalKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    // Step 3: Calculate the scale factor that has been applied by the parent widget (like FittedBox).
    final double scaleX = (size.width * pixelRatio) / widget.canvasWidth;
    final double scaleY = (size.height * pixelRatio) / widget.canvasHeight;
    final double actualScale = min(scaleX, scaleY);

    // Step 4: Calculate the final size of the canvas considering the device pixel ratio and actual scale.
    final int finalCanvasWidth = (widget.canvasWidth * actualScale).floor();
    final int finalCanvasHeight = (widget.canvasHeight * actualScale).floor();

    // Step 5: Create a PictureRecorder to capture the canvas drawing operations.
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, finalCanvasWidth.toDouble(), finalCanvasHeight.toDouble()));

    // Step 6: Set the background color of the canvas to gray.
    canvas.drawColor(Colors.grey, BlendMode.src);

    // Step 7: Calculate the transformation matrix, adjusting for the scale, rotation, and translation.
    final Matrix4 transformationMatrix = Matrix4.identity()
      ..translate(finalCanvasWidth / 2.0, finalCanvasHeight / 2.0)
      ..scale(_initialScale * _scale * actualScale, _initialScale * _scale * actualScale)
      ..rotateZ(_rotation)
      ..translate(-widget.imageWidth / 2.0, -widget.imageHeight / 2.0)
      ..translate(_position.dx * actualScale, _position.dy * actualScale);

    // Step 8: Draw the image onto the canvas using the transformation matrix.
    final paint = Paint();
    canvas.save();
    canvas.transform(transformationMatrix.storage);
    canvas.drawImage(image, Offset.zero, paint);
    canvas.restore();

    // Step 9: Complete the drawing and convert the canvas to an image.
    final renderedImage = await recorder.endRecording().toImage(finalCanvasWidth, finalCanvasHeight);

    // Step 10: Convert the image to a byte array in PNG format.
    final byteData = await renderedImage.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    // Step 11: Save the image to the device's photo gallery.
    if (pngBytes != null) {
      final result = await ImageGallerySaver.saveImage(pngBytes, name: 'Output.png');
      print('Image saved: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        await _saveImage();
        },
        child: const Icon(Icons.save),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).width,
          child: FittedBox(
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: Container(
                key: _globalKey,
                color: Colors.grey,
                width: widget.canvasWidth,
                height: widget.canvasHeight,
                child: ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: CustomPaint(
                      size: Size(widget.canvasWidth, widget.canvasHeight),
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(_position.dx, _position.dy)
                            ..rotateZ(_rotation)
                            ..scale(_scale),
                          child: Image.asset(Assets.assetsSample)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditorImagePainter1 extends CustomPainter {
  final ui.Image image;
  final Offset offset;
  final double angle;
  final double scale;

  EditorImagePainter1({
    required this.image,
    required this.offset,
    required this.angle,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Create a new matrix for transformations
    final matrix = Matrix4.identity();
    // Apply the scale transformation around the center of the image
    matrix.scale(scale, scale);
    // Apply the rotation around the center of the image
    matrix.rotateZ(angle);
    // Translate the image to the desired offset
    matrix.translate(offset.dx, offset.dy);

    // Save the current canvas so we can restore it after drawing the image
    canvas.save();
    // Apply the matrix transformation to the canvas
    canvas.transform(matrix.storage);
    // Draw the image at the origin point (0,0) since the transformations have been applied
    canvas.drawImage(image, Offset.zero, paint);
    // Restore the canvas to its previous state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EditorImagePainter1 oldDelegate) {
    // You may want to optimize repainting by comparing the current state with the old state
    return image != oldDelegate.image ||
        offset != oldDelegate.offset ||
        angle != oldDelegate.angle ||
        scale != oldDelegate.scale;
  }
}
