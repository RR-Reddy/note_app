import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/user_auth_cubit.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/extensions/extensions.dart';
import 'package:notes_app/pages/note_page/note_page.dart';

class NewNoteBtnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAuthCubit, bool>(builder: (context, isUserSignedIn) {
      if (isUserSignedIn.not) {
        return Container();
      }

      return FloatingActionButton(
          tooltip: 'Add Note',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(NotePage.routeName, arguments: Note());
          });
    });
  }
}
