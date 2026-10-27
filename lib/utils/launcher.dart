import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Opens the phone dialer with the number filled in
Future<void> callNumber(BuildContext context, String number) async {
  // Remove spaces and dashes, e.g. 01700-000001 -> 01700000001
  final cleaned = number.replaceAll(RegExp(r'[^0-9+]'), '');
  final uri = Uri(scheme: 'tel', path: cleaned);

  final ok = await launchUrl(uri);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the dialer')),
    );
  }
}

// Opens Google Maps (or the browser) and searches for a place
Future<void> openMap(BuildContext context, String query) async {
  final uri = Uri.https(
    'www.google.com',
    '/maps/search/',
    {'api': '1', 'query': query},
  );

  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the map')),
    );
  }
}