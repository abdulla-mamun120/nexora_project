import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  static final _db = FirebaseFirestore.instance;

  // Saves a report and returns its ticket number
  static Future<String> submitReport({
    required String title,
    required String category,
    required String priority,
    required String location,
    required String description,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final ticket = 'RPT-${DateTime.now().millisecondsSinceEpoch % 100000}';

    await _db.collection('reports').add({
      'ticket': ticket,
      'userId': user.uid,
      'userName': user.displayName ?? '',
      'title': title,
      'category': category,
      'priority': priority,
      'location': location,
      'description': description,
      'status': 'Under review',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return ticket;
  }
}