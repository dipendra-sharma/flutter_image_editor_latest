import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_image_editor/editor/core/editor.dart';
import 'package:flutter_image_editor/editor/ui/preview.dart';
import 'package:flutter_image_editor/transformations/brightness.dart';

import 'editor/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final image = await imageFromAssets('assets/sample.jpg');
  final fragmentProgram =
      await Editor.shared.getFragmentProgram(Shaders.brightness);
  Editor.shared.createProject('sample.jpg', image);

  runApp(MaterialApp(
    title: 'Image Editor',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      useMaterial3: true,
    ),
    home: HomePage(image: image, fragmentProgram: fragmentProgram),
  ));
}

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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Editor.shared.undo();
            },
            child: const Icon(Icons.undo),
          ),
          FloatingActionButton(
            onPressed: () {
              Editor.shared.redo();
            },
            child: const Icon(Icons.redo),
          ),
          FloatingActionButton(
            onPressed: () {
              Editor.shared.reset();
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
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
                              brightnessShader: (await Editor.shared
                                      .getFragmentProgram(Shaders.brightness))
                                  .fragmentShader(),
                              brightness: changed));
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
