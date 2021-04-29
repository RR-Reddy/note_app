import 'package:image_picker/image_picker.dart';
import 'package:notes_app/extensions/extensions.dart';
import 'package:permission_handler/permission_handler.dart';

/// this services is responsible for notes data storage
class ImagePickService {
  static final ImagePickService _instance = ImagePickService._internal();

  ImagePickService._internal();

  factory ImagePickService() => _instance;

  Future<String?> getUserSelectedImagePath() async {
    /// handle runtime storage permission
    bool flag = await _handlePermissionPermanentlyDenied();
    if (flag) {
      return null;
    }

    var isGranted = await _requestPermission();

    if (isGranted.not) {
      return null;
    }

    /// pick image from image gallery
    final picker = ImagePicker();

    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null;
    }

    return pickedFile.path;
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> _isPermissionGranted() async {
    var status = await Permission.storage.status;
    return status == PermissionStatus.granted;
  }

  Future<bool> _handlePermissionPermanentlyDenied() async {
    bool flag = await Permission.storage.isPermanentlyDenied;

    if (flag) {
      openAppSettings();
    }

    return flag;
  }
}
