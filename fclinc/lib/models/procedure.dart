class Procedure {
  final int id;
  final String name;
  final double cost;

  Procedure({
    required this.id,
    required this.name,
    required this.cost,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'],
      name: json['name'],
      cost: (json['cost'] as num).toDouble(),
    );
  }
}
