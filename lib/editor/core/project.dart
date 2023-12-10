import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import 'operation.dart';
import 'preset.dart';
import 'transformation.dart';

class Project {
  final String name;
  final Image originalImage;
  final int _maxHistorySize = 10; // Limit history size
  late final ValueNotifier<Image> currentImage;
  final List<Operation> _history = [];
  int _currentPosition = -1;

  Project({required this.name, required this.originalImage}) {
    currentImage = ValueNotifier<Image>(originalImage);
  }

  Future<void> applyTransformation(Transformation transformation) async {
    if (_currentPosition + 1 >= _maxHistorySize) {
      // Remove oldest operation if history is full
      _history.removeAt(0);
      _currentPosition--;
    }
    _addOperation(transformation);
    currentImage.value = await transformation.apply(currentImage.value);
  }

  Future<void> applyPreset(Preset preset) async {
    if (_currentPosition + 1 >= _maxHistorySize) {
      _history.removeAt(0);
      _currentPosition--;
    }
    _addOperation(preset);
    currentImage.value = await preset.execute(currentImage.value);
  }

  Future<void> undo() async {
    if (_canUndo()) {
      Operation operation = _history[_currentPosition];
      currentImage.value = await operation.revert(currentImage.value);
      _currentPosition--;
    }
  }

  Future<void> redo() async {
    if (_canRedo()) {
      _currentPosition++;
      Operation operation = _history[_currentPosition];
      currentImage.value = await operation.execute(currentImage.value);
    }
  }

  void _addOperation(Operation operation) {
    _history.add(operation);
    _currentPosition++;
  }

  void reset() {
    currentImage.value = originalImage;
    _currentPosition = -1;
    _history.clear();
  }

  bool _canUndo() => _currentPosition >= 0;

  bool _canRedo() => _currentPosition < _history.length - 1;
}
