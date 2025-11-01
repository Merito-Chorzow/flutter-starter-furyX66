import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/app_state.dart';

class NoteDetailPage extends StatefulWidget {
  final Note? note;

  const NoteDetailPage ({this.note});

  @override
  State<NoteDetailPage> createState() => NoteDetailPageState();
}

class NoteDetailPageState extends State<NoteDetailPage>{
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState(){
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? "");
    contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  @override
  void dispose(){
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.read<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New note' : 'Editing'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill the title')),
                    );
                    return;
                  }

                  if (widget.note == null) {
                    appState.addNote(
                      titleController.text,
                      contentController.text,
                    );
                  } else {
                    appState.updateNote(
                      widget.note!.id,
                      titleController.text,
                      contentController.text,
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
}