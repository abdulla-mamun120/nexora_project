import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// All user data work in one place
class UserService {
  static final _db = FirebaseFirestore.instance;

  // Current logged-in user id (null if nobody is logged in)
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;

  // Creates the user document after registration
  static Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'verification': 'unverified', // unverified, pending, verified
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Live stream of the current user's document
  static Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() {
    return _db.collection('users').doc(uid).snapshots();
  }

  // Updates name and phone
  static Future<void> updateProfile(String name, String phone) async {
    await _db.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
    });
  }

  // Saves a verification request
  static Future<void> requestVerification({
    required String house,
    required String block,
    required String phone,
  }) async {
    await _db.collection('users').doc(uid).update({
      'verification': 'pending',
      'house': house,
      'block': block,
      'verifyPhone': phone,
    });
  }
}