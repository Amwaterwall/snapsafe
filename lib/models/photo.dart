class Photo {
  final String path;
  final DateTime dateAdded;

  Photo({required this.path, required this.dateAdded});

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  static Photo fromMap(Map<String, dynamic> map) {
    return Photo(
      path: map['path'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }
}
