import 'dart:io';

const Map<String, List<String>> _supportedFormats = {
  'android': ['jpg', 'jpeg', 'png', 'webp', 'bmp', 'gif'],
  'ios': ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff']
};

bool isSupported(String? imageFormat) {
  if (imageFormat == null) {
    throw ArgumentError('Image format cannot be null');
  }

  String platform = Platform.isAndroid
      ? 'android'
      : (Platform.isIOS ? 'ios' : Platform.operatingSystem);
  imageFormat = imageFormat.toLowerCase();

  if (!_supportedFormats.containsKey(platform)) {
    throw Exception('Platform $platform is not supported');
  }
  return _supportedFormats[platform]!.contains(imageFormat);
}

extension ListExtension<T> on List<T> {
  void forEachIndexed(void Function(int index, T item) function) {
    for (var index = 0; index < length; index++) {
      function(index, this[index]);
    }
  }
}
