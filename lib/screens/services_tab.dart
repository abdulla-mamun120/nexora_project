import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/service_contact.dart';
import '../utils/launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesTab extends StatefulWidget {
  final String initialCategory;

  const ServicesTab({super.key, this.initialCategory = 'All'});

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  final List<String> _categories = [
    'All',
    'Electrician',
    'Plumber',
    'Mechanic',
    'Tutor',
  ];

   late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
        FirebaseFirestore.instance.collection('services').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() {
        _allServices = snap.docs.map((doc) {
          final d = doc.data();
          return ServiceContact(
            name: d['name'] ?? '',
            category: d['category'] ?? '',
            area: d['area'] ?? '',
            phone: d['phone'] ?? '',
            experience: d['experience'] ?? '',
          );
        }).toList();
        _loading = false;
      });
    });
  }
  bool _isSearching = false;
  String _searchText = '';

    List<ServiceContact> _allServices = [];
  bool _loading = true;

  // Services after applying category filter and search
  List<ServiceContact> get _filteredServices {
    return _allServices.where((service) {
      final matchCategory =
          _selectedCategory == 'All' || service.category == _selectedCategory;
      final text = _searchText.toLowerCase();
      final matchSearch = service.name.toLowerCase().contains(text) ||
          service.category.toLowerCase().contains(text) ||
          service.area.toLowerCase().contains(text);
      return matchCategory && matchSearch;
    }).toList();
  }

  // Icon for each category
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Electrician':
        return Icons.bolt;
      case 'Plumber':
        return Icons.water_drop;
      case 'Mechanic':
        return Icons.build;
      case 'Tutor':
        return Icons.school;
      default:
        return Icons.person;
    }
  }

  // Color for each category
  Color _categoryColor(String category) {
    switch (category) {
      case 'Electrician':
        return const Color(0xFFF59E0B);
      case 'Plumber':
        return const Color(0xFF1D4ED8);
      case 'Mechanic':
        return const Color(0xFFDC2626);
      case 'Tutor':
        return const Color(0xFF7C3AED);
      default:
        return AppColors.primary;
    }
  }

  void _call(ServiceContact service) {
    callNumber(context, service.phone);
  }

  // One service card
  Widget _serviceCard(ServiceContact service) {
    final color = _categoryColor(service.category);

    return Container(
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
          // Category icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_categoryIcon(service.category), color: color, size: 28),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service.category,
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
                        service.area,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  service.experience,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),

          // Call button
          GestureDetector(
            onTap: () => _call(service),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Shown when nothing matches
  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 60, color: AppColors.textLight),
          SizedBox(height: 12),
          Text(
            'No services found',
            style: TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final services = _filteredServices;

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
                const Text(
                  'Local Services',
                  style: TextStyle(
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
                  hintText: 'Search by name, service or area',
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
                  label: Text(category),
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

          // Service list
                    // Service list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : services.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return _serviceCard(services[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}