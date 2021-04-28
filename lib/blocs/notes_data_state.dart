part of 'notes_data_cubit.dart';

@immutable
class NotesDataState {
  final List<Note> notes;
  final int timeStamp;

  NotesDataState({required this.notes, required this.timeStamp});

  NotesDataState copyWith({
    required List<Note> notes,
  }) {
    return NotesDataState(
      notes: notes,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  String toString() {
    return 'NotesDataState{notes: $notes, timeStamp: $timeStamp}';
  }
}
