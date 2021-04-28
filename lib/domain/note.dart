/// data class
class Note {
  String? id;
  String? title;
  String? desc;

  Note();

  Note.from({this.id, this.title, this.desc});

  @override
  String toString() {
    return 'Note{id: $id, title: $title, desc: $desc}';
  }

  bool get isNewNote=>id==null;
}
