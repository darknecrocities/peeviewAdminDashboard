import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/stat_card.dart';
import '../widgets/recent_chart.dart';
import '../widgets/action_tile.dart';
import '../widgets/schedule_timeline.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedTab = 0;
  String filterValue = 'This month';

  final List<Widget> _screens = [
    const Center(child: Text("Dashboard")), // index 0
    const Center(child: Text("Calendar")),  // index 1
    const Center(child: Text("Profile")),   // index 2
    const Center(child: Text("Hospital")),  // index 3
    const Center(child: Text("Reports")),   // index 4
    const Center(child: Text("Settings")),  // index 5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // LEFT: Sidebar
          Sidebar(
            selectedIndex: selectedTab,
            onItemSelected: (i) => setState(() => selectedTab = i),
          ),

          // MAIN CONTENT (changes based on tab)
          Expanded(
            flex: 3,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selectedTab == 0
                  ? Padding(
                key: const ValueKey("DashboardContent"),
                padding: const EdgeInsets.symmetric(
                    vertical: 22, horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar + date
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search for patients...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Today, 01 Sept.",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Greeting + Filter
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Text(
                            'Hello, Arron!',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            const Text('Filter by',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: filterValue,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'This month',
                                        child: Text('This month')),
                                    DropdownMenuItem(
                                        value: 'Last month',
                                        child: Text('Last month')),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => filterValue = v);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Stat cards row
                    Row(
                      children: const [
                        StatCard(
                          icon: Icons.schedule,
                          title: 'Upcoming Appt.',
                          value: '120',
                          subtitle: '15 Cancelled',
                        ),
                        SizedBox(width: 12),
                        StatCard(
                          icon: Icons.check_circle_outline,
                          title: 'Finished Appt.',
                          value: '95',
                          subtitle: '▲ 3.4% vs last month',
                        ),
                        SizedBox(width: 12),
                        StatCard(
                          icon: Icons.pie_chart_outline,
                          title: 'Finance',
                          value: '152,000',
                          subtitle: '▲ 5.5% vs last month',
                          currencyPrefix: '₱',
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Chart + Action Tiles
                    Expanded(
                      child: Row(
                        children: [
                          // Chart (big)
                          Expanded(
                            flex: 2,
                            child: RecentChartCard(),
                          ),
                          const SizedBox(width: 18),
                          // Action Tiles (2x2 grid)
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(
                                          child: ActionTile(
                                              icon: Icons.add_box,
                                              title:
                                              'Create\nAppointment')),
                                      SizedBox(width: 12),
                                      Expanded(
                                          child: ActionTile(
                                              icon: Icons.person_add,
                                              title:
                                              'Add New\nPatient')),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(
                                          child: ActionTile(
                                              icon:
                                              Icons.insert_drive_file,
                                              title:
                                              'Generate\nMonthly\nReport')),
                                      SizedBox(width: 12),
                                      Expanded(
                                          child: ActionTile(
                                              icon: Icons.how_to_reg,
                                              title: 'Add New\nDoctor')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : _screens[selectedTab], // Other tabs show placeholder
            ),
          ),

          // RIGHT: Schedule / timeline (only show on Dashboard)
          if (selectedTab == 0) ...[
            const SizedBox(width: 16),
            const SizedBox(
              width: 360,
              child: ScheduleTimeline(),
            ),
          ],
        ],
      ),
    );
  }
}
