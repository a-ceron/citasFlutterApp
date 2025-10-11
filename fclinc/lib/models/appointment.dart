import 'client.dart';
import 'employee.dart';
import 'procedure.dart';

class Appointment {
  final int id;
  final String date;
  final String time;
  final Client client;
  final Employee employee;
  final Procedure procedure;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.client,
    required this.employee,
    required this.procedure,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      client: Client.fromJson(json['client']),
      employee: Employee.fromJson(json['employee']),
      procedure: Procedure.fromJson(json['procedure']),
    );
  }
}
