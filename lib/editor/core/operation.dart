import 'dart:ui';

abstract class Operation {
  Future<Image> execute(Image image);

  Future<Image> revert(Image image);
}
