import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/services/notes_services.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Future<List<NotesModel>>? note;
  final notesServices = NotesServices();

  String description = "";
  TextEditingController descriptionContraller = TextEditingController();
  bool isEdit = false;

  late int id;
  late String name;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    id = args["id"];
    name = args["name"];
    fetchNote(id);
  }

  void fetchNote(int id) async {
  final fetchedNotes = await notesServices.getNoteById(id);
  if (fetchedNotes.isNotEmpty) {
    final fetchedNote = fetchedNotes.first;
    setState(() {
      note = Future.value([fetchedNote]);
      description = fetchedNote.description ?? "";
      descriptionContraller.text = description;
    });
  }
}

  void _editNoteDescription(String description) async {
    await notesServices.updateNoteDescription(id, description);
    fetchNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                isEdit = !isEdit;
              });
            }, 
            icon: isEdit 
              ? const Icon(Icons.clear) 
              : const Icon(Icons.edit)
          )
        ],
      ),
      body: FutureBuilder(
        future: note, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.data == null || snapshot.data!.isEmpty){
            return const Center(
              child: Text(
                "There is nothing",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w300
                ),
              )
            );
          }else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(isEdit)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: MarkdownField(
                        controller: descriptionContraller,
                        emojiConvert: true,
                        style: Theme.of(context).textTheme.labelLarge,
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      )
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                    child: description.isEmpty 
                    ? const Center(
                      child: Text(
                        "There is nothing",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300
                        ),
                      )
                    )
                    : Center(
                      child: MarkdownBody(
                        data: description,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(fontSize: 20)
                        ),
                      ),
                    )
                  ),
                  if(isEdit)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: (){
                          _editNoteDescription(description);
                        }, 
                        child: Text(
                          "Submit",
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      )
                    )
                ],
              ),
            );
          }
        }
      )
    );
  }
}