import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_image_editor/editor/ui/painter.dart';
import 'package:flutter_image_editor/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final uniformNotifier = ValueNotifier(0.0);

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
          ValueListenableBuilder<double>(
              valueListenable: uniformNotifier,
              builder: (context, value, _) {
                return FittedBox(
                    fit: BoxFit.contain,
                    child: CustomPaint(
                      painter: ImageShaderPainter(
                          image: image,
                          shader: fragmentProgram.fragmentShader(),
                          uniforms: [value]),
                      size: Size(
                        image.width.toDouble(),
                        image.height.toDouble(),
                      ),
                    ));
              }),
          const Spacer(),
          ValueListenableBuilder<double>(
              valueListenable: uniformNotifier,
              builder: (context, value, _) {
                return Slider(
                    value: value,
                    max: 1,
                    min: 0,
                    divisions: 100,
                    onChanged: (changed) async {
                      uniformNotifier.value = changed;
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
