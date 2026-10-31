import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/emergency_contact.dart';
import '../utils/launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../strings.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

    // Converts the saved icon name to an icon
  IconData _iconFor(String key) {
    switch (key) {
      case 'police':
        return Icons.local_police;
      case 'fire':
        return Icons.local_fire_department;
      case 'hospital':
        return Icons.local_hospital;
      case 'family':
        return Icons.family_restroom;
      case 'child':
        return Icons.child_care;
      default:
        return Icons.phone;
    }
  }

  // Converts a Firestore document to an EmergencyContact
  EmergencyContact _fromDoc(Map<String, dynamic> d) {
    return EmergencyContact(
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      number: d['number'] ?? '',
      icon: _iconFor(d['iconKey'] ?? ''),
      color: Color(d['colorHex'] ?? 0xFF0F766E),
    );
  }

  void _call(BuildContext context, String name, String number) {
    callNumber(context, number);
  }

  // One contact card
  Widget _contactCard(BuildContext context, EmergencyContact contact) {
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
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: contact.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(contact.icon, color: contact.color, size: 28),
          ),
          const SizedBox(width: 14),

          // Name, description, number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.number,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: contact.color,
                  ),
                ),
              ],
            ),
          ),

          // Call button
          GestureDetector(
            onTap: () => _call(context, contact.name, contact.number),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: Text(
          t('emg_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                    Text(
                    t('emg_danger'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                                    Text(
                    t('emg_danger_sub'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _call(context, 'National Emergency', '999'),
                      icon: const Icon(Icons.call),
                                            label: Text(
                        t('emg_call_999'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

                        Text(
              t('emg_important'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

                        // Contact list (live from Firestore)
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('emergency')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final docs = snapshot.data!.docs;
                                if (docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text(t('emg_empty'))),
                  );
                }
                return Column(
                  children: docs
                      .map((doc) =>
                          _contactCard(context, _fromDoc(doc.data())))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}