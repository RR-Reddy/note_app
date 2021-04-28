import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/utils/app_utils.dart';

/// this bloc is responsible for User authentication state changes
class UserAuthCubit extends Cubit<bool> {
  StreamSubscription? _streamSubscription;

  UserAuthCubit() : super(false) {
    _init();
  }

  void _init() {
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChange);
  }

  void _onAuthStateChange(User? user) {
    bool isUserSignedIn = user != null;
    emit(isUserSignedIn);
    AppUtils.logMsg(this, " isUserSignedIn -> $isUserSignedIn  ");
  }

  @override
  Future<Function> close() {
    super.close();
    _streamSubscription?.cancel();
    return Future.value(() {});
  }
}
