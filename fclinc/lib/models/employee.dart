class Employee {
  final int id;
  final String name;
  final String role;

  Employee({
    required this.id,
    required this.name,
    required this.role,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}
