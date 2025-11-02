import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
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

  void copyNote() async {
    try {
      await FlutterClipboard.copy(contentController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Content copied!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 100,
            left: 16,
            right: 16
          ),
          duration: Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 100,
            left: 16,
            right: 16
          ),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  void copyTitle() async {
    try {
      await FlutterClipboard.copy(titleController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title copied!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 100,
            left: 16,
            right: 16
          ),
          duration: Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 100,
            left: 16,
            right: 16
          ),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  void pasteFromClipboard() async {
    try {
      dynamic data = await FlutterClipboard.paste();
      if (data != null) {
        setState(() {
          contentController.text += data.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pasted from clipboard!'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: 100,
              left: 16,
              right: 16
            ),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 100,
            left: 16,
            right: 16
          ),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
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
            Column(
              children: [
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: copyTitle,
                    icon: Icon(Icons.copy),
                    label: Text('Copy Title'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: copyNote,
                    icon: Icon(Icons.copy),
                    label: Text('Copy Note'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: pasteFromClipboard,
                    icon: Icon(Icons.paste),
                    label: Text('Paste'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
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