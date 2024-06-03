import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notes_app/model/notes_model.dart';

class ReadNote extends StatelessWidget {
  final NotesModel note;
  const ReadNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: SingleChildScrollView(
        child: note.description == ""  
          ? Center(
            child: MarkdownBody(
              data: note.description!,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 18)
              ),
            ),
          )
          : Center(
            child: Text(
              "There is nothing",
              style: Theme.of(context).textTheme.headlineSmall,
            )
          )
      )
    );
  }
}