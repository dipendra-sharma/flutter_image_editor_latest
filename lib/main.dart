import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_editor/home.dart';

late ui.Image image;
late ui.FragmentProgram fragmentProgram;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  image = await imageFromAssets('assets/sample.jpg');
  fragmentProgram =
      await ui.FragmentProgram.fromAsset('shaders/sharpness.frag');

  runApp(MaterialApp(
    title: 'Image Editor',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}