class Courier {
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  String vehicleType;
  List<dynamic> companyId;
  String status;

  Courier({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.vehicleType,
    this.companyId = const [],
    this.status = "offline",
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['user_name'],
        password: json['password'],
        phoneNumber: json['phone_number'],
        vehicleType: json['Vehicle_type'],
        companyId: json['company_id'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'user_name': email,
        'password': password,
        'phone_number': phoneNumber,
        'VehicleType': vehicleType,
        'company_id': companyId,
        'status': status,
      };
}
