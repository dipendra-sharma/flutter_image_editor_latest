import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_image_editor/transformations/brightness.dart';

import 'editor/constants.dart';
import 'editor/core/editor.dart';
import 'editor/ui/preview.dart';

class HomePage extends StatefulWidget {
  final Image image;
  final FragmentProgram fragmentProgram;

  const HomePage(
      {super.key, required this.image, required this.fragmentProgram});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imageStream = StreamController<Image>();
  final sharpness = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
        actions: const [],
      ),
      body: SafeArea(
          child: Column(
        children: [
          ValueListenableBuilder<Image>(
              valueListenable: Editor.shared.currentImage,
              builder: (context, image, _) {
                return EditorImagePreview(image: image);
              }),
          const Spacer(),
          ValueListenableBuilder<double>(
              valueListenable: sharpness,
              builder: (context, value, _) {
                return Slider(
                    value: value,
                    max: 1,
                    min: -1,
                    divisions: 20,
                    onChanged: (changed) async {
                      Editor.shared.applyTransformation(
                          BrightnessTransformation(
                              brightness: changed,
                              brightnessShader:
                                  widget.fragmentProgram.fragmentShader()));
                      sharpness.value = changed;
                    });
              }),
          const Spacer()
        ],
      )),
    );
  }
}

Future<Image> imageFromAssets(String path) async {
  ByteData data = await rootBundle.load(path);
  Uint8List bytes = data.buffer.asUint8List();
  final Codec codec = await instantiateImageCodec(bytes);
  final FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}
