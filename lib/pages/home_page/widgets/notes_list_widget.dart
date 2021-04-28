import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/notes_data_cubit.dart';
import 'package:notes_app/extensions/extensions.dart';
import 'package:notes_app/pages/note_page/note_page.dart';

class NotesListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesDataCubit, NotesDataState>(
        builder: (context, state) {
      if (state.notes.isEmpty) {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Empty notes", style: context.textTheme.headline6),
            Container(height: 8),
            Text("Please create a note by tapping on add button")
          ],
        ));
      }

      return ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(endIndent: 20, color: Colors.black45),
          itemCount: state.notes.length,
          itemBuilder: (context, index) {
            var note = state.notes[index];

            return ListTile(
              title: Text(
                note.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                note.desc ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(NotePage.routeName, arguments: note);
              },
            );
          });
    });
  }
}
