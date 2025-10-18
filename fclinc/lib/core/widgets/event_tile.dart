import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  final String title;
  final String? start;
  final String? end;
  final VoidCallback? onTap;

  const EventTile({
    super.key,
    required this.title,
    this.start,
    this.end,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.event),
      title: Text(title),
      subtitle:
          start != null ? Text(end != null ? '$start - $end' : '$start') : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
