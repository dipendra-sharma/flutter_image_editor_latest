import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }

  Future<bool> get cameraPermission async =>
      _requestPermission(Permission.camera);

  Future<bool> get photosPermission async =>
      _requestPermission(Permission.photos);

  Future<bool> get filesPermission async =>
      _requestPermission(Permission.storage);
}
