import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<IconData> icons = const [
    Icons.home,
    Icons.calendar_today,
    Icons.person,
    Icons.local_hospital,
    Icons.bar_chart,
    Icons.settings,
  ];

  final double iconHeight = 70;
  final double sidebarWidth = 70;
  double _currentTop = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: _currentTop, end: _currentTop)
        .animate(_controller);
  }

  void _animateTo(int index) {
    final targetTop = 40.0 + index * iconHeight; // top of icon
    _animation = Tween<double>(begin: _currentTop, end: targetTop)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() => setState(() {}));
    _controller.forward(from: 0);
    _currentTop = targetTop;
  }

  Widget _buildNavItem(int index, IconData icon) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _animateTo(index);
        widget.onItemSelected(index); // ✅ only updates index
      },
      child: Container(
        height: iconHeight,
        width: sidebarWidth,
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
          size: 28,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sidebarWidth,
      child: Stack(
        children: [
          // Water-drop background
          CustomPaint(
            size: Size(sidebarWidth, double.infinity),
            painter: _SidebarPainter(
              top: _animation.value,
              iconHeight: iconHeight,
              sidebarWidth: sidebarWidth,
            ),
          ),

          // Icons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              Column(
                children: List.generate(
                  icons.length,
                      (index) => _buildNavItem(index, icons[index]),
                ),
              ),
              // Bottom help button
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.help, color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarPainter extends CustomPainter {
  final double top;
  final double iconHeight;
  final double sidebarWidth;

  _SidebarPainter({
    required this.top,
    required this.iconHeight,
    required this.sidebarWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF2563EB);
    Path path = Path();

    double radius = 35;
    double centerY = top + iconHeight / 2;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // curve starts a bit above icon center
    path.lineTo(size.width, centerY - radius);

    // smooth "water-drop" S-curve wrapping icon
    path.quadraticBezierTo(
        size.width, centerY, size.width - radius, centerY + radius / 2);
    path.quadraticBezierTo(size.width - 2 * radius, centerY + iconHeight / 2,
        size.width - radius, centerY + iconHeight - radius / 2);
    path.quadraticBezierTo(size.width, centerY + iconHeight, size.width,
        centerY + iconHeight + radius);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SidebarPainter oldDelegate) {
    return oldDelegate.top != top;
  }
}
