class Place {
  final String name;
  final String category; // Hospital, School, Mosque, Market, Park
  final String address;
  final String openingHours;
  final String phone;

  const Place({
    required this.name,
    required this.category,
    required this.address,
    required this.openingHours,
    required this.phone,
  });
}