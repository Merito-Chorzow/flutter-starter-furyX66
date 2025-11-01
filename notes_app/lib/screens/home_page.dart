import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'note_detail_page.dart';

class MyHomePage extends StatelessWidget {
  void copyNote(BuildContext context, String title, String content) async {
    final noteText = 'Title: $title\n\nContent: $content';
    
    try {
      await FlutterClipboard.copy(noteText);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note copied to clipboard!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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