class Activity {
  final String id;
  String title;
  String category;
  String? description; // opsional
  DateTime dueDate;
  bool isDone;
  bool isFavorite;

  Activity({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    required this.dueDate,
    this.isDone = false,
    this.isFavorite = false,
  });

  static const List<String> kategoriList = [
    'Akademik',
    'Organisasi',
    'Pribadi',
    'Kesehatan',
    'Lainnya',
  ];
}