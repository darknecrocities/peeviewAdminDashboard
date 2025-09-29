import 'package:flutter/material.dart';

class ActionTile extends StatefulWidget {
  final IconData icon;
  final String title;

  const ActionTile({super.key, required this.icon, required this.title});

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: hover ? [Colors.blue.shade700, Colors.blue.shade600] : [Colors.blue.shade600, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: hover
              ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))]
              : [],
        ),
        child: InkWell(
          onTap: () {
            // placeholder
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.title} tapped')));
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 36, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
