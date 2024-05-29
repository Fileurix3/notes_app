class NotesModel {
  final int id;
  final int folderId;
  final String name;
  String? description;

  NotesModel({
    required this.id,
    required this.folderId,
    required this.name,
    this.description
  });
}