import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/notes_data_cubit.dart';
import 'package:notes_app/blocs/user_auth_cubit.dart';
import 'package:notes_app/routes/routes_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// setting for mobile orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// initialize firebase
  await Firebase.initializeApp();

  var app = MultiBlocProvider(providers: [
    BlocProvider<UserAuthCubit>(
      lazy: false,
      create: (BuildContext context) => UserAuthCubit(),
    ),
    BlocProvider<NotesDataCubit>(
      lazy: false,
      create: (BuildContext context) => NotesDataCubit(context.read<UserAuthCubit>()),
    ),
  ], child: EasyDynamicThemeWidget(
    child: App(),
  ));

  runApp(app);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData.light().copyWith(primaryColor: Colors.teal),
      darkTheme: ThemeData.dark(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesUtil.onGenerateRoute,
    );
  }
}



