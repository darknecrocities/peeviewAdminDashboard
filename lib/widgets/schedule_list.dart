import 'package:flutter/material.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = [
      "08:00 AM - General Consultation • Juan Dela Cruz",
      "08:30 AM - Lab Testing • Maria Santos",
      "09:30 AM - Preventive Care • Rica Fernandez",
      "10:30 AM - Follow-up Consultation • Paolo Garcia",
      "12:00 PM - Lab Testing • John Cruz",
      "01:00 PM - Lab Testing • Sofia Lim",
    ];

    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(schedules[index]),
            ),
          );
        },
      ),
    );
  }
}
