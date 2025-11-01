import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'note_detail_page.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('My notes'),
      ),
      body: appState.notes.isEmpty
          ? Center(child: Text('You have no notes'))
          : ListView.builder(
              itemCount: appState.notes.length,
              itemBuilder: (context, index) {
                final note = appState.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailPage(note: note),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      appState.deleteNote(note.id);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}