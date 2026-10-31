import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';
import '../strings.dart';
import 'emergency_screen.dart';
import 'report_screen.dart';
import 'search_screen.dart';

class HomeTab extends StatelessWidget {
  // Asks MainScreen to open another tab
  // tabIndex: 1 = Notices, 2 = Services, 3 = Area Guide
  // category: the chip to select in that tab ('All' if none)
  final void Function(int tabIndex, String category) onGoToTab;

  const HomeTab({super.key, required this.onGoToTab});

  // Name of the logged-in user (first word only)
  String get userName {
    final name = FirebaseAuth.instance.currentUser?.displayName;
    if (name == null || name.trim().isEmpty) return 'Friend';
    return name.trim().split(' ').first;
  }

  // Small service card (Electrician, Plumber, etc.)
  Widget _quickService(IconData icon, String title, Color bgColor,
      Color iconColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    // Small feature chip used in the About card
  Widget _featureChip(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // About card shown at the bottom of Home
  Widget _aboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.location_city,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Text(
                t('home_about_title'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            t('home_about_text'),
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _featureChip(Icons.campaign, t('home_feat_notices')),
              _featureChip(Icons.build, t('home_feat_services')),
              _featureChip(Icons.map, t('home_feat_places')),
              _featureChip(Icons.report_problem, t('home_feat_report')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + notification bell
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('home_greeting'),
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textLight),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    onGoToTab(1, 'All');
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
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
                        child: const Icon(Icons.notifications_none,
                            color: AppColors.textDark),
                      ),
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),

            // Search bar (opens the search page)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(onGoToTab: onGoToTab),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    const Icon(Icons.search, color: AppColors.textLight),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t('home_search_hint'),
                        style: const TextStyle(color: AppColors.textLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Emergency card
            Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Decorative circle (top right)
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B6B7A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t('home_quick_help'),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t('home_emergency_title'),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EmergencyScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone_outlined),
                          label: Text(
                            t('home_emergency_btn'),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.navy,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick services
            Text(
              t('home_quick_services'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _quickService(Icons.bolt, t('svc_electrician'),
                    const Color(0xFFE0F2F1), AppColors.accent, () {
                  onGoToTab(2, 'Electrician');
                }),
                const SizedBox(width: 10),
                _quickService(Icons.water_drop, t('svc_plumber'),
                    const Color(0xFFE0F2F1), AppColors.primary, () {
                  onGoToTab(2, 'Plumber');
                }),
                const SizedBox(width: 10),
                _quickService(Icons.add, t('svc_hospital'),
                    const Color(0xFFE0F2F1), AppColors.primary, () {
                  onGoToTab(3, 'Hospital');
                }),
                const SizedBox(width: 10),
                _quickService(Icons.priority_high, t('svc_report'),
                    const Color(0xFFFDE8E8), Colors.red, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportScreen(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

                        // About card
            _aboutCard(),
          ],
        ),
      ),
    );
  }
}