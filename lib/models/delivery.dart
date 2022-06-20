import 'package:my_app/models/contact_info.dart';

import 'location.dart';

class Delivery {
  String id;
  ContactInfo srcContact;
  ContactInfo destContact;
  bool express;
  String companyId;
  Location src;
  String srcAddress;
  Location dest;
  String destAddress;
  String status;
  String? courierId;
  String? deadline;
  List<dynamic>? vehicleTypes;

  Delivery(
      {required this.id,
      required this.srcContact,
      required this.destContact,
      required this.express,
      required this.companyId,
      required this.src,
      required this.srcAddress,
      required this.dest,
      required this.destAddress,
      required this.status,
      this.courierId,
      this.deadline,
      required this.vehicleTypes});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    //print(json);
    return Delivery(
        id: json['_id'],
        srcContact: ContactInfo.fromJson(json['src_contact']),
        destContact: ContactInfo.fromJson(json['dst_contact']),
        express: json['express'],
        companyId: json['company_id'],
        src: Location.fromJson(json['src']),
        srcAddress: json['src_address'],
        dest: Location.fromJson(json['dest']),
        destAddress: json['dest_address'],
        status: json['status'],
        courierId: json['courier_id'],
        deadline: json['deadline'],
        vehicleTypes: json['Vehicle_type']);
  }
}
