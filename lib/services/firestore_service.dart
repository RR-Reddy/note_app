import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/services/auth_service.dart';

/// this services is responsible for notes data storage
class FireStoreService {
  static final FireStoreService _instance = FireStoreService._internal();

  FireStoreService._internal();

  factory FireStoreService() => _instance;

  Future<void> saveOrUpdateNote(Note note) async {
    Map<String, dynamic> data = {
      't': note.title,
      'd': note.desc,
    };

    if (note.isNewNote) {
      var colRef = FirebaseFirestore.instance.collection(AuthService().uid);
      await colRef.add(data);
    } else {
      var docRef =
          FirebaseFirestore.instance.collection(AuthService().uid).doc(note.id);
      await docRef.set(data);
    }
  }
}
