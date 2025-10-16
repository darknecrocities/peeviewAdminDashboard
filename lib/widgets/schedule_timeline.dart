import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_options.dart';

class ScheduleTimeline extends StatefulWidget {
  const ScheduleTimeline({super.key});

  @override
  State<ScheduleTimeline> createState() => _ScheduleTimelineState();
}

class _ScheduleTimelineState extends State<ScheduleTimeline> {
  @override
  void initState() {
    super.initState();
    _startFirestoreMirroring();
  }

  /// -----------------------
  /// Firestore -> Supabase Mirroring
  /// -----------------------
  void _startFirestoreMirroring() {
    final supabase = SupabaseOptions.client;

    // Mirror Appointments
    FirebaseFirestore.instance.collection('appointments').snapshots().listen(
          (snapshot) {
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          supabase.from('appointments').upsert({
            'id': doc.id,
            'doctor_name': data['doctorName'] ?? '',
            'patient_name': data['patientName'] ?? '',
            'date': data['date'] ?? '',
            'time': data['time'] ?? '',
          }).catchError((e) => debugPrint('Supabase appointments backup error: $e'));
        }
      },
    );

    // Mirror Urine Tests
    FirebaseFirestore.instance.collection('urine_tests').snapshots().listen(
          (snapshot) {
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          // Convert Firestore Timestamp to ISO8601 string
          String startedAt = '';
          if (data['startedAt'] != null) {
            final ts = data['startedAt'];
            startedAt = (ts is Timestamp) ? ts.toDate().toIso8601String() : ts.toString();
          }

          supabase.from('urine_tests').upsert({
            'id': doc.id,
            'user_name': data['userName'] ?? '',
            'started_at': startedAt,
            'color': data['color'] ?? '',
            'ph_level': data['ph_level'] ?? '',
            'protein_level': data['protein_level'] ?? '',
            'blood_level': data['blood_level'] ?? '',
            'glucose_level': data['glucose_level'] ?? '',
            'leukocytes_level': data['leukocytes_level'] ?? '',
          }).catchError((e) => debugPrint('Supabase urine_tests backup error: $e'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 88),
            children: [
              _buildTopBar(),
              const SizedBox(height: 12),
              _buildSectionTitle("🩺 Upcoming Appointments"),
              const SizedBox(height: 8),
              _buildAppointmentSection(),
              const SizedBox(height: 24),
              _buildSectionTitle("🧪 Urine Test Results"),
              const SizedBox(height: 8),
              _buildUrineResultsSection(),
            ],
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------
  // Header / Toolbar
  // -----------------------
  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
            ],
          ),
          child: const Icon(Icons.view_agenda, size: 20),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_left, color: Colors.grey),
        const SizedBox(width: 8),
        const Text("Today, 08 Oct.", style: TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        const Icon(Icons.notifications_none, color: Colors.grey),
        const SizedBox(width: 8),
        const Icon(Icons.more_vert, color: Colors.grey),
      ],
    );
  }

  // -----------------------
  // Section Title
  // -----------------------
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
            ],
          ),
          child: const Icon(Icons.timeline, color: Colors.blue),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ],
    );
  }

  // -----------------------
  // Appointment Section
  // -----------------------
  Widget _buildAppointmentSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No upcoming appointments."));
        }

        final appointments = snapshot.data!.docs;

        return Column(
          children: appointments.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildAppointmentCard(data);
          }).toList(),
        );
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> data) {
    final time = data['time'] ?? 'N/A';
    final color = Colors.blue.shade100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 64, child: Text(time, style: TextStyle(color: Colors.grey.shade600))),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
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
                        Text(data['doctorName'] ?? 'General Consultation',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text("${data['date'] ?? ''} • ${data['patientName'] ?? ''}",
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------
  // Urine Test Section
  // -----------------------
  Widget _buildUrineResultsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('urine_tests')
          .orderBy('startedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No urine test results yet."));
        }

        final results = snapshot.data!.docs;

        return Column(
          children: results.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildUrineCard(context, data);
          }).toList(),
        );
      },
    );
  }

  void _showUrineDetails(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Urine Test Details", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("User", data['userName']),
                _buildDetailRow("Date", data['startedAt']),
                _buildDetailRow("Color", data['color']),
                _buildDetailRow("pH Level", data['ph_level']),
                _buildDetailRow("Protein", data['protein_level']),
                _buildDetailRow("Blood", data['blood_level']),
                _buildDetailRow("Glucose", data['glucose_level']),
                _buildDetailRow("Leukocytes", data['leukocytes_level']),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(value?.toString() ?? 'N/A', style: const TextStyle(color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _buildUrineCard(BuildContext context, Map<String, dynamic> data) {
    bool isAbnormal = [
      data['protein_level'],
      data['blood_level'],
      data['glucose_level'],
      data['leukocytes_level']
    ].any((val) => val != null && val.toString().contains(RegExp(r'[+3-4]|Large|Positive|>')));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: () => _showUrineDetails(context, data),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 64,
                child: Text(
                    data['startedAt']?.toString().substring(11, 16) ?? 'N/A',
                    style: TextStyle(color: Colors.grey.shade600))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                      child: const Icon(Icons.science, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['userName'] ?? 'Unknown User', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("Color: ${data['color'] ?? 'N/A'} • pH: ${data['ph_level'] ?? 'N/A'}",
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(isAbnormal ? "Status: Abnormal" : "Status: Normal",
                              style: TextStyle(
                                  color: isAbnormal ? Colors.red.shade800 : Colors.green.shade800,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
