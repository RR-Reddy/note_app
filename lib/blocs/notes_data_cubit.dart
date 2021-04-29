import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/blocs/connectivity_cubic.dart';
import 'package:notes_app/blocs/user_auth_cubit.dart';
import 'package:notes_app/domain/image_file_upload_status.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/extensions/extensions.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/services/fire_cloud_storagte_service.dart';
import 'package:notes_app/utils/app_utils.dart';

part 'notes_data_state.dart';

/// this bloc is responsible for sync notes data
class NotesDataCubit extends Cubit<NotesDataState> {
  final UserAuthCubit userAuthCubit;
  final ConnectivityCubic connectivityCubic;
  late StreamSubscription _authStateSubscription;
  late StreamSubscription _connectivityStateSubscription;
  StreamSubscription? _dataSubscription;

  NotesDataCubit(this.userAuthCubit,this.connectivityCubic)
      : super(NotesDataState(
            notes: [], timeStamp: DateTime.now().millisecondsSinceEpoch)) {
    _init();
  }

  void _init() {
    _authStateSubscription = userAuthCubit.stream.listen(_onAuthStateChange);
    _connectivityStateSubscription=connectivityCubic.stream.listen(_onConnectivityChange);
  }

  void _onConnectivityChange(bool isConnected){

    if(isConnected.not||AuthService().isSignedIn.not){
    return;
    }

    List<ImageFileUploadStatus> statusList=[];

    for(var note in this.state.notes){

      if(note.isImageAvailableAtLocal){
        statusList.add(ImageFileUploadStatus(note.id!,note.imageLocalStoragePath!));
      }
    }

    _uploadImagesToCloud(statusList);


  }


  void _onAuthStateChange(bool isSignedIn) {
    if (isSignedIn) {
      // sync data
      _subscribeDataUpdates();
    } else {
      // clear data
      _emitData([]);
      _unSubscribeDataUpdates();
    }
  }

  void _subscribeDataUpdates() {
    var colRef = FirebaseFirestore.instance.collection(AuthService().uid);
    colRef.snapshots().listen((snapshotData) {
      if ((snapshotData.size > 0).not) {
        return;
      }

      List<Note> noteList = [];
      List<ImageFileUploadStatus> statusList=[];

      for (var doc in snapshotData.docs) {
        String? title = doc.data()['t'] as String?;
        String? desc = doc.data()['d'] as String?;
        String? imageLocalStoragePath = doc.data()['lp'] as String?;
        String? imageRemoteStorageUrl = doc.data()['rp'] as String?;
        var note = Note.from(
          id: doc.id,
          title: title ?? '',
          desc: desc ?? '',
          imageLocalStoragePath: imageLocalStoragePath,
          imageRemoteStorageUrl: imageRemoteStorageUrl,
        );
        noteList.add(note);

        if(note.isImageAvailableAtLocal){
          statusList.add(ImageFileUploadStatus(note.id!,note.imageLocalStoragePath!));
        }

      }
      _emitData(noteList);
      _uploadImagesToCloud(statusList);
    });
  }

  void _unSubscribeDataUpdates() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
  }

  void _emitData(List<Note> notes) {
    emit(state.copyWith(notes: notes));
    AppUtils.logMsg(this, 'note data list size : ${notes.length}');
  }

  Future<void> _uploadImagesToCloud(List<ImageFileUploadStatus> statusList) async{

    if(connectivityCubic.isConnected.not || statusList.isEmpty){
      return;
    }
    FireCloudStorageService().uploadToCloud(statusList);

  }

  @override
  Future<Function> close() {
    super.close();
    _authStateSubscription.cancel();
    _connectivityStateSubscription.cancel();
    _unSubscribeDataUpdates();
    return Future.value(() {});
  }
}
