import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _selectedView = "Month"; // Month, Week, Day

  void _showNewEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text(
                "New Event",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Time"),
                  const SizedBox(height: 10),
                  _buildTextField("Title"),
                  const SizedBox(height: 10),
                  _buildTextField("Details", maxLines: 3),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Save event logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("Add", style: TextStyle(color: Color(0xFF2563EB))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildCalendarView() {
    if (_selectedView == "Month") {
      return _buildMonthView();
    } else if (_selectedView == "Week") {
      return _buildWeekView();
    } else {
      return _buildDayView();
    }
  }

  Widget _buildMonthView() {
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
        ...List.generate(5, (week) {
          return TableRow(
            children: List.generate(7, (day) {
              return Container(
                height: 80,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(6),
                child: Text("${week * 7 + day + 1}"),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildWeekView() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          children: List.generate(7, (index) {
            return Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][index],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),
        TableRow(
          children: List.generate(7, (index) {
            return Column(
              children: List.generate(9, (hour) {
                return Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("${hour + 12}:00"),
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDayView() {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Text("${index + 8}:00 AM"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with Month & New Event
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "September 2015",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _showNewEventDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("New Event", style: TextStyle(color: Colors.white)),
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
                  child: Text(view, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Calendar View
          Expanded(child: _buildCalendarView()),
        ],
      ),
    );
  }
}
