import 'location.dart';

class TripsHistoryModel {
  String? timing;
  Location? src;
  Location? dest;
  String? status;
  String? src_contact;
  String? company_id;
  String? id;

  TripsHistoryModel({
    this.timing,
    this.src,
    this.dest,
    this.status,
    this.src_contact,
    this.company_id,
    this.id,
  });

  factory TripsHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripsHistoryModel(
        id: json['_id'],
        src_contact: json['src_contact'],
        timing: json['timing'],
        company_id: json['company_id'],
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
