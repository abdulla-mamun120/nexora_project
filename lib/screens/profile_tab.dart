import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';
import '../services/user_service.dart';
import 'welcome_screen.dart';
import 'report_screen.dart';
import 'admin_screen.dart';
import '../app_language.dart';
import '../strings.dart';

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
  
    // Current app language (kept in AppLanguage)
  String get _language => AppLanguage.current.value;

    // True if this user is listed in the admins collection
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('admins')
        .doc(UserService.uid)
        .get()
        .then((doc) {
      if (!mounted) return;
      setState(() {
        _isAdmin = doc.exists;
      });
    });
  }

  // Small badge shown in the top card
  Widget _verificationBadge() {
    IconData icon;
    String text;
    Color color;

    if (_verification == 'verified') {
      icon = Icons.verified;
      text = t('badge_verified');
      color = const Color(0xFF16A34A);
    } else if (_verification == 'pending') {
      icon = Icons.hourglass_top;
      text = t('badge_pending');
      color = const Color(0xFFB45309);
    } else {
      icon = Icons.shield_outlined;
      text = t('badge_not_verified');
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
    if (_verification == 'verified') return t('verify_sub_verified');
    if (_verification == 'pending') return t('verify_sub_pending');
    return t('verify_sub_none');
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
                            Text(
                t('menu_edit_profile'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: t('lbl_full_name'),
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
                  labelText: t('lbl_phone_number'),
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
                                            SnackBar(content: Text(t('profile_updated'))),
                    );
                  },
                                    child: Text(t('save'), style: const TextStyle(fontSize: 16)),
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
        Navigator.pop(dialogContext);
        AppLanguage.set(language);
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
                    title: Text(t('choose_language')),
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
                    title: Text(t('logout')),
          content: Text(t('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
                            child: Text(t('cancel')),
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
                            child: Text(t('logout'), style: const TextStyle(color: Colors.red)),
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
                        Text(
              t('profile_title'),
              style: const TextStyle(
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
                                        _infoRow(Icons.phone_outlined, t('lbl_phone'), _phone),
                  
                    const Divider(height: 1),
                    _infoRow(Icons.email_outlined, t('lbl_email'), _email),
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
                    t('menu_verification'),
                    _verificationText(),
                    _openVerification,
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    Icons.edit_outlined,
                    t('menu_edit_profile'),
                    t('menu_edit_sub'),
                    _editProfile,
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    Icons.language,
                    t('menu_language'),
                    _language,
                    _chooseLanguage,
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    Icons.info_outline,
                    t('menu_about'),
                    '',
                    () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Nexora',
                        applicationVersion: '1.0.0',
                                                children: [
                          Text(t('about_text')),
                        ],
                      );
                    },
                  ),
                                                      if (_isAdmin) ...[
                    const Divider(height: 1),
                    _menuTile(
                      Icons.admin_panel_settings_outlined,
                      t('menu_admin'),
                      t('menu_admin_sub'),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminScreen(),
                          ),
                        );
                      },
                    ),
                  ],
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
                                label: Text(t('logout'), style: const TextStyle(fontSize: 16)),
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