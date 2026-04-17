class UserModel {
 final String id;
  final String fullName;
  final String email;
  final String password;
  final String addressLine1;
  final String? addressLine2; // optional
  final String phone;
  final DateTime createdAt;
  final String districtId;
  final String postalCode;
  final String? description; // optional
  final String status;
  final String role;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.addressLine1,
    this.addressLine2,
    required this.phone,
    required this.createdAt,
    required this.districtId,
    required this.postalCode,
    this.description,
    required this.status,
    required this.role,
  });

  // 🔄 JSON → Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'], // nullable
      phone: json['phone'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      districtId: json['district_id'] ?? '',
      postalCode: json['postal_code'] ?? '',
      description: json['description'], // nullable
      status: json['status'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // 🔁 Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'district_id': districtId,
      'postal_code': postalCode,
      'description': description,
      'status': status,
      'role': role,
    };
  }
}
