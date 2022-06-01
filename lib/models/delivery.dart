import 'package:my_app/models/contact_info.dart';

import 'location.dart';

class Delivery {
  String id;
  ContactInfo src_contact;
  ContactInfo dst_contact;
  String timing;
  String company_id;
  Location src;
  String src_address;
  Location dest;
  String dest_address;
  String status;

  Delivery(
      {required this.id,
      required this.src_contact,
      required this.dst_contact,
      required this.timing,
      required this.company_id,
      required this.src,
      required this.src_address,
      required this.dest,
      required this.dest_address,
      required this.status});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        id: json['_id'],
        src_contact: ContactInfo.fromJson(json['src_contact']),
        dst_contact: ContactInfo.fromJson(json['dst_contact']),
        timing: json['express'],
        company_id: json['company_id'],
        src: Location.fromJson(json['src']),
        src_address: json['src_address'],
        dest: Location.fromJson(json['dest']),
        dest_address: json['dest_address'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'src_contact': src_contact,
        'timing': timing,
        'company_id': company_id,
        'src': src,
        'dest': dest,
        'status': status,
      };
}
