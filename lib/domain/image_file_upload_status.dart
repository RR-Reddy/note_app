class ImageFileUploadStatus{
  final String docId;
  final String localPath;
  String? remoteUrl;

  ImageFileUploadStatus(this.docId, this.localPath);

  @override
  String toString() {
    return 'ImageFileUploadStatus{docId: $docId, localPath: $localPath, remoteUrl: $remoteUrl}';
  }
}