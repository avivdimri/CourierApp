class Courier {
  String first_name;
  String last_name;
  String email;
  String password;
  String phone_number;
  String VehicleType;
  List<String> company_id;
  String status;

  Courier({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.phone_number,
    required this.VehicleType,
    required this.company_id,
    this.status = "offline",
  });

  int getLength() {
    return 1;
  }

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email'],
        password: json['password'],
        phone_number: json['phone_number'],
        VehicleType: json['Vehicle_type'],
        company_id: json['company_id'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'password': password,
        'phone_number': phone_number,
        'Vehicle_type': VehicleType,
        'company_id': company_id,
        'status': status,
      };
}