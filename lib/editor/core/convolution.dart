import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_image_editor/editor/core/transformation.dart';

mixin ConvolutionTransformation on Transformation {
  abstract final List<double> weights;
  abstract final double bias;

  @override
  Future<Image> apply(Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ImageByteFormat.rawRgba);
    if (byteData == null) throw Exception('Failed to convert image to bytes');
    var pixels = byteData.buffer.asUint8List();
    var bytes = Uint8List.fromList(pixels);
    int side = sqrt(weights.length).round();
    int halfSide = ~~(side / 2).round() - side % 2;
    int sw = image.width;
    int sh = image.height;

    int w = sw;
    int h = sh;

    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        int sy = y;
        int sx = x;
        int dstOff = (y * w + x) * 4;
        num r = bias, g = bias, b = bias;
        for (int cy = 0; cy < side; cy++) {
          for (int cx = 0; cx < side; cx++) {
            int scy = sy + cy - halfSide;
            int scx = sx + cx - halfSide;

            if (scy >= 0 && scy < sh && scx >= 0 && scx < sw) {
              int srcOff = (scy * sw + scx) * 4;
              num wt = weights[cy * side + cx];

              r += bytes[srcOff] * wt;
              g += bytes[srcOff + 1] * wt;
              b += bytes[srcOff + 2] * wt;
            }
          }
        }
        pixels[dstOff] = clampPixel(r.round());
        pixels[dstOff + 1] = clampPixel(g.round());
        pixels[dstOff + 2] = clampPixel(b.round());
      }
    }

    final Completer<Image> completer = Completer();
    decodeImageFromPixels(
      pixels,
      sw,
      sh,
      PixelFormat.rgba8888,
          (Image img) {
        completer.complete(img);
      },
    );
    return await completer.future;
  }
}

int clampPixel(int x) => x.clamp(0, 255);

const List<double> identityKernel = [0, 0, 0, 0, 1, 0, 0, 0, 0];
const List<double> sharpenKernel = [-1, -1, -1, -1, 9, -1, -1, -1, -1];
const List<double> embossKernel = [-1, -1, 0, -1, 0, 1, 0, 1, 1];
const List<double> coloredEdgeDetectionKernel = [1, 1, 1, 1, -7, 1, 1, 1, 1];
const List<double> edgeDetectionMediumKernel = [0, 1, 0, 1, -4, 1, 0, 1, 0];
const List<double> edgeDetectionHardKernel = [
  -1,
  -1,
  -1,
  -1,
  8,
  -1,
  -1,
  -1,
  -1
];

const List<double> blurKernel = [
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  1,
  1,
  0,
  1,
  1,
  1,
  1,
  1,
  0,
  1,
  1,
  1,
  0,
  0,
  0,
  1,
  0,
  0
];

const List<double> guassian3x3Kernel = [
  1,
  2,
  1,
  2,
  4,
  2,
  1,
  2,
  1,
];

const List<double> guassian5x5Kernel = [
  2,
  04,
  05,
  04,
  2,
  4,
  09,
  12,
  09,
  4,
  5,
  12,
  15,
  12,
  5,
  4,
  09,
  12,
  09,
  4,
  2,
  04,
  05,
  04,
  2
];

const List<double> guassian7x7Kernel = [
  1,
  1,
  2,
  2,
  2,
  1,
  1,
  1,
  2,
  2,
  4,
  2,
  2,
  1,
  2,
  2,
  4,
  8,
  4,
  2,
  2,
  2,
  4,
  8,
  16,
  8,
  4,
  2,
  2,
  2,
  4,
  8,
  4,
  2,
  2,
  1,
  2,
  2,
  4,
  2,
  2,
  1,
  1,
  1,
  2,
  2,
  2,
  1,
  1,
];

const List<double> mean3x3Kernel = [
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
];

const List<double> mean5x5Kernel = [
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1
];

const List<double> lowPass3x3Kernel = [
  1,
  2,
  1,
  2,
  4,
  2,
  1,
  2,
  1,
];

const List<double> lowPass5x5Kernel = [
  1,
  1,
  1,
  1,
  1,
  1,
  4,
  4,
  4,
  1,
  1,
  4,
  12,
  4,
  1,
  1,
  4,
  4,
  4,
  1,
  1,
  1,
  1,
  1,
  1,
];

const List<double> highPass3x3Kernel = [
  0,
  -0.25,
  0,
  -0.25,
  2,
  -0.25,
  0,
  -0.25,
  0
];
