import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as cloudStorage;
import 'package:notes_app/domain/image_file_upload_status.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/firestore_service.dart';
import 'package:notes_app/utils/app_utils.dart';
import 'package:path/path.dart' as p;

/// this services is responsible for notes data storage
class FireCloudStorageService {
  static final FireCloudStorageService _instance =
      FireCloudStorageService._internal();

  FireCloudStorageService._internal();

  factory FireCloudStorageService() => _instance;

  Future<void> uploadToCloud(List<ImageFileUploadStatus> statusList) async {
    List<ImageFileUploadStatus> successList = [];

    var storage = cloudStorage.FirebaseStorage.instance;
    for (var fileUploadStatus in statusList) {
      String remotePath =
          "/note_images/${AuthService().uid}_${fileUploadStatus.docId}${p.extension(fileUploadStatus.localPath)}";
      var ref = storage.ref(remotePath);
      var isUploaded = await _uploadFile(ref, fileUploadStatus.localPath);
      if (isUploaded) {
        String remoteUrl = await storage.ref(remotePath).getDownloadURL();
        fileUploadStatus.remoteUrl = remoteUrl;
        successList.add(fileUploadStatus);
      }
    }

    _updateNotesWithRemoteUrl(successList);
  }

  Future<bool> _uploadFile(cloudStorage.Reference ref, String filePath) async {
    bool fileUploadStatus = false;

    try {
      File file = File(filePath);
      var uploadTask = await ref.putFile(file);
      while (uploadTask.state == cloudStorage.TaskState.running ||
          uploadTask.state == cloudStorage.TaskState.paused) {}

      if (uploadTask.state == cloudStorage.TaskState.success) {
        /// file upload success
        fileUploadStatus = true;
      }
    } on Exception catch (e) {
      AppUtils.logMsg(this, "error : $e");
    }

    return fileUploadStatus;
  }

  Future<void> _updateNotesWithRemoteUrl(
      List<ImageFileUploadStatus> successList) async {
    for (var fileUploadStatus in successList) {
      FireStoreService()
          .updateRemoteUrl(fileUploadStatus.docId, fileUploadStatus.remoteUrl!);
    }
  }
}
