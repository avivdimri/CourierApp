import 'location.dart';

class Delivery {
  String id;
  String src_contact;
  String timing;
  int company_id;
  Location src;
  Location dest;
  String status;

  Delivery(
      {required this.id,
      required this.src_contact,
      required this.timing,
      required this.company_id,
      required this.src,
      required this.dest,
      required this.status});

  int getLength() {
    return 1;
  }

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        id: json['_id'],
        src_contact: json['src_contact'],
        timing: json['timing'],
        company_id: int.parse(json['company_id']),
        src: Location.fromJson(json['src']),
        dest: Location.fromJson(json['destination']),
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
