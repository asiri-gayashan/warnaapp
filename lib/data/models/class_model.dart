class ClassModel {
  final String id;
  final String name;
  final String subjectId;
  final String tutorId;
  final String instituteId;
  final String startTime;
  final String endTime;
  final int day;
  final String description;
  final String status;
  final DateTime createdAt;
  final int studentCount;
  final double amount;
  final double instituteCommission;
  final String location;
  final int grade;
  final String subjectName;
  final String tutorName;
  final String instituteName;
  final String duration;

  ClassModel({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.tutorId,
    required this.instituteId,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.studentCount,
    required this.amount,
    required this.instituteCommission,
    required this.location,
    required this.grade,
    required this.subjectName,
    required this.tutorName,
    required this.instituteName,
    required this.duration,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subjectId: json['subject_id'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      instituteId: json['institute_id'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      day: json['day'] ?? 0,
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      studentCount: json['student_count'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      instituteCommission: (json['institute_commission'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      grade: json['grade'] ?? 0,
      subjectName: json['subject_name'] ?? '',
      tutorName: json['tutor_name'] ?? '',
      instituteName: json['institute_name'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "subject_id": subjectId,
      "tutor_id": tutorId,
      "institute_id": instituteId,
      "start_time": startTime,
      "end_time": endTime,
      "day": day,
      "description": description,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "student_count": studentCount,
      "amount": amount,
      "institute_commission": instituteCommission,
      "location": location,
      "grade": grade,
      "subject_name": subjectName,
      "tutor_name": tutorName,
      "institute_name": instituteName,
      "duration": duration,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
