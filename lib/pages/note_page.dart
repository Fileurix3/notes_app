import 'package:flutter/material.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/services/notes_services.dart';
import 'package:notes_app/widgets/edit_note.dart';
import 'package:notes_app/widgets/read_note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Future<NotesModel>? note;
  final notesServices = NotesServices();

  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  late int id;
  late String name;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    id = args["id"];
    name = args["name"];
    fetchNote();
  }

  void fetchNote() {
    setState(() {
      note = notesServices.getNoteById(id).then((fetchedNotes) {
        if (fetchedNotes.isNotEmpty) {
          final fetchedNote = fetchedNotes.first;
          descriptionController.text = fetchedNote.description ?? "";
          return fetchedNote;
        } else {
          throw Exception('Note not found');
        }
      });
    });
  }

  void _editNoteDescription(String description) async {
    await notesServices.updateNoteDescription(id, description);
    fetchNote();
    setState(() {
      isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEdit = !isEdit;
              });
            },
            icon: isEdit
              ? const Icon(Icons.clear)
              : const Icon(Icons.edit),
          )
        ],
      ),
      body: FutureBuilder<NotesModel>(
        future: note,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading note',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Note not found',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            );
          } else {
            return isEdit
              ? EditNote(
                  note: snapshot.data!,
                  onSave: _editNoteDescription,
                  descriptionController: descriptionController,
                )
              : ReadNote(
                  note: snapshot.data!,
                );
          }
        },
      ),
    );
  }
}