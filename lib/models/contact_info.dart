class ContactInfo {
  String name;
  String phone;
  ContactInfo({required this.name, required this.phone});
  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };
}
