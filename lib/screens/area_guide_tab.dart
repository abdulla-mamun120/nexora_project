import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/place.dart';
import '../utils/launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../strings.dart';

class AreaGuideTab extends StatefulWidget {
  final String initialCategory;

  const AreaGuideTab({super.key, this.initialCategory = 'All'});

  @override
  State<AreaGuideTab> createState() => _AreaGuideTabState();
}

class _AreaGuideTabState extends State<AreaGuideTab> {
  final List<String> _categories = [
    'All',
    'Hospital',
    'School',
    'Mosque',
    'Market',
    'Park',
  ];

    late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
        FirebaseFirestore.instance.collection('places').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() {
        _allPlaces = snap.docs.map((doc) {
          final d = doc.data();
          return Place(
            name: d['name'] ?? '',
            category: d['category'] ?? '',
            address: d['address'] ?? '',
            openingHours: d['openingHours'] ?? '',
            phone: d['phone'] ?? '',
          );
        }).toList();
        _loading = false;
      });
    });
  }
  bool _isSearching = false;
  String _searchText = '';

     List<Place> _allPlaces = [];
  bool _loading = true;

  // Places after applying category filter and search
  List<Place> get _filteredPlaces {
    return _allPlaces.where((place) {
      final matchCategory =
          _selectedCategory == 'All' || place.category == _selectedCategory;
      final text = _searchText.toLowerCase();
      final matchSearch = place.name.toLowerCase().contains(text) ||
          place.category.toLowerCase().contains(text) ||
          place.address.toLowerCase().contains(text);
      return matchCategory && matchSearch;
    }).toList();
  }

  // Icon for each category
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Hospital':
        return Icons.local_hospital;
      case 'School':
        return Icons.school;
      case 'Mosque':
        return Icons.mosque;
      case 'Market':
        return Icons.storefront;
      case 'Park':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  // Color for each category
  Color _categoryColor(String category) {
    switch (category) {
      case 'Hospital':
        return const Color(0xFFDC2626);
      case 'School':
        return const Color(0xFF1D4ED8);
      case 'Mosque':
        return const Color(0xFF0F766E);
      case 'Market':
        return const Color(0xFFF59E0B);
      case 'Park':
        return const Color(0xFF16A34A);
      default:
        return AppColors.primary;
    }
  }

  // One row inside the details sheet (icon + text)
  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  // Place details (bottom sheet)
  void _showDetails(Place place) {
    final color = _categoryColor(place.category);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _categoryIcon(place.category),
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
  tCat(place.category),
  style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow(Icons.location_on_outlined, place.address),
              _detailRow(Icons.access_time, place.openingHours),
              _detailRow(Icons.phone_outlined, place.phone),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                                    onPressed: () {
                    Navigator.pop(sheetContext);
                    openMap(context, '${place.name}, ${place.address}');
                  },
                  icon: const Icon(Icons.map),
                                    label: Text(
                    t('view_on_map'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // One place card
  Widget _placeCard(Place place) {
    final color = _categoryColor(place.category);

    return GestureDetector(
      onTap: () => _showDetails(place),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_categoryIcon(place.category), color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.category,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  // Shown when nothing matches
    Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 60, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text(
            t('guide_empty'),
            style: const TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = _filteredPlaces;

    return SafeArea(
      child: Column(
        children: [
          // Header: title + search button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                               Text(
                  t('guide_title'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchText = '';
                      }
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search box (only when search is on)
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                                    hintText: t('guide_search'),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

          // Category chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = category == _selectedCategory;
                return ChoiceChip(
                                    label: Text(tCat(category)),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: AppColors.navy,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected ? AppColors.navy : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          // Place list
          Expanded(
                        child: _loading
                ? const Center(child: CircularProgressIndicator())
                : places.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return _placeCard(places[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}