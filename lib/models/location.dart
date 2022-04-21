class Location {
  String lat;
  String long;
  Location({required this.lat, required this.long});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'], long: json['long']);
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'long': long,
      };
}
