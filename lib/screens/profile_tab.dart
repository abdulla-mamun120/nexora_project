import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';
import '../services/user_service.dart';
import 'welcome_screen.dart';
import 'report_screen.dart';
import 'seed_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // User data (filled from Firestore)
  String _name = '';
  String _email = '';
  String _phone = '';
  String _verification = 'unverified';
  final String _area = 'Your Area, City';
  String _language = 'English';

  // Small badge shown in the top card
  Widget _verificationBadge() {
    IconData icon;
    String text;
    Color color;

    if (_verification == 'verified') {
      icon = Icons.verified;
      text = 'Verified resident';
      color = const Color(0xFF16A34A);
    } else if (_verification == 'pending') {
      icon = Icons.hourglass_top;
      text = 'Verification pending';
      color = const Color(0xFFB45309);
    } else {
      icon = Icons.shield_outlined;
      text = 'Not verified';
      color = const Color(0xFFB91C1C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  // Subtitle of the Verification menu row
  String _verificationText() {
    if (_verification == 'verified') {
      return 'You can report problems';
    }
    if (_verification == 'pending') {
      return 'Waiting for admin approval';
    }
    return 'Get verified to report problems';
  }

  // Opens the verification page
  void _openVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportScreen()),
    );
  }

  // White rounded card with a light shadow
  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
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

  // One info row (icon + label + value)
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // One menu row (Edit Profile, Language, About)
  Widget _menuTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textLight,
      ),
    );
  }

  // Edit profile (bottom sheet)
  void _editProfile() {
    final nameController = TextEditingController(text: _name);
    final phoneController = TextEditingController(text: _phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          // Keeps the fields above the keyboard
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    final newPhone = phoneController.text.trim();
                    if (newName.isEmpty || newPhone.isEmpty) {
                      return;
                    }
                    await UserService.updateProfile(newName, newPhone);
                    await FirebaseAuth.instance.currentUser
                        ?.updateDisplayName(newName);
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')),
                    );
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // One language option inside the dialog
  Widget _languageOption(BuildContext dialogContext, String language) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _language = language;
        });
        Navigator.pop(dialogContext);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language set to $language (demo)')),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Text(language, style: const TextStyle(fontSize: 16)),
          ),
          if (_language == language)
            const Icon(Icons.check, color: AppColors.primary),
        ],
      ),
    );
  }

  // Language dialog
  void _chooseLanguage() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Choose language'),
          children: [
            _languageOption(dialogContext, 'English'),
            _languageOption(dialogContext, 'Bangla'),
          ],
        );
      },
    );
  }

  // Logout confirm dialog
  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: UserService.userStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        if (data != null) {
          _name = data['name'] ?? '';
          _email = data['email'] ?? '';
          _phone = data['phone'] ?? '';
          _verification = data['verification'] ?? 'unverified';
        }
        return _buildContent();
      },
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),

            // Top card: avatar, name, email
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  _verificationBadge(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Info card
            _card(
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  children: [
                    _infoRow(Icons.phone_outlined, 'Phone', _phone),
                    const Divider(height: 1),
                    _infoRow(Icons.location_on_outlined, 'Area', _area),
                    const Divider(height: 1),
                    _infoRow(Icons.email_outlined, 'Email', _email),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Menu card
            _card(
              Column(
                children: [
                  _menuTile(
                    Icons.verified_user_outlined,
                    'Verification',
                    _verificationText(),
                    _openVerification,
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    Icons.edit_outlined,
                    'Edit Profile',
                    'Change your name and phone',
                    _editProfile,
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    Icons.language,
                    'Language',
                    _language,
                    _chooseLanguage,
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    Icons.info_outline,
                    'About Nexora',
                    '',
                    () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Nexora',
                        applicationVersion: '1.0.0',
                        children: const [
                          Text(
                            'A digital community service platform for people living in the same area.',
                          ),
                        ],
                      );
                    },
                  ),
                                    const Divider(height: 1),
                  _menuTile(
                    Icons.cloud_upload_outlined,
                    'Upload dummy data (temporary)',
                    'Press only once',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeedScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout', style: TextStyle(fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}