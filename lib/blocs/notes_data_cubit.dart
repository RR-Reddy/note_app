import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/blocs/user_auth_cubit.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/extensions/extensions.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/utils/app_utils.dart';

part 'notes_data_state.dart';

/// this bloc is responsible for sync notes data
class NotesDataCubit extends Cubit<NotesDataState> {
  final UserAuthCubit userAuthCubit;
  late StreamSubscription _authStateSubscription;
  StreamSubscription? _dataSubscription;

  NotesDataCubit(this.userAuthCubit)
      : super(NotesDataState(
            notes: [], timeStamp: DateTime.now().millisecondsSinceEpoch)) {
    _init();
  }

  void _init() {
    _authStateSubscription = userAuthCubit.stream.listen(_onAuthStateChange);
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

      for (var doc in snapshotData.docs) {
        String? title = doc.data()['t'] as String?;
        String? desc = doc.data()['d'] as String?;
        var note = Note.from(id: doc.id, title: title ?? '', desc: desc ?? '');
        noteList.add(note);
      }

      _emitData(noteList);
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

  @override
  Future<Function> close() {
    super.close();
    _authStateSubscription.cancel();
    _unSubscribeDataUpdates();
    return Future.value(() {});
  }
}
