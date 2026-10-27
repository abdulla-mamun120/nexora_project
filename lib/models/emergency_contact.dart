import 'package:flutter/material.dart';

class EmergencyContact {
  final String name;
  final String description;
  final String number;
  final IconData icon;
  final Color color;

  const EmergencyContact({
    required this.name,
    required this.description,
    required this.number,
    required this.icon,
    required this.color,
  });
}