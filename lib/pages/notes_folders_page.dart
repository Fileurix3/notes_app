import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/model/notes_folders_model.dart';
import 'package:notes_app/services/notes_folders_services.dart';

class NotesFoldersPage extends StatefulWidget {
  const NotesFoldersPage({super.key});

  @override
  State<NotesFoldersPage> createState() => _NotesFoldersPageState();
}

class _NotesFoldersPageState extends State<NotesFoldersPage> {

  Future<List<NotesFoldersModel>>? notesFolders;
  final notesFoldersServices = NotesFoldersServices();

  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNotesFolders();
  }

  void fetchNotesFolders() async {
    setState(() {
      notesFolders = notesFoldersServices.getNotesFolders();
    });
  }

  void _addNewFolder(String name) async{
    await notesFoldersServices.insertNotesFolder(name);
    fetchNotesFolders();
  }
  void _editNameFolders(int id, String name) async{
    await notesFoldersServices.updateFolderName(id, nameController.text);
    fetchNotesFolders();
  }
  void _folderDelete(int id){
    notesFoldersServices.deleteFolred(id);
    fetchNotesFolders();
  }

  void addFolders(){
    showDialog(
      context: context, 
      builder: (coontext) {
        return AlertDialog(
          title: const Text("Add folder"),
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
                  _addNewFolder(nameController.text);
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

  void editNameFolders(int id) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Change folder"),
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
                  _editNameFolders(id, nameController.text);
                  nameController.clear();
                }
              }, 
              child: Text(
                "Change",
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
        title: const Text("Folders with notes")
      ),
      body: FutureBuilder(
        future: notesFolders, 
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
          }else{
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context){
                          _folderDelete(snapshot.data![index].id);
                        }),
                        backgroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.delete,
                      ),
                      SlidableAction(
                        onPressed: ((context){
                          editNameFolders(snapshot.data![index].id);
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
                          editNameFolders(snapshot.data![index].id);
                        }),
                        backgroundColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: ((context){
                          _folderDelete(snapshot.data![index].id);
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
                            "${snapshot.data?[index].name}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.pushNamed(
                              context, "/notesListPage",
                              arguments: snapshot.data![index].id
                            );
                          }, 
                          icon: const Icon(Icons.arrow_back_ios_new)
                        )
                      ],
                    ),
                  ),
                );
              }
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addFolders();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}