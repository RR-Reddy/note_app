import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/utils/app_utils.dart';

class ConnectivityCubic extends Cubit<bool> {
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityCubic() : super(false) {
    _init();
  }

  bool get isConnected=> this.state;

  void _init()async{
    await Future.delayed(Duration(microseconds: 1));
    addConnectivityListener();
    _handleAndroidBackground();
  }

  void _handleAndroidBackground(){
    if (Platform.isAndroid) {

      Future<String?> handler (String? msg)async{
        if ("AppLifecycleState.resumed" == msg) {
          this.addConnectivityListener();
        }
        return msg;
      }

      SystemChannels.lifecycle.setMessageHandler(handler);
    }
  }

  @override
  Future<Function> close() {
    super.close();
    _subscription?.cancel();
    return Future.value(() {});
  }

  void addConnectivityListener() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    emit(connectivityResult == ConnectivityResult.none ? false : true);

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      emit(result == ConnectivityResult.none ? false : true);
    });
  }

  @override
  void onChange(Change<bool> change) {
    super.onChange(change);
    AppUtils.logMsg(this, '$change');

  }


}