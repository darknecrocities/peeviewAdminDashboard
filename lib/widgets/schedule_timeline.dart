import 'package:flutter/material.dart';

class ScheduleTimeline extends StatelessWidget {
  const ScheduleTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'time': '08:00 AM', 'title': 'General Consultation', 'subtitle': '08:00 - 08:30 AM • Juan Dela Cruz', 'color': Colors.blue.shade100},
      {'time': '08:30 AM', 'title': 'Lab Testing', 'subtitle': '08:30 - 09:00 AM • Maria Santos', 'color': Colors.blue.shade300},
      {'time': '09:30 AM', 'title': 'Preventive Care', 'subtitle': '09:30 - 10:00 AM • Rica Fernandez', 'color': Colors.blue.shade50},
      {'time': '10:30 AM', 'title': 'Follow-up Consultation', 'subtitle': '10:30 - 12:00 PM • Paolo Garcia', 'color': Colors.blue.shade50},
      {'time': '12:00 PM', 'title': 'Lab Testing', 'subtitle': '12:00 - 1:00 PM • John Cruz', 'color': Colors.blue.shade300},
      {'time': '01:00 PM', 'title': 'Lab Testing', 'subtitle': '01:00 - 02:00 PM • Sofia Lim', 'color': Colors.blue.shade200},
    ];

    return Container(
      color: Colors.grey.shade50,
      child: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 88),
            itemCount: items.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                // Top controls row (icons + date)
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                        ),
                        child: const Icon(Icons.view_agenda, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_left, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text('Today, 01 Sept.', style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.notifications_none, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Icon(Icons.more_vert, color: Colors.grey),
                    ],
                  ),
                );
              }

              final it = items[i - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // time label
                    SizedBox(
                      width: 64,
                      child: Text(it['time'] as String, style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    const SizedBox(width: 8),
                    // appointment card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: it['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.medical_services, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(it['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(it['subtitle'] as String, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.more_vert, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Floating plus button position
          Positioned(
            right: 18,
            bottom: 18,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
