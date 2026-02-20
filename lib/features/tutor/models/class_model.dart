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

  // Meta

  // Student Count (kept as requested)
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


}