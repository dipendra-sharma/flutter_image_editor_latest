import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:ui';

class PBImagePicker {
  final ImagePicker _picker = ImagePicker();

  Future<Image> pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      throw NoImageFoundException();
    }
    final bytes = await pickedFile.readAsBytes();
    return await bytes.toImage();
  }

  Future<Image> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      throw NoImageFoundException();
    }
    final bytes = await pickedFile.readAsBytes();
    return await bytes.toImage();
  }

  Future<List<Image>> pickMultipleFromGallery() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isEmpty) {
      throw NoImageFoundException();
    }

    List<Image> imagesList = [];
    for (var file in pickedFiles) {
      final bytes = await file.readAsBytes();
      imagesList.add(await bytes.toImage());
    }

    return imagesList;
  }

  Future<Image> pickFromFileManager() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      throw NoImageFoundException();
    }
    final path = result.files.first.path;
    if (path == null) {
      throw NoImageFoundException();
    }
    return result.files.first.bytes!.toImage();
  }

  Future<List<Image>> pickMultipleFromFileManager() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      throw NoImageFoundException();
    }
    final imagesList = <Image>[];
    for (final file in result.files) {
      if (file.path != null) {
        imagesList.add(await file.bytes!.toImage());
      }
    }
    return imagesList;
  }
}

extension Uint8ListExt on Uint8List {
  Future<Image> toImage() async {
    final Codec codec = await instantiateImageCodec(this);
    final FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class NoImageFoundException implements Exception {
  final String message;
  NoImageFoundException([this.message = "No Image found"]);

  @override
  String toString() => message;
}
