class GeoLocation {
  GeoLocation({
    String? id,
    String? name,
    String? latitude,
    String? longitude,}){
    _id = id;
    _name = name;
    _latitude = latitude;
    _longitude = longitude;
  }

  GeoLocation.fromJson(dynamic json) {
    _id = json['ID'];
    _name = json['Name'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
  }
  String? _id;
  String? _name;
  String? _latitude;
  String? _longitude;

  String? get id => _id;
  String? get name => _name;
  String? get latitude => _latitude;
  String? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['Name'] = _name;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    return map;
  }

}