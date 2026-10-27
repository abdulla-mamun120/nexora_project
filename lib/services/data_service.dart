import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/dummy_data.dart';

class DataService {
  static final _db = FirebaseFirestore.instance;

  // One-time: copies the dummy data into Firestore
  static Future<void> seedAll() async {
    final batch = _db.batch();

    for (final n in dummyNotices) {
      batch.set(_db.collection('notices').doc(), {
        'title': n.title,
        'description': n.description,
        'details': n.details,
        'category': n.category,
        'date': n.date,
        'isPinned': n.isPinned,
      });
    }

    for (final s in dummyServices) {
      batch.set(_db.collection('services').doc(), {
        'name': s.name,
        'category': s.category,
        'area': s.area,
        'phone': s.phone,
        'experience': s.experience,
      });
    }

    for (final p in dummyPlaces) {
      batch.set(_db.collection('places').doc(), {
        'name': p.name,
        'category': p.category,
        'address': p.address,
        'openingHours': p.openingHours,
        'phone': p.phone,
      });
    }

    await batch.commit();
  }

  // One-time: uploads only the emergency numbers
  static Future<void> seedEmergency() async {
    final batch = _db.batch();

    final items = [
      {
        'name': 'National Emergency',
        'description': 'Police, Fire Service, Ambulance',
        'number': '999',
        'iconKey': 'police',
        'colorHex': 0xFF1D4ED8,
      },
      {
        'name': 'Fire Service',
        'description': 'Fire and rescue',
        'number': '16163',
        'iconKey': 'fire',
        'colorHex': 0xFFDC2626,
      },
      {
        'name': 'Health Call Center',
        'description': 'Health advice and ambulance help',
        'number': '16263',
        'iconKey': 'hospital',
        'colorHex': 0xFF0F766E,
      },
      {
        'name': 'Women & Children Helpline',
        'description': 'Help for women and children',
        'number': '109',
        'iconKey': 'family',
        'colorHex': 0xFFB45309,
      },
      {
        'name': 'Child Helpline',
        'description': 'Help for children in danger',
        'number': '1098',
        'iconKey': 'child',
        'colorHex': 0xFF7C3AED,
      },
    ];

    for (final item in items) {
      batch.set(_db.collection('emergency').doc(), item);
    }

    await batch.commit();
  }
}