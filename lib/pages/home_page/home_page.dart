import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/user_auth_cubit.dart';
import 'package:notes_app/pages/home_page/widgets/drawer_widget.dart';
import 'package:notes_app/pages/home_page/widgets/new_note_btn_widget.dart';
import 'package:notes_app/pages/home_page/widgets/notes_list_widget.dart';
import 'package:notes_app/services/auth_service.dart';

/// HOME UI Page
class HomePage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      drawer: DrawerWidget(),
      floatingActionButton: NewNoteBtnWidget(),
      body: BlocBuilder<UserAuthCubit, bool>(builder: (context, isSignedIn) {
        if (isSignedIn) {
          return NotesListWidget();
        }

        return Center(
          child: ElevatedButton(
            child: Text("SignIn / SignUp"),
            onPressed: () => AuthService().startAuthUiFlow(),
          ),
        );
      }),
    );
  }
}
