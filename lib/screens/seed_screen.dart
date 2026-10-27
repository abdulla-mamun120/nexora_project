import 'package:flutter/material.dart';
import '../services/data_service.dart';

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  bool _loading = false;

  Future<void> _seed() async {
    setState(() {
      _loading = true;
    });
    try {
      await DataService.seedAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data uploaded to Firestore')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
    Future<void> _seedEmergency() async {
    try {
      await DataService.seedEmergency();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency numbers uploaded')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload dummy data')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Press ONLY ONCE. Pressing again creates duplicates.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _seed,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Upload data'),
            ),
                        const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _seedEmergency,
              child: const Text('Upload emergency numbers'),
            ),
          ],
        ),
      ),
    );
  }
}