import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';

// One report category (name, icon, color)
class ReportCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ReportCategory(this.name, this.icon, this.color);
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Report form
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Verification request form
  final _verifyFormKey = GlobalKey<FormState>();
  final _houseController = TextEditingController();
  final _blockController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCategory;
  bool _categoryError = false;
  String _priority = 'Normal';

  final List<ReportCategory> _categories = const [
    ReportCategory('Road', Icons.add_road, Color(0xFF1D4ED8)),
    ReportCategory('Water', Icons.water_drop, Color(0xFF0891B2)),
    ReportCategory('Electricity', Icons.bolt, Color(0xFFF59E0B)),
    ReportCategory('Garbage', Icons.delete_outline, Color(0xFF16A34A)),
    ReportCategory('Safety', Icons.shield_outlined, Color(0xFFDC2626)),
    ReportCategory('Other', Icons.more_horiz, Color(0xFF7C3AED)),
  ];

  final List<String> _priorities = const ['Normal', 'Important', 'Urgent'];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _houseController.dispose();
    _blockController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ---------- common helpers ----------

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Important':
        return const Color(0xFFF59E0B);
      case 'Urgent':
        return const Color(0xFFDC2626);
      default:
        return AppColors.primary;
    }
  }

  // Gradient header shown on top of every state
  Widget _header(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Small section title
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // ---------- STATE 1: not verified (locked) ----------

  Widget _step(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lockedView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        const Text(
          'Verification required',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'To stop false and spam reports, only verified residents of this '
          'area can report problems.',
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5, color: AppColors.textLight),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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
              _sectionTitle('How to get verified'),
              _step('1', 'Send your house number, block and phone number'),
              _step('2', 'The admin checks your details'),
              _step('3', 'You get the Verified badge and can report'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _openVerificationForm,
            icon: const Icon(Icons.verified_user_outlined),
            label: const Text(
              'Request Verification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // Verification request (bottom sheet)
  void _openVerificationForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _verifyFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'The admin will check these details.',
                    style: TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _houseController,
                    decoration: _inputStyle(
                      'House / Holding No.',
                      Icons.home_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your house number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _blockController,
                    decoration: _inputStyle(
                      'Road / Block',
                      Icons.location_on_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your road or block';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputStyle(
                      'Phone Number',
                      Icons.phone_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 11) {
                        return 'Phone number must be at least 11 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_verifyFormKey.currentState!.validate()) {
                                                    UserService.requestVerification(
                            house: _houseController.text.trim(),
                            block: _blockController.text.trim(),
                            phone: _phoneController.text.trim(),
                          );
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verification request sent'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Send Request',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- STATE 2: pending ----------

  Widget _pendingView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(26),
          decoration: const BoxDecoration(
            color: Color(0xFFFFF1D6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.hourglass_top,
            size: 64,
            color: Color(0xFFB45309),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Verification pending',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'The admin is checking your details. You can report problems '
          'as soon as you are approved.',
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5, color: AppColors.textLight),
        ),
        const SizedBox(height: 32),

        // DEMO ONLY: acts like the admin approving the request
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              const Text(
                'DEMO ONLY (will be removed when the Admin Panel is ready)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                                   FirebaseFirestore.instance
                      .collection('users')
                      .doc(UserService.uid)
                      .update({'verification': 'verified'});
                },
                child: const Text('Approve as admin'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- STATE 3: verified (report form) ----------

  Widget _categoryTile(ReportCategory category) {
    final selected = _selectedCategory == category.name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category.name;
          _categoryError = false;
        });
      },
      child: Container(
        width: 96,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? category.color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? category.color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(category.icon, color: category.color, size: 28),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? category.color : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final formOk = _formKey.currentState!.validate();

    setState(() {
      _categoryError = _selectedCategory == null;
    });

    if (!formOk || _categoryError) {
      return;
    }

    // Firebase save will be added here later
    final ticket = 'RPT-${DateTime.now().millisecondsSinceEpoch % 10000}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: 56,
          ),
          title: const Text('Report submitted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ticket,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Status: Under review\nThe admin will check your report.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // close dialog
                Navigator.pop(context); // go back to Home
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _reportForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verified badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 18, color: Color(0xFF16A34A)),
                SizedBox(width: 6),
                Text(
                  'Verified resident',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Title
          TextFormField(
            controller: _titleController,
            decoration: _inputStyle('Problem title', Icons.title),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              if (value.trim().length < 5) {
                return 'Title is too short';
              }
              return null;
            },
          ),
          const SizedBox(height: 22),

          // Category tiles
          _sectionTitle('What kind of problem?'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _categories.map((category) {
              return _categoryTile(category);
            }).toList(),
          ),
          if (_categoryError)
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 4),
              child: Text(
                'Please select a category',
                style: TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
              ),
            ),
          const SizedBox(height: 22),

          // Priority
          _sectionTitle('How urgent is it?'),
          Wrap(
            spacing: 8,
            children: _priorities.map((priority) {
              final selected = priority == _priority;
              final color = _priorityColor(priority);
              return ChoiceChip(
                label: Text(priority),
                selected: selected,
                showCheckmark: false,
                selectedColor: color,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textLight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selected ? color : Colors.grey.shade300,
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    _priority = priority;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 22),

          // Location (optional)
          TextFormField(
            controller: _locationController,
            decoration: _inputStyle(
              'Location (optional)',
              Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 18),

          // Description
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: _inputStyle(
              'Describe the problem',
              Icons.description_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please describe the problem';
              }
              if (value.trim().length < 10) {
                return 'Please write at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),

          // Photo box (real upload will be added later)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo upload will be added later'),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 34,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a photo (optional)',
                    style: TextStyle(color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text(
                'Submit Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- main build: choose the view by verification status ----------

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: UserService.userStream(),
      builder: (context, snapshot) {
        final status = snapshot.data?.data()?['verification'] ?? 'unverified';

        Widget content;
        if (status == 'verified') {
          content = _reportForm();
        } else if (status == 'pending') {
          content = _pendingView();
        } else {
          content = _lockedView();
        }

        return _buildPage(content);
      },
    );
  }

  Widget _buildPage(Widget content) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report a Problem',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(
              Icons.campaign,
              'Help improve your area',
              'Report local problems to the admin',
            ),
            const SizedBox(height: 24),
            content,
          ],
        ),
      ),
    );
  }
}