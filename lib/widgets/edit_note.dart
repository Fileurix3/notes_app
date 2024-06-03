import 'package:flutter/material.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:simple_markdown_editor/widgets/markdown_field.dart';

class EditNote extends StatelessWidget {

  final NotesModel note;
  final TextEditingController descriptionController;
  final Function(String) onSave;

  const EditNote({
    super.key, 
    required this.note, 
    required this.descriptionController, 
    required this.onSave
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: MarkdownField(
              controller: descriptionController,
              emojiConvert: true,
              style: Theme.of(context).textTheme.labelLarge,
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: (){
                onSave(descriptionController.text);
              }, 
              child: Text(
                "Submit",
                style: Theme.of(context).textTheme.labelMedium,
              )
            )
          ), 
        ],
      ),
    );
  }
}