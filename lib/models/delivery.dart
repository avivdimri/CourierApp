import 'package:my_app/models/contact_info.dart';

import 'location.dart';

class Delivery {
  String id;
  ContactInfo src_contact;
  ContactInfo dst_contact;
  bool express;
  String company_id;
  Location src;
  String src_address;
  Location dest;
  String dest_address;
  String status;
  String? courier_id;
  String? deadline;

  Delivery(
      {required this.id,
      required this.src_contact,
      required this.dst_contact,
      required this.express,
      required this.company_id,
      required this.src,
      required this.src_address,
      required this.dest,
      required this.dest_address,
      required this.status,
      this.courier_id,
      this.deadline});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        id: json['_id'],
        src_contact: ContactInfo.fromJson(json['src_contact']),
        dst_contact: ContactInfo.fromJson(json['dst_contact']),
        express: json['express'],
        company_id: json['company_id'],
        src: Location.fromJson(json['src']),
        src_address: json['src_address'],
        dest: Location.fromJson(json['dest']),
        dest_address: json['dest_address'],
        status: json['status'],
        courier_id: json['courier_id'],
        deadline: json['deadline']);
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'src_contact': src_contact,
        'exress': express,
        'company_id': company_id,
        'src': src,
        'dest': dest,
        'status': status,
      };
}
