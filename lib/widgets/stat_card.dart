import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final String? currencyPrefix;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.currencyPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = currencyPrefix != null ? '$currencyPrefix$value' : value;
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // small icon tag
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blue, size: 18),
              ),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(color: Colors.grey.shade800)),
              const SizedBox(height: 8),
              Text(
                displayValue,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(color: subtitle.startsWith('▲') ? Colors.green : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
