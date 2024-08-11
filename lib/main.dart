import 'package:flutter/material.dart';

void main() => runApp(NotesApp());

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'notes',
      home: NotesListScreen(),
    );
  }
}

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<String> _notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('notes'),
        ),
        body: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_notes[index]),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _showAddNoteDialog,
              child: Icon(Icons.add),
              heroTag: 'add',
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _removeLastNote,
              child: Icon(Icons.remove),
              heroTag: 'remove',
            )
          ],
        ));
  }

  void _showAddNoteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String noteTitle = '';

          return AlertDialog(
            title: Text('creating a note'),
            content: TextField(
              onChanged: (value) {
                noteTitle = value;
              },
              decoration: InputDecoration(hintText: 'enter note title'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('add'),
                  onPressed: () {
                    if (noteTitle.isNotEmpty) {
                      _addNote(noteTitle);
                    }
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void _addNote(String title) {
    setState(() {
      _notes.add(title);
    });
  }

  void _removeLastNote() {
    if (_notes.isNotEmpty) {
      setState(() {
        _notes.removeLast();
      });
    }
  }
}
