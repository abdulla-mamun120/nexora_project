class Notice {
  final String title;
  final String description;
  final String details;
  final String category; // Important, Events, Utilities, Emergency
  final String date;
  final bool isPinned;

  const Notice({
    required this.title,
    required this.description,
    required this.details,
    required this.category,
    required this.date,
    this.isPinned = false,
  });
}