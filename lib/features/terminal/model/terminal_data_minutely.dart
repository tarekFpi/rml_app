class TerminalDataMinutely {
  TerminalDataMinutely({
      String? terminalDataMinutelyTimeFrom, 
      String? terminalDataMinutelyTimeTo, 
      String? terminalDataMinutelyCount, 
      String? terminalDataMinutelyDistanceMeter, 
      String? terminalID, 
      String? providerCode, 
      String? providerName, 
      String? terminalAssignmentCode, 
      String? customerCode, 
      String? customerName, 
      String? carrierRegistrationNumber, 
      String? carrierName, 
      String? carrierTypeName,}){
    _terminalDataMinutelyTimeFrom = terminalDataMinutelyTimeFrom;
    _terminalDataMinutelyTimeTo = terminalDataMinutelyTimeTo;
    _terminalDataMinutelyCount = terminalDataMinutelyCount;
    _terminalDataMinutelyDistanceMeter = terminalDataMinutelyDistanceMeter;
    _terminalID = terminalID;
    _providerCode = providerCode;
    _providerName = providerName;
    _terminalAssignmentCode = terminalAssignmentCode;
    _customerCode = customerCode;
    _customerName = customerName;
    _carrierRegistrationNumber = carrierRegistrationNumber;
    _carrierName = carrierName;
    _carrierTypeName = carrierTypeName;
}

  TerminalDataMinutely.fromJson(dynamic json) {
    _terminalDataMinutelyTimeFrom = json['TerminalDataMinutelyTimeFrom'];
    _terminalDataMinutelyTimeTo = json['TerminalDataMinutelyTimeTo'];
    _terminalDataMinutelyCount = json['TerminalDataMinutelyCount'];
    _terminalDataMinutelyDistanceMeter = json['TerminalDataMinutelyDistanceMeter'];
    _terminalID = json['TerminalID'];
    _providerCode = json['ProviderCode'];
    _providerName = json['ProviderName'];
    _terminalAssignmentCode = json['TerminalAssignmentCode'];
    _customerCode = json['CustomerCode'];
    _customerName = json['CustomerName'];
    _carrierRegistrationNumber = json['CarrierRegistrationNumber'];
    _carrierName = json['CarrierName'];
    _carrierTypeName = json['CarrierTypeName'];
  }
  String? _terminalDataMinutelyTimeFrom;
  String? _terminalDataMinutelyTimeTo;
  String? _terminalDataMinutelyCount;
  String? _terminalDataMinutelyDistanceMeter;
  String? _terminalID;
  String? _providerCode;
  String? _providerName;
  String? _terminalAssignmentCode;
  String? _customerCode;
  String? _customerName;
  String? _carrierRegistrationNumber;
  String? _carrierName;
  String? _carrierTypeName;

  String? get terminalDataMinutelyTimeFrom => _terminalDataMinutelyTimeFrom;
  String? get terminalDataMinutelyTimeTo => _terminalDataMinutelyTimeTo;
  String? get terminalDataMinutelyCount => _terminalDataMinutelyCount;
  String? get terminalDataMinutelyDistanceMeter => _terminalDataMinutelyDistanceMeter;
  String? get terminalID => _terminalID;
  String? get providerCode => _providerCode;
  String? get providerName => _providerName;
  String? get terminalAssignmentCode => _terminalAssignmentCode;
  String? get customerCode => _customerCode;
  String? get customerName => _customerName;
  String? get carrierRegistrationNumber => _carrierRegistrationNumber;
  String? get carrierName => _carrierName;
  String? get carrierTypeName => _carrierTypeName;

  double getDistanceInKm(){
    if(_terminalDataMinutelyDistanceMeter == null) return 0.0;

    var meter = double.parse(_terminalDataMinutelyDistanceMeter!);
    return meter/1000;
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TerminalDataMinutelyTimeFrom'] = _terminalDataMinutelyTimeFrom;
    map['TerminalDataMinutelyTimeTo'] = _terminalDataMinutelyTimeTo;
    map['TerminalDataMinutelyCount'] = _terminalDataMinutelyCount;
    map['TerminalDataMinutelyDistanceMeter'] = _terminalDataMinutelyDistanceMeter;
    map['TerminalID'] = _terminalID;
    map['ProviderCode'] = _providerCode;
    map['ProviderName'] = _providerName;
    map['TerminalAssignmentCode'] = _terminalAssignmentCode;
    map['CustomerCode'] = _customerCode;
    map['CustomerName'] = _customerName;
    map['CarrierRegistrationNumber'] = _carrierRegistrationNumber;
    map['CarrierName'] = _carrierName;
    map['CarrierTypeName'] = _carrierTypeName;
    return map;
  }

}