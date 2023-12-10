import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;

import '../constants.dart';
import 'preset.dart';
import 'project.dart';
import 'transformation.dart';

class Editor {
  Project? _project;
  final _shaderMap = <String, FragmentProgram>{};

  static final Editor _singleton = Editor._internal();

  Editor._internal();

  static Editor get shared {
    return _singleton;
  }

  Project get _currentProject {
    if (_project == null) throw Exception('Project not loaded');
    return _project!;
  }

  ValueNotifier<Image> get currentImage {
    return _currentProject.currentImage;
  }

  Future<void> applyTransformation(Transformation transformation) {
    return _currentProject.applyTransformation(transformation);
  }

  Future<void> applyPreset(Preset preset) {
    return _currentProject.applyPreset(preset);
  }

  Future<void> undo() {
    return _currentProject.undo();
  }

  Future<void> redo() {
    return _currentProject.redo();
  }

  void reset() {
    _currentProject.reset();
  }

  createProject(String name, Image image) {
    if (_project != null) {
      throw Exception('Project ${_project?.name} is already open');
    }
    _project = Project(name: name, originalImage: image);
  }

  void close() {
    // Save project and clear it.
    _project = null;
  }

  Future<FragmentProgram> getFragmentProgram(Shaders file) async {
    if (_shaderMap.containsKey(file.name)) {
      return _shaderMap[file.name]!;
    } else {
      final shader =
          await FragmentProgram.fromAsset('shaders/${file.name}.frag');
      _shaderMap[file.name] = shader;
      return shader;
    }
  }
}
