class Courier {
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  String vehicleType;
  List<dynamic> companyNames;
  String status;

  Courier({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.vehicleType,
    this.companyNames = const [],
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
        companyNames: json['company_name'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'user_name': email,
        'password': password,
        'phone_number': phoneNumber,
        'VehicleType': vehicleType,
        'status': status,
      };
}
