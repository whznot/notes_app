import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NotesApp());

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'notes',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'GeneralSans',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'ClashDisplay',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
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
  int? _editingIndex;
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          if (_editingIndex == index) {
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'enter note title',
                        hintStyle: TextStyle(
                          fontFamily: 'ClashDisplay',
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontFamily: 'ClashDisplay',
                      ),
                      onSubmitted: (_) {
                        _saveEditedNote();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: _saveEditedNote,
                  ),
                ],
              ),
            );
          }
          return Slidable(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: ((context) {
                    _startEditingNoteAt(index);
                  }),
                  backgroundColor: Color(0xFF2c2c2c),
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: ((context) {
                    _confirmDeletingNoteAt(index);
                  }),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                _notes[index],
                style: TextStyle(
                  fontFamily: 'ClashDisplay',
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add),
        heroTag: 'add',
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String noteTitle = '';

          return AlertDialog(
            title: Text(
              'creating a note',
              style: TextStyle(
                fontFamily: 'ClashDisplay',
              ),
            ),
            content: TextField(
              onChanged: (value) {
                noteTitle = value;
              },
              decoration: InputDecoration(
                hintText: 'enter note title',
                hintStyle: TextStyle(
                  fontFamily: 'ClashDisplay',
                ),
              ),
              style: TextStyle(
                fontFamily: 'ClashDisplay',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'cancel',
                  style: TextStyle(
                    fontFamily: 'ClashDisplay',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text(
                    'add',
                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                    ),
                  ),
                  onPressed: () {
                    if (noteTitle.isNotEmpty) {
                      _addNote(noteTitle);
                    }
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', _notes);
  }

  void _startEditingNoteAt(int index) {
    setState(() {
      _editingIndex = index;
      _editingController.text = _notes[index];
      _editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _editingController.text.length),
      );
    });
  }

  void _saveEditedNote() {
    if (_editingIndex != null && _editingController.text.isNotEmpty) {
      _notes[_editingIndex!] = _editingController.text;
      _editingIndex = null;
      _editingController.clear();
      _saveNotes();
      setState(() {});
    }
  }

  void _addNote(String title) {
    _notes.add(title);
    _saveNotes();
    setState(() {});
  }

  void _confirmDeletingNoteAt(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'deleting the note',
              style: TextStyle(fontFamily: 'ClashDisplay'),
            ),
            content: Text(
              'are you sure?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'cancel',
                  style: TextStyle(
                    fontFamily: 'ClashDisplay',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'delete',
                  style: TextStyle(
                    fontFamily: 'ClashDisplay',
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _notes.removeAt(index);
                    _saveNotes();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
