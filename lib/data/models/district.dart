class District {
  final String id;
  final String name;
  final String createdAt;

  District({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json['id'],
    name: json['name'],
    createdAt: json['created_at'],
  );
}