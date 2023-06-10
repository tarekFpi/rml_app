class Event {
  Event({
    String? terminalID,
    String? time,
    String? terminalEventID,
    dynamic terminalGeoFenceAreaEventID,
    String? latitude,
    String? longitude,
    String? subjectIdentifier,
    String? subject,
    String? actionIdentifier,
    String? action,
    dynamic comment,
    dynamic numericFactor,
    String? terminalDataID,
    dynamic timeAccOff,
    String? geoLocationID,
    String? geoLocationDistanceMeter,
    dynamic durationTimeAccOff,}){
    _terminalID = terminalID;
    _time = time;
    _terminalEventID = terminalEventID;
    _terminalGeoFenceAreaEventID = terminalGeoFenceAreaEventID;
    _latitude = latitude;
    _longitude = longitude;
    _subjectIdentifier = subjectIdentifier;
    _subject = subject;
    _actionIdentifier = actionIdentifier;
    _action = action;
    _comment = comment;
    _numericFactor = numericFactor;
    _terminalDataID = terminalDataID;
    _timeAccOff = timeAccOff;
    _geoLocationID = geoLocationID;
    _geoLocationDistanceMeter = geoLocationDistanceMeter;
    _durationTimeAccOff = durationTimeAccOff;
  }

  Event.fromJson(dynamic json) {
    _terminalID = json['TerminalID'];
    _time = json['Time'];
    _terminalEventID = json['TerminalEventID'];
    _terminalGeoFenceAreaEventID = json['TerminalGeoFenceAreaEventID'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
    _subjectIdentifier = json['SubjectIdentifier'];
    _subject = json['Subject'];
    _actionIdentifier = json['ActionIdentifier'];
    _action = json['Action'];
    _comment = json['Comment'];
    _numericFactor = json['NumericFactor'];
    _terminalDataID = json['TerminalDataID'];
    _timeAccOff = json['TimeAccOff'];
    _geoLocationID = json['GeoLocationID'];
    _geoLocationDistanceMeter = json['GeoLocationDistanceMeter'];
    _durationTimeAccOff = json['DurationTimeAccOff'];
  }
  String? _terminalID;
  String? _time;
  String? _terminalEventID;
  dynamic _terminalGeoFenceAreaEventID;
  String? _latitude;
  String? _longitude;
  String? _subjectIdentifier;
  String? _subject;
  String? _actionIdentifier;
  String? _action;
  dynamic _comment;
  dynamic _numericFactor;
  String? _terminalDataID;
  dynamic _timeAccOff;
  String? _geoLocationID;
  String? _geoLocationDistanceMeter;
  dynamic _durationTimeAccOff;

  String? get terminalID => _terminalID;
  String? get time => _time;
  String? get terminalEventID => _terminalEventID;
  dynamic get terminalGeoFenceAreaEventID => _terminalGeoFenceAreaEventID;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get subjectIdentifier => _subjectIdentifier;
  String? get subject => _subject;
  String? get actionIdentifier => _actionIdentifier;
  String? get action => _action;
  dynamic get comment => _comment;
  dynamic get numericFactor => _numericFactor;
  String? get terminalDataID => _terminalDataID;
  dynamic get timeAccOff => _timeAccOff;
  String? get geoLocationID => _geoLocationID;
  String? get geoLocationDistanceMeter => _geoLocationDistanceMeter;
  dynamic get durationTimeAccOff => _durationTimeAccOff;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TerminalID'] = _terminalID;
    map['Time'] = _time;
    map['TerminalEventID'] = _terminalEventID;
    map['TerminalGeoFenceAreaEventID'] = _terminalGeoFenceAreaEventID;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    map['SubjectIdentifier'] = _subjectIdentifier;
    map['Subject'] = _subject;
    map['ActionIdentifier'] = _actionIdentifier;
    map['Action'] = _action;
    map['Comment'] = _comment;
    map['NumericFactor'] = _numericFactor;
    map['TerminalDataID'] = _terminalDataID;
    map['TimeAccOff'] = _timeAccOff;
    map['GeoLocationID'] = _geoLocationID;
    map['GeoLocationDistanceMeter'] = _geoLocationDistanceMeter;
    map['DurationTimeAccOff'] = _durationTimeAccOff;
    return map;
  }

}