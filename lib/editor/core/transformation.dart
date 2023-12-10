import 'dart:ui';
import 'operation.dart';

abstract class Transformation extends Operation {
  abstract final Map<String, dynamic> params;

  String get name => runtimeType.toString();
  TransformationPermanence get permanence => TransformationPermanence.permanent;

  Image? _original;

  @override
  Future<Image> execute(Image image) {
    _original = image;
    return apply(image);
  }

  @override
  Future<Image> revert(Image image) async {
    return _original ?? image;
  }

  Future<Image> apply(Image image);
}

enum TransformationPermanence {
  temporary,
  permanent,
  nonDestructive,
  destructive
}
