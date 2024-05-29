import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/services/notes_services.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {

  Future<List<NotesModel>>? notesList;
  final notesServices = NotesServices();

  final TextEditingController nameController = TextEditingController();

  late int folderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    folderId = ModalRoute.of(context)!.settings.arguments as int;
    fetchNotes(folderId);
  }

  void fetchNotes(int folderId) async {
    setState(() {
      notesList = notesServices.getNotesByFolderId(folderId);
    });
  }

  void _addNewNote(int folderId, String name) async {
    await notesServices.insertNotesByFolderId(folderId, name);
    fetchNotes(folderId);
  }

  void _editNote(int id, String newName) async {
    await notesServices.updateNotes(id, newName);
    fetchNotes(folderId);
  }

  void _deleteNote(int id) async {
    await notesServices.deleteNote(id);
    fetchNotes(folderId);
  }

  void addNotes() {
    showDialog(
      context: context, 
      builder: (coontext) {
        return AlertDialog(
          elevation: 1,
          title: const Text("Add note"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "name"
            ),
            style: Theme.of(context).textTheme.labelLarge,
            maxLength: 50,
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                if(nameController.text.isNotEmpty){
                  Navigator.pop(context);
                  _addNewNote(folderId, nameController.text);
                  nameController.clear();
                }
              }, 
              child: Text(
                "Add",
                style: Theme.of(context).textTheme.labelMedium,
              )
            )
          ],
        );
      }
    );
  }

  void editNote(id) {
    showDialog(
      context: context, 
      builder: (coontext) {
        return AlertDialog(
          elevation: 1,
          title: const Text("edit note"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "new name"
            ),
            style: Theme.of(context).textTheme.labelLarge,
            maxLength: 50,
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                if(nameController.text.isNotEmpty){
                  Navigator.pop(context);
                  _editNote(id, nameController.text);
                  nameController.clear();
                }
              }, 
              child: Text(
                "Edit",
                style: Theme.of(context).textTheme.labelMedium,
              )
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes list"),
      ),
      body: FutureBuilder(
        future: notesList, 
        builder: (builder, snapshot) {
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
          }else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context){
                          _deleteNote(snapshot.data![index].id);
                        }),
                        backgroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.delete,
                      ),
                      SlidableAction(
                        onPressed: ((context){
                          editNote(snapshot.data![index].id);
                        }),
                        backgroundColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.edit,
                      )
                    ]
                  ),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context){
                          editNote(snapshot.data![index].id);
                        }),
                        backgroundColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: ((context){
                          _deleteNote(snapshot.data![index].id);
                        }),
                        backgroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.delete,
                      )
                    ]
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8
                    ),
                    padding: const EdgeInsets.only(
                      right: 8, 
                      left: 16,
                      top: 4,
                      bottom: 4
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 5)
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            snapshot.data![index].name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, "/notePage", arguments:{
                              'id': snapshot.data![index].id,
                              'name': snapshot.data![index].name
                            });
                          }, 
                          icon: const Icon(Icons.arrow_back_ios_new)
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}