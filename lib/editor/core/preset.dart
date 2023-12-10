import 'dart:ui';
import 'operation.dart';
import 'transformation.dart';

class Preset extends Operation {
  final List<Transformation> transformations;
  final String name;
  Image? _original;

  Preset({required this.transformations, required this.name});

  @override
  Future<Image> execute(Image image) async {
    _original = image;
    Image temp = image;
    for (var transformation in transformations) {
      temp = await transformation.execute(temp);
    }
    return temp;
  }

  @override
  Future<Image> revert(Image image) async {
    return _original ?? image;
  }
}
