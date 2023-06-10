class MotionState {
  MotionState({
    String? id,
    String? maximumKmH,
    String? caption,
    String? color,}){
    _id = id;
    _maximumKmH = maximumKmH;
    _caption = caption;
    _color = color;
  }

  MotionState.fromJson(dynamic json) {
    _id = json['ID'];
    _maximumKmH = json['MaximumKmH'];
    _caption = json['Caption'];
    _color = json['Color'];
  }
  String? _id;
  String? _maximumKmH;
  String? _caption;
  String? _color;

  String? get id => _id;
  String? get maximumKmH => _maximumKmH;
  String? get caption => _caption;
  String? get color => _color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['MaximumKmH'] = _maximumKmH;
    map['Caption'] = _caption;
    map['Color'] = _color;
    return map;
  }

}