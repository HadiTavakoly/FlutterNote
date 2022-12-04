const String tableName = 'notes';

class Note {
  int? id;
  String? title;
  String? description;

  Note({
    this.id,
    this.title,
    this.description,
  });

  Note copy({
    int? id,
    String? title,
    String? description,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  Map<String, Object?> toJson() => {
        NotesFields.id: id,
        NotesFields.title: title,
        NotesFields.description: description,
      };

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NotesFields.id] as int?,
        title: json[NotesFields.title] as String,
        description: json[NotesFields.description] as String,
      );
}

class NotesFields {
  static const List<String> values = [
    id,
    title,
    description,
  ];
  static const String id = '_id';
  static const String title = '_title';
  static const String description = '_description';
}
