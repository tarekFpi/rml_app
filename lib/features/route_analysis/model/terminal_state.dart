import 'package:google_maps_flutter/google_maps_flutter.dart';

class TerminalState {
  TerminalState({
    String? terminalID,
    String? id,
    String? time,
    String? latitude,
    String? longitude,
    String? isAccOn,
    String? velocityKmH,
    String? geoLocationID,
    String? geoLocationDistanceMeter,
    String? durationSecond,
    String? distanceMeter,
    String? velocityGPSKmH,
    String? bearing,
    String? isPitStopEnd,
    String? motionStateID,}){
    _terminalID = terminalID;
    _id = id;
    _time = time;
    _latitude = latitude;
    _longitude = longitude;
    _isAccOn = isAccOn;
    _velocityKmH = velocityKmH;
    _geoLocationID = geoLocationID;
    _geoLocationDistanceMeter = geoLocationDistanceMeter;
    _durationSecond = durationSecond;
    _distanceMeter = distanceMeter;
    _velocityGPSKmH = velocityGPSKmH;
    _bearing = bearing;
    _isPitStopEnd = isPitStopEnd;
    _motionStateID = motionStateID;
  }

  TerminalState.fromJson(dynamic json) {
    _terminalID = json['TerminalID'];
    _id = json['ID'];
    _time = json['Time'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
    _isAccOn = json['IsAccOn'];
    _velocityKmH = json['VelocityKmH'];
    _geoLocationID = json['GeoLocationID'];
    _geoLocationDistanceMeter = json['GeoLocationDistanceMeter'];
    _durationSecond = json['DurationSecond'];
    _distanceMeter = json['DistanceMeter'];
    _velocityGPSKmH = json['VelocityGPSKmH'];
    _bearing = json['Bearing'];
    _isPitStopEnd = json['IsPitStopEnd'];
    _motionStateID = json['MotionStateID'];
  }
  String? _terminalID;
  String? _id;
  String? _time;
  String? _latitude;
  String? _longitude;
  String? _isAccOn;
  String? _velocityKmH;
  String? _geoLocationID;
  String? _geoLocationDistanceMeter;
  String? _durationSecond;
  String? _distanceMeter;
  String? _velocityGPSKmH;
  String? _bearing;
  String? _isPitStopEnd;
  String? _motionStateID;

  String? get terminalID => _terminalID;
  String? get id => _id;
  String? get time => _time;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get isAccOn => _isAccOn;
  String? get velocityKmH => _velocityKmH;
  String? get geoLocationID => _geoLocationID;
  String? get geoLocationDistanceMeter => _geoLocationDistanceMeter;
  String? get durationSecond => _durationSecond;
  String? get distanceMeter => _distanceMeter;
  String? get velocityGPSKmH => _velocityGPSKmH;
  String? get bearing => _bearing;
  String? get isPitStopEnd => _isPitStopEnd;
  String? get motionStateID => _motionStateID;

  LatLng getLatLng() {
    return LatLng(double.parse(_latitude ?? "0"), double.parse(_longitude ?? "0"));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TerminalID'] = _terminalID;
    map['ID'] = _id;
    map['Time'] = _time;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    map['IsAccOn'] = _isAccOn;
    map['VelocityKmH'] = _velocityKmH;
    map['GeoLocationID'] = _geoLocationID;
    map['GeoLocationDistanceMeter'] = _geoLocationDistanceMeter;
    map['DurationSecond'] = _durationSecond;
    map['DistanceMeter'] = _distanceMeter;
    map['VelocityGPSKmH'] = _velocityGPSKmH;
    map['Bearing'] = _bearing;
    map['IsPitStopEnd'] = _isPitStopEnd;
    map['MotionStateID'] = _motionStateID;
    return map;
  }

}