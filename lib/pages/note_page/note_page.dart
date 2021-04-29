import 'package:flutter/material.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/pages/note_page/widgets/image_widget.dart';
import 'package:notes_app/services/firestore_service.dart';
import 'package:notes_app/services/image_pick_service.dart';

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

  bool? _isLocalImagePresent;
  String? _imagePathOrUrl;

  @override
  void initState() {
    super.initState();
    isNewNote = widget.note.id == null;
    _titleController = TextEditingController(text: widget.note.title ?? '');
    _descController = TextEditingController(text: widget.note.desc ?? '');

    _isLocalImagePresent = widget.note.isImageAvailable
        ? widget.note.isImageAvailableAtLocal
        : null;

    _imagePathOrUrl = widget.note.imagePathOrUrl;
  }

  @override
  Widget build(BuildContext context) {
    var title = isNewNote ? "Create Note" : "Edit Note";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [_buildSaveBtnWidget()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTitleWidget(),
              _buildDescWidget(),
              _buildImageWidget()
            ],
          ),
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

  Widget _buildImageWidget() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: ImageWidget(
              isImageFromLocalStorage: _isLocalImagePresent,
              imagePathOrUrl: _imagePathOrUrl,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: Icon(Icons.upload_rounded), onPressed: _onUploadTap),
                IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteTap),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onUploadTap() async {
    // check permissions
    String? imagePath = await ImagePickService().getUserSelectedImagePath();

    setState(() {
      _isLocalImagePresent = true;
      _imagePathOrUrl = imagePath;
    });
  }

  void _onDeleteTap() {
    setState(() {
      _isLocalImagePresent = null;
      _imagePathOrUrl = null;
    });
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

    /// finalize image path or remote url or no image at all
    String? imageLocalStoragePath;
    String? imageRemoteStorageUrl;

    if (_isLocalImagePresent != null) {
      imageLocalStoragePath = _imagePathOrUrl;
      imageRemoteStorageUrl = null;
    } else if (widget.note.isImageAvailableAtRemote) {
      imageLocalStoragePath = null;
      imageRemoteStorageUrl = widget.note.imageRemoteStorageUrl;
    }

    /// save or update note
    var note = Note.from(
      id: widget.note.id,
      title: title,
      desc: desc,
      imageLocalStoragePath: imageLocalStoragePath,
      imageRemoteStorageUrl: imageRemoteStorageUrl,
    );

    FireStoreService().saveOrUpdateNote(note);
    Navigator.of(context).pop();
  }
}
