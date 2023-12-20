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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
                .findRenderObject() as RenderRepaintBoundary;
            ui.Image image = await boundary.toImage(pixelRatio: 1.0);
            ByteData? byteData =
                await image.toByteData(format: ui.ImageByteFormat.png);
            Uint8List pngBytes = byteData!.buffer.asUint8List();
            try {
              await ImageGallerySaver.saveImage(pngBytes!, name: 'Output.png');
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
            print('Image saved');
          } catch (e) {
            print(e.toString());
          }
          return;
          ui.PictureRecorder recorder = ui.PictureRecorder();
          Size size = Size(widget.canvasHeight, widget.canvasHeight);
          Canvas canvas = Canvas(recorder);
          final painter = EditorImagePainter1(
              image: image, offset: _position, angle: _rotation, scale: _scale);
          painter.paint(canvas, size);
          ui.Image renderedImage = await recorder
              .endRecording()
              .toImage(size.width.floor(), size.height.floor());

          // Convert the image to a byte array
          final byteData =
              await renderedImage.toByteData(format: ui.ImageByteFormat.png);
          final pngBytes = byteData?.buffer.asUint8List();

          try {
            await ImageGallerySaver.saveImage(pngBytes!, name: 'Output.png');
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
          print('Image saved');
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
