import 'package:flutter/material.dart';
import '../models/note.dart';

class MyAppState extends ChangeNotifier {
  List<Note> notes = [];

  void addNote(String title, String content){
    final note = Note(
      id: DateTime.now().toString(),
      title: title,
      content: content,
      createdAt: DateTime.now()
    );
    notes.add(note);
    notifyListeners();
  }

  void deleteNote (String id){
    notes.removeWhere((note)=>note.id==id);
    notifyListeners();
  }

  void updateNote (String id, String title, String content){
    final index = notes.indexWhere((note)=>note.id==id);
    if (index !=-1){
      notes[index]=Note(
        id:id,
        title: title,
        content: content,
        createdAt: notes[index].createdAt,
      );
    }
    notifyListeners();
  }
}