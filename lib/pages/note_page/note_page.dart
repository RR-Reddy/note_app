import 'package:flutter/material.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/services/firestore_service.dart';

/// NOTE create or edit UI page
class NotePage extends StatefulWidget {
  static const routeName = '/note_page';

  final Note note;

  const NotePage({Key? key, required this.note}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late bool isNewNote;

  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    isNewNote = widget.note.id == null;
    _titleController = TextEditingController(text: widget.note.title ?? '');
    _descController = TextEditingController(text: widget.note.desc ?? '');
  }

  @override
  Widget build(BuildContext context) {
    var title = isNewNote ? "Create Note" : "Edit Note";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [_buildSaveBtnWidget()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [_buildTitleWidget(), _buildDescWidget()],
        ),
      ),
    );
  }

  Widget _buildSaveBtnWidget() {
    return Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.save),
        tooltip: 'Save',
        onPressed: () => onSaveTap(context),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDescWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        controller: _descController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: 'Detail',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void onSaveTap(BuildContext context) {

    // close keyboard
    FocusScope.of(context).unfocus();

    var title = _titleController.text.trim().toString();
    var desc = _descController.text.trim().toString();

    // validation
    if (title.isEmpty) {
      var snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Title should not be empty"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // save or update note
    var note = Note.from(id: widget.note.id, title: title, desc: desc);
    FireStoreService().saveOrUpdateNote(note);
    Navigator.of(context).pop();
  }
}
