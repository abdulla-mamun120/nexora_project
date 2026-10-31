import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Panel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Verify'),
              Tab(text: 'Reports'),
              Tab(text: 'Notice'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _VerifyTab(),
            _ReportsTab(),
            _NoticeTab(),
          ],
        ),
      ),
    );
  }
}

// White card used in all admin tabs
Widget _adminCard(Widget child) {
  return Container(
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
    child: child,
  );
}

Widget _emptyText(String text) {
  return Center(
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, color: AppColors.textLight),
    ),
  );
}

// ---------- TAB 1: verify users ----------

class _VerifyTab extends StatelessWidget {
  const _VerifyTab();

  void _setStatus(String uid, String status) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'verification': status});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('verification', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _emptyText('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return _emptyText('No pending requests');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final d = doc.data();
            return _adminCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Email: ${d['email'] ?? ''}'),
                  Text('House: ${d['house'] ?? ''}'),
                  Text('Road / Block: ${d['block'] ?? ''}'),
                  Text('Phone: ${d['verifyPhone'] ?? ''}'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setStatus(doc.id, 'unverified'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setStatus(doc.id, 'verified'),
                          child: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ---------- TAB 2: reports ----------

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  static const List<String> _statuses = [
    'Under review',
    'In progress',
    'Resolved',
  ];

  Color _priorityColor(String p) {
    if (p == 'Urgent') return const Color(0xFFDC2626);
    if (p == 'Important') return const Color(0xFFF59E0B);
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _emptyText('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return _emptyText('No reports yet');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final d = doc.data();
            final status = _statuses.contains(d['status'])
                ? d['status'] as String
                : _statuses.first;
            final priority = d['priority'] ?? 'Normal';

            return _adminCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        d['ticket'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        priority,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _priorityColor(priority),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    d['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${d['category'] ?? ''}  •  ${d['userName'] ?? ''}',
                    style: const TextStyle(color: AppColors.textLight),
                  ),
                  if ((d['location'] ?? '').toString().isNotEmpty)
                    Text('Location: ${d['location']}'),
                  const SizedBox(height: 8),
                  Text(d['description'] ?? ''),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Status: '),
                      DropdownButton<String>(
                        value: status,
                        items: _statuses.map((s) {
                          return DropdownMenuItem<String>(
                            value: s,
                            child: Text(s),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          FirebaseFirestore.instance
                              .collection('reports')
                              .doc(doc.id)
                              .update({'status': value});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ---------- TAB 3: add notice ----------

class _NoticeTab extends StatefulWidget {
  const _NoticeTab();

  @override
  State<_NoticeTab> createState() => _NoticeTabState();
}

class _NoticeTabState extends State<_NoticeTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _detailsController = TextEditingController();

  final List<String> _categories = const [
    'Important',
    'Events',
    'Utilities',
    'Emergency',
  ];
  String _category = 'Important';
  bool _pinned = false;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Example: 08 Oct
  String _today() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    return '$day ${months[now.month - 1]}';
  }

  InputDecoration _style(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() {
      _saving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('notices').add({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'details': _detailsController.text.trim(),
        'category': _category,
        'date': _today(),
        'isPinned': _pinned,
      });
      if (!mounted) return;
      _titleController.clear();
      _descController.clear();
      _detailsController.clear();
      setState(() {
        _pinned = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notice published')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: _style('Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: _style('Short description'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter a short description'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailsController,
              maxLines: 4,
              decoration: _style('Full details'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter the details' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: _style('Category'),
              items: _categories.map((c) {
                return DropdownMenuItem<String>(value: c, child: Text(c));
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _category = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Pin this notice'),
              value: _pinned,
              onChanged: (value) {
                setState(() {
                  _pinned = value;
                });
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _publish,
                child: _saving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : const Text(
                        'Publish Notice',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}