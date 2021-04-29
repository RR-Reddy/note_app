/// data class
class Note {
  String? id;
  String? title;
  String? desc;

  String? imageLocalStoragePath;
  String? imageRemoteStorageUrl;

  Note();

  Note.from({
    this.id,
    this.title,
    this.desc,
    this.imageLocalStoragePath,
    this.imageRemoteStorageUrl,
  });

  @override
  String toString() {
    return 'Note{id: $id, title: $title, desc: $desc, imageLocalStoragePath: $imageLocalStoragePath, imageRemoteStorageUrl: $imageRemoteStorageUrl}';
  }

  bool get isNewNote => id == null;

  bool get isImageAvailable =>
      imageLocalStoragePath != null || imageRemoteStorageUrl != null;

  bool get isImageAvailableAtLocal => imageLocalStoragePath != null;

  bool get isImageAvailableAtRemote => imageRemoteStorageUrl != null;

  String? get imagePathOrUrl {

    if(isImageAvailableAtRemote){
      return imageRemoteStorageUrl;
    }

    if(isImageAvailableAtLocal){
      return imageLocalStoragePath;
    }

    return null;

  }

}
