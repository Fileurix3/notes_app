import 'package:flutter/material.dart';
import 'package:notes_app/pages/note_page.dart';
import 'package:notes_app/theme.dart';
import 'package:notes_app/pages/notes_folders_page.dart';
import 'package:notes_app/pages/notes_list_page.dart';

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
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const NotesFoldersPage(),
      routes: {
        "/notesListPage": (context) => const NotesListPage(),
        "/notePage": (context) => const NotePage(),
      }
    );
  }
}
