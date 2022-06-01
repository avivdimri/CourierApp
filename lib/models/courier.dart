class Courier {
  String first_name;
  String last_name;
  String email;
  String password;
  String phone_number;
  String VehicleType;
  List<dynamic> company_id;
  String status;

  Courier({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.phone_number,
    required this.VehicleType,
    this.company_id = const [],
    this.status = "offline",
  });

  int getLength() {
    return 1;
  }

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['user_name'],
        password: json['password'],
        phone_number: json['phone_number'],
        VehicleType: json['VehicleType'],
        company_id: json['company_id'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'user_name': email,
        'password': password,
        'phone_number': phone_number,
        'VehicleType': VehicleType,
        'company_id': company_id,
        'status': status,
      };
}
