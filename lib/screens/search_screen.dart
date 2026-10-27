import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/notice.dart';
import '../models/service_contact.dart';
import '../models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  // Asks MainScreen to open a tab (1 = Notices, 2 = Services, 3 = Area Guide)
  final void Function(int tabIndex, String category) onGoToTab;

  const SearchScreen({super.key, required this.onGoToTab});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
    List<Notice> _notices = [];
  List<ServiceContact> _services = [];
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    final db = FirebaseFirestore.instance;

    db.collection('notices').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() {
        _notices = snap.docs.map((doc) {
          final d = doc.data();
          return Notice(
            title: d['title'] ?? '',
            description: d['description'] ?? '',
            details: d['details'] ?? '',
            category: d['category'] ?? '',
            date: d['date'] ?? '',
            isPinned: d['isPinned'] ?? false,
          );
        }).toList();
      });
    });

    db.collection('services').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() {
        _services = snap.docs.map((doc) {
          final d = doc.data();
          return ServiceContact(
            name: d['name'] ?? '',
            category: d['category'] ?? '',
            area: d['area'] ?? '',
            phone: d['phone'] ?? '',
            experience: d['experience'] ?? '',
          );
        }).toList();
      });
    });

    db.collection('places').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() {
        _places = snap.docs.map((doc) {
          final d = doc.data();
          return Place(
            name: d['name'] ?? '',
            category: d['category'] ?? '',
            address: d['address'] ?? '',
            openingHours: d['openingHours'] ?? '',
            phone: d['phone'] ?? '',
          );
        }).toList();
      });
    });
  }

  final List<String> _suggestions = const [
    'Electrician',
    'Water',
    'Hospital',
    'Mosque',
    'Road',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---------- search logic ----------

  List<Notice> get _noticeResults {
    final text = _query.trim().toLowerCase();
    return _notices.where((notice) {
      return notice.title.toLowerCase().contains(text) ||
          notice.description.toLowerCase().contains(text);
    }).toList();
  }

  List<ServiceContact> get _serviceResults {
    final text = _query.trim().toLowerCase();
    return _services.where((service) {
      return service.name.toLowerCase().contains(text) ||
          service.category.toLowerCase().contains(text) ||
          service.area.toLowerCase().contains(text);
    }).toList();
  }

  List<Place> get _placeResults {
    final text = _query.trim().toLowerCase();
    return _places.where((place) {
      return place.name.toLowerCase().contains(text) ||
          place.category.toLowerCase().contains(text) ||
          place.address.toLowerCase().contains(text);
    }).toList();
  }

  // ---------- small UI helpers ----------

  Widget _sectionTitle(String text, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        '$text ($count)',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _resultTile(IconData icon, Color color, String title,
      String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }

  // Shown before the user types anything
  Widget _hintView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.search, size: 70, color: AppColors.textLight),
          const SizedBox(height: 12),
          const Text(
            'Search the whole app',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Find notices, services and places',
            style: TextStyle(color: AppColors.textLight),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((word) {
              return ActionChip(
                label: Text(word),
                backgroundColor: Colors.white,
                onPressed: () {
                  _controller.text = word;
                  setState(() {
                    _query = word;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Shown when nothing matches
  Widget _noResults() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 60, color: AppColors.textLight),
          SizedBox(height: 12),
          Text(
            'No results found',
            style: TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_query.trim().isEmpty) {
      body = _hintView();
    } else {
      final notices = _noticeResults;
      final services = _serviceResults;
      final places = _placeResults;

      if (notices.isEmpty && services.isEmpty && places.isEmpty) {
        body = _noResults();
      } else {
        body = ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (notices.isNotEmpty) ...[
              _sectionTitle('Notices', notices.length),
              ...notices.map((notice) {
                return _resultTile(
                  Icons.campaign,
                  AppColors.accent,
                  notice.title,
                  '${notice.category}  •  ${notice.date}',
                  () {
                    Navigator.pop(context);
                    widget.onGoToTab(1, 'All');
                  },
                );
              }),
            ],
            if (services.isNotEmpty) ...[
              _sectionTitle('Services', services.length),
              ...services.map((service) {
                return _resultTile(
                  Icons.build,
                  AppColors.primary,
                  service.name,
                  '${service.category}  •  ${service.area}',
                  () {
                    Navigator.pop(context);
                    widget.onGoToTab(2, service.category);
                  },
                );
              }),
            ],
            if (places.isNotEmpty) ...[
              _sectionTitle('Places', places.length),
              ...places.map((place) {
                return _resultTile(
                  Icons.place,
                  const Color(0xFF1D4ED8),
                  place.name,
                  '${place.category}  •  ${place.address}',
                  () {
                    Navigator.pop(context);
                    widget.onGoToTab(3, place.category);
                  },
                );
              }),
            ],
          ],
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search notices, services or places',
            border: InputBorder.none,
          ),
        ),
      ),
      body: body,
    );
  }
}