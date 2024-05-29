import 'package:flutter/material.dart';
import 'package:notes_app/pages/notes_folders_page.dart';
import 'package:notes_app/pages/notes_list_page.dart';
import 'package:notes_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const NotesFoldersPage(),
      routes: {
        "/notesListPage": (context) => NotesListPage(),
      }
    );
  }
}
