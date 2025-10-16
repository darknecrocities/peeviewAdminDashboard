import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _selectedView = "Month"; // Month, Week, Day
  Map<String, List<Map<String, dynamic>>> _appointmentsByDate = {};

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final snapshot = await FirebaseFirestore.instance.collection('appointments').get();
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dateString = data['date'];
      if (dateString != null) {
        final normalizedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateString));
        grouped.putIfAbsent(normalizedDate, () => []);
        grouped[normalizedDate]!.add(data);
      }
    }

    setState(() => _appointmentsByDate = grouped);
  }

  void _showAppointmentDetails(List<Map<String, dynamic>> appointments) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text("Appointments",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: appointments.map((appt) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.medical_services, color: Color(0xFF2563EB)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              appt['doctorName'] ?? 'Unknown Doctor',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Color(0xFF2563EB), size: 16),
                          const SizedBox(width: 5),
                          Text(appt['time'] ?? '', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF2563EB), size: 16),
                          const SizedBox(width: 5),
                          Text(appt['patientName'] ?? '', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.note, color: Color(0xFF2563EB), size: 16),
                          const SizedBox(width: 5),
                          Expanded(child: Text(appt['details'] ?? '', style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showNewEventDialog() {
    final _timeController = TextEditingController();
    final _patientController = TextEditingController();
    final _detailsController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "New Appointment",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("New Appointment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue.shade900,
                        )),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time, color: Color(0xFF2563EB)),
                        labelText: "Time",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _patientController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF2563EB)),
                        labelText: "Patient Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _detailsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.note, color: Color(0xFF2563EB)),
                        labelText: "Details",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF2563EB)),
                        const SizedBox(width: 10),
                        TextButton(
                          child: Text(DateFormat('yyyy-MM-dd').format(selectedDate),
                              style: const TextStyle(color: Colors.blue)),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() => selectedDate = picked);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 6,
                          ),
                          onPressed: () async {
                            if (_timeController.text.isEmpty || _patientController.text.isEmpty) return;

                            final newEvent = {
                              'time': _timeController.text,
                              'patientName': _patientController.text,
                              'details': _detailsController.text,
                              'date': selectedDate.toIso8601String(),
                              'doctorName': 'General Consultation',
                            };

                            await FirebaseFirestore.instance.collection('appointments').add(newEvent);
                            Navigator.pop(context);
                            _fetchAppointments();
                          },
                          child: const Text("Save", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }


  Widget _buildCalendarView() {
    if (_selectedView == "Month") return _buildMonthView();
    if (_selectedView == "Week") return _buildWeekView();
    return _buildDayView();
  }

  Widget _buildMonthView() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          children: List.generate(7, (index) {
            return Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][index],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),
        ...List.generate(6, (week) {
          return TableRow(
            children: List.generate(7, (day) {
              int dayNum = week * 7 + day - startWeekday + 1;
              if (dayNum < 1 || dayNum > daysInMonth) return Container();
              final dateKey = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, dayNum));
              final hasAppointments = _appointmentsByDate.containsKey(dateKey);

              return GestureDetector(
                onTap: hasAppointments
                    ? () => _showAppointmentDetails(_appointmentsByDate[dateKey]!)
                    : null,
                child: Container(
                  height: 80,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                    color: hasAppointments ? const Color(0xFF2563EB).withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$dayNum", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      if (hasAppointments)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.event_available, size: 14, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text("Appointment", style: TextStyle(fontSize: 12, color: Color(0xFF2563EB))),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildWeekView() {
    final now = DateTime.now();
    final days = List.generate(
        7, (index) => now.subtract(Duration(days: now.weekday - index)));
    final hours = List.generate(12, (index) => 8 + index); // 8 AM to 8 PM

    return LayoutBuilder(
      builder: (context, constraints) {
        final timeColumnWidth = 60.0;
        final dayColumnWidth = (constraints.maxWidth - timeColumnWidth) / 7;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column
                Column(
                  children: [
                    Container(
                      width: timeColumnWidth,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Text(
                        "Time",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...hours.map((hour) => Container(
                      width: timeColumnWidth,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text("$hour:00"),
                    )),
                  ],
                ),
                // Day columns
                ...days.map((day) {
                  final dateKey =
                  DateFormat('yyyy-MM-dd').format(day);
                  return Column(
                    children: [
                      Container(
                        width: dayColumnWidth,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat('E\ndd').format(day),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ...hours.map((hour) {
                        final appts = _appointmentsByDate[dateKey]
                            ?.where((a) => a['time']
                            ?.startsWith(hour.toString()) ??
                            false)
                            .toList() ??
                            [];
                        return Container(
                          width: dayColumnWidth,
                          height: 60,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300),
                          ),
                          child: appts.isNotEmpty
                              ? GestureDetector(
                            onTap: () =>
                                _showAppointmentDetails(appts),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                appts.first['patientName'] ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                              : null,
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildDayView() {
    final now = DateTime.now();
    final hours = List.generate(12, (index) => 8 + index); // 8 AM to 8 PM
    final dateKey = DateFormat('yyyy-MM-dd').format(now);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: hours.map((hour) {
          final appts = _appointmentsByDate[dateKey]
              ?.where((a) => a['time']?.startsWith(hour.toString()) ?? false)
              .toList() ??
              [];
          return Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text("$hour:00"),
                ),
                Expanded(
                  child: appts.isNotEmpty
                      ? GestureDetector(
                    onTap: () => _showAppointmentDetails(appts),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        appts.first['patientName'] ?? '',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewEventDialog,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar with Month & Refresh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _fetchAppointments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Refresh", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tabs for Month, Week, Day
            Row(
              children: ["Month", "Week", "Day"].map((view) {
                bool isSelected = _selectedView == view;
                return GestureDetector(
                  onTap: () => setState(() => _selectedView = view),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey.shade300 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(view, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Calendar View
            Expanded(child: _buildCalendarView()),
          ],
        ),
      ),
    );
  }
}
