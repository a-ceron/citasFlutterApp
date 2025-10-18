import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/google_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// Groups events by Date (year/month/day)
  Map<DateTime, List<Map<String, dynamic>>> _groupEventsByDate(
      List<Map<String, dynamic>> events) {
    final Map<DateTime, List<Map<String, dynamic>>> data = {};
    for (var event in events) {
      final date = DateTime.parse(event['start']).toLocal();
      final key = DateTime(date.year, date.month, date.day);
      if (data.containsKey(key)) {
        data[key]!.add(event);
      } else {
        data[key] = [event];
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final eventsMap = _groupEventsByDate(calendarProvider.events);

    return Scaffold(
      body: calendarProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Week-only view
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: (day) => eventsMap[day] ?? [],
                  calendarFormat: CalendarFormat.week, // <-- Week view only
                  availableCalendarFormats: const {
                    CalendarFormat.week: 'Semana', // lock to week
                  },
                  headerVisible: false, // hides month/year header
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: (eventsMap[_selectedDay] ?? []).isEmpty
                      ? const Center(
                          child: Text(
                            'No hay eventos este día',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: eventsMap[_selectedDay]!.length,
                          itemBuilder: (context, index) {
                            final event = eventsMap[_selectedDay]![index];
                            final start = DateTime.tryParse(event['start']);
                            final end = DateTime.tryParse(event['end']);

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.event,
                                      color: Colors.blue),
                                ),
                                title: Text(
                                  event['summary'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                subtitle: start != null && end != null
                                    ? Text(
                                        '${TimeOfDay.fromDateTime(start).format(context)} - ${TimeOfDay.fromDateTime(end).format(context)}',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      )
                                    : null,
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  // Optional: show detailed view of the event
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
