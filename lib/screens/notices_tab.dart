import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/notice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticesTab extends StatefulWidget {
  const NoticesTab({super.key});

  @override
  State<NoticesTab> createState() => _NoticesTabState();
}

class _NoticesTabState extends State<NoticesTab> {
  final List<String> _categories = [
    'All',
    'Important',
    'Events',
    'Utilities',
    'Emergency',
  ];

  String _selectedCategory = 'All';
  bool _isSearching = false;
  String _searchText = '';

  List<Notice> _allNotices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('notices').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() {
        _allNotices = snap.docs.map((doc) {
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
        _loading = false;
      });
    });
  }

  // Notices after applying category filter and search
  List<Notice> get _filteredNotices {
    final list = _allNotices.where((notice) {
      final matchCategory =
          _selectedCategory == 'All' || notice.category == _selectedCategory;
      final text = _searchText.toLowerCase();
      final matchSearch = notice.title.toLowerCase().contains(text) ||
          notice.description.toLowerCase().contains(text);
      return matchCategory && matchSearch;
    }).toList();

    // Pinned notices first
    final pinned = list.where((n) => n.isPinned).toList();
    final others = list.where((n) => !n.isPinned).toList();
    return [...pinned, ...others];
  }

  Color _tagBgColor(String category) {
    switch (category) {
      case 'Important':
        return const Color(0xFFFFF1D6);
      case 'Events':
        return const Color(0xFFE0F2F1);
      case 'Utilities':
        return const Color(0xFFE3F0FF);
      case 'Emergency':
        return const Color(0xFFFDE8E8);
      default:
        return const Color(0xFFEFEFEF);
    }
  }

  Color _tagTextColor(String category) {
    switch (category) {
      case 'Important':
        return const Color(0xFFB45309);
      case 'Events':
        return AppColors.primary;
      case 'Utilities':
        return const Color(0xFF1D4ED8);
      case 'Emergency':
        return const Color(0xFFB91C1C);
      default:
        return AppColors.textLight;
    }
  }

  // Small colored tag
  Widget _tag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _tagBgColor(category),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _tagTextColor(category),
        ),
      ),
    );
  }

  // Full notice details (bottom sheet)
  void _showDetails(Notice notice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tag(notice.category),
                  Text(
                    notice.date,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                notice.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                notice.details,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Text-to-Speech will be added later
                  },
                  icon: const Icon(Icons.volume_up),
                  label: const Text(
                    'Listen to this notice',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // One notice card
  Widget _noticeCard(Notice notice) {
    return GestureDetector(
      onTap: () => _showDetails(notice),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _tag(notice.category),
                    if (notice.isPinned) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.push_pin,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
                Text(
                  notice.date,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              notice.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notice.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  // Shown when no notice matches
  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 60, color: AppColors.textLight),
          SizedBox(height: 12),
          Text(
            'No notices found',
            style: TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notices = _filteredNotices;

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
                  'Notice Board',
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
                  hintText: 'Search notices',
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

          // Notice list
          Expanded(
                        child: _loading
                ? const Center(child: CircularProgressIndicator())
                : notices.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      return _noticeCard(notices[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}