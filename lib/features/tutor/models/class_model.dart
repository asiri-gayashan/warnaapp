class ClassModel {
  final String id;

  // Basic Info
  final String subject;
  final String grade;
  final String name;
  final String? teacherId;

  // Schedule
  final String day;
  final String time;
  final String duration;

  // Class Details
  final String location;
  final String description;

  // Status
  final bool status;

  // Optional institute
  final String? instituteId;

  // Student Count
  final int? totalStudents;

  ClassModel({
    required this.id,
    required this.subject,
    required this.grade,
    required this.day,
    required this.name,
    required this.time,
    required this.duration,
    required this.location,
    required this.description,
    required this.status,
    this.instituteId,
    this.teacherId,
    this.totalStudents,
  });

  // 👇 Add this factory constructor inside your class
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id']?.toString() ?? '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      day: json['day'] ?? '',
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      duration: json['duration']?.toString() ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? true,
      instituteId: json['instituteId']?.toString(),
      teacherId: json['teacherId']?.toString(),
      totalStudents: json['students'] != null ? (json['students'] as List).length : 0,
    );
  }
}