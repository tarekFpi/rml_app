import 'package:google_maps_flutter/google_maps_flutter.dart';

class TerminalDetails {
  TerminalDetails({
      String? terminalID, 
      String? terminalDataTimeLast, 
      String? terminalDataIsAccOnLast, 
      String? terminalDataVelocityLast, 
      String? terminalDataLatitudeLast, 
      String? terminalDataLongitudeLast, 
      String? geoLocationPositionLandmarkDistanceMeter, 
      String? terminalIsAccOnChangeTime, 
      String? terminalAssignmentCode, 
      String? carrierRegistrationNumber, 
      String? carrierName, 
      dynamic carrierUserName, 
      dynamic carrierUserDesignation, 
      dynamic carrierUserDepartment, 
      String? carrierTypeName, 
      String? carrierTypeOperatorTitle, 
      String? customerName, 
      String? customerCode, 
      String? providerName, 
      String? providerCode, 
      String? geoLocationName, 
      dynamic terminalInformationID, 
      dynamic terminalInformationSerial, 
      dynamic terminalInformationName, 
      dynamic terminalInformationDestination, 
      dynamic terminalInformationOverride, 
      dynamic terminalInformationOverrideAlways, 
      dynamic terminalInformationUseTagTerminalIsAccOn, 
      dynamic terminalInformationIsAccOn, 
      dynamic terminalInformationLatitude, 
      dynamic terminalInformationLongitude, 
      dynamic tagTerminalID, 
      dynamic tagTerminalTime, 
      dynamic tagTerminalIsAccOn, 
      dynamic tagTerminalVelocity, 
      dynamic tagTerminalLatitude, 
      dynamic tagTerminalLongitude, 
      dynamic operatorName, 
      dynamic operatorPhone, 
      dynamic operatorContactName, 
      dynamic operatorContactPhone, 
      dynamic employmentTypeNameOperator, 
      dynamic dutyTypeNameOperator,}){
    _terminalID = terminalID;
    _terminalDataTimeLast = terminalDataTimeLast;
    _terminalDataIsAccOnLast = terminalDataIsAccOnLast;
    _terminalDataVelocityLast = terminalDataVelocityLast;
    _terminalDataLatitudeLast = terminalDataLatitudeLast;
    _terminalDataLongitudeLast = terminalDataLongitudeLast;
    _geoLocationPositionLandmarkDistanceMeter = geoLocationPositionLandmarkDistanceMeter;
    _terminalIsAccOnChangeTime = terminalIsAccOnChangeTime;
    _terminalAssignmentCode = terminalAssignmentCode;
    _carrierRegistrationNumber = carrierRegistrationNumber;
    _carrierName = carrierName;
    _carrierUserName = carrierUserName;
    _carrierUserDesignation = carrierUserDesignation;
    _carrierUserDepartment = carrierUserDepartment;
    _carrierTypeName = carrierTypeName;
    _carrierTypeOperatorTitle = carrierTypeOperatorTitle;
    _customerName = customerName;
    _customerCode = customerCode;
    _providerName = providerName;
    _providerCode = providerCode;
    _geoLocationName = geoLocationName;
    _terminalInformationID = terminalInformationID;
    _terminalInformationSerial = terminalInformationSerial;
    _terminalInformationName = terminalInformationName;
    _terminalInformationDestination = terminalInformationDestination;
    _terminalInformationOverride = terminalInformationOverride;
    _terminalInformationOverrideAlways = terminalInformationOverrideAlways;
    _terminalInformationUseTagTerminalIsAccOn = terminalInformationUseTagTerminalIsAccOn;
    _terminalInformationIsAccOn = terminalInformationIsAccOn;
    _terminalInformationLatitude = terminalInformationLatitude;
    _terminalInformationLongitude = terminalInformationLongitude;
    _tagTerminalID = tagTerminalID;
    _tagTerminalTime = tagTerminalTime;
    _tagTerminalIsAccOn = tagTerminalIsAccOn;
    _tagTerminalVelocity = tagTerminalVelocity;
    _tagTerminalLatitude = tagTerminalLatitude;
    _tagTerminalLongitude = tagTerminalLongitude;
    _operatorName = operatorName;
    _operatorPhone = operatorPhone;
    _operatorContactName = operatorContactName;
    _operatorContactPhone = operatorContactPhone;
    _employmentTypeNameOperator = employmentTypeNameOperator;
    _dutyTypeNameOperator = dutyTypeNameOperator;
}
  TerminalDetails.fromJson(dynamic json) {
    _terminalID = json['TerminalID'];
    _terminalDataTimeLast = json['TerminalDataTimeLast'];
    _terminalDataIsAccOnLast = json['TerminalDataIsAccOnLast'];
    _terminalDataVelocityLast = json['TerminalDataVelocityLast'];
    _terminalDataLatitudeLast = json['TerminalDataLatitudeLast'];
    _terminalDataLongitudeLast = json['TerminalDataLongitudeLast'];
    _geoLocationPositionLandmarkDistanceMeter = json['GeoLocationPositionLandmarkDistanceMeter'];
    _terminalIsAccOnChangeTime = json['TerminalIsAccOnChangeTime'];
    _terminalAssignmentCode = json['TerminalAssignmentCode'];
    _carrierRegistrationNumber = json['CarrierRegistrationNumber'];
    _carrierName = json['CarrierName'];
    _carrierUserName = json['CarrierUserName'];
    _carrierUserDesignation = json['CarrierUserDesignation'];
    _carrierUserDepartment = json['CarrierUserDepartment'];
    _carrierTypeName = json['CarrierTypeName'];
    _carrierTypeOperatorTitle = json['CarrierTypeOperatorTitle'];
    _customerName = json['CustomerName'];
    _customerCode = json['CustomerCode'];
    _providerName = json['ProviderName'];
    _providerCode = json['ProviderCode'];
    _geoLocationName = json['GeoLocationName'];
    _terminalInformationID = json['TerminalInformationID'];
    _terminalInformationSerial = json['TerminalInformationSerial'];
    _terminalInformationName = json['TerminalInformationName'];
    _terminalInformationDestination = json['TerminalInformationDestination'];
    _terminalInformationOverride = json['TerminalInformationOverride'];
    _terminalInformationOverrideAlways = json['TerminalInformationOverrideAlways'];
    _terminalInformationUseTagTerminalIsAccOn = json['TerminalInformationUseTagTerminalIsAccOn'];
    _terminalInformationIsAccOn = json['TerminalInformationIsAccOn'];
    _terminalInformationLatitude = json['TerminalInformationLatitude'];
    _terminalInformationLongitude = json['TerminalInformationLongitude'];
    _tagTerminalID = json['TagTerminalID'];
    _tagTerminalTime = json['TagTerminalTime'];
    _tagTerminalIsAccOn = json['TagTerminalIsAccOn'];
    _tagTerminalVelocity = json['TagTerminalVelocity'];
    _tagTerminalLatitude = json['TagTerminalLatitude'];
    _tagTerminalLongitude = json['TagTerminalLongitude'];
    _operatorName = json['OperatorName'];
    _operatorPhone = json['OperatorPhone'];
    _operatorContactName = json['OperatorContactName'];
    _operatorContactPhone = json['OperatorContactPhone'];
    _employmentTypeNameOperator = json['EmploymentTypeNameOperator'];
    _dutyTypeNameOperator = json['DutyTypeNameOperator'];
  }
  String? _terminalID;
  String? _terminalDataTimeLast;
  String? _terminalDataIsAccOnLast;
  String? _terminalDataVelocityLast;
  String? _terminalDataLatitudeLast;
  String? _terminalDataLongitudeLast;
  String? _geoLocationPositionLandmarkDistanceMeter;
  String? _terminalIsAccOnChangeTime;
  String? _terminalAssignmentCode;
  String? _carrierRegistrationNumber;
  String? _carrierName;
  dynamic _carrierUserName;
  dynamic _carrierUserDesignation;
  dynamic _carrierUserDepartment;
  String? _carrierTypeName;
  String? _carrierTypeOperatorTitle;
  String? _customerName;
  String? _customerCode;
  String? _providerName;
  String? _providerCode;
  String? _geoLocationName;
  dynamic _terminalInformationID;
  dynamic _terminalInformationSerial;
  dynamic _terminalInformationName;
  dynamic _terminalInformationDestination;
  dynamic _terminalInformationOverride;
  dynamic _terminalInformationOverrideAlways;
  dynamic _terminalInformationUseTagTerminalIsAccOn;
  dynamic _terminalInformationIsAccOn;
  dynamic _terminalInformationLatitude;
  dynamic _terminalInformationLongitude;
  dynamic _tagTerminalID;
  dynamic _tagTerminalTime;
  dynamic _tagTerminalIsAccOn;
  dynamic _tagTerminalVelocity;
  dynamic _tagTerminalLatitude;
  dynamic _tagTerminalLongitude;
  dynamic _operatorName;
  dynamic _operatorPhone;
  dynamic _operatorContactName;
  dynamic _operatorContactPhone;
  dynamic _employmentTypeNameOperator;
  dynamic _dutyTypeNameOperator;

  String? get terminalID => _terminalID;
  String? get terminalDataTimeLast => _terminalDataTimeLast;
  String? get terminalDataIsAccOnLast => _terminalDataIsAccOnLast;
  String? get terminalDataVelocityLast => _terminalDataVelocityLast;
  String? get terminalDataLatitudeLast => _terminalDataLatitudeLast;
  String? get terminalDataLongitudeLast => _terminalDataLongitudeLast;
  String? get geoLocationPositionLandmarkDistanceMeter => _geoLocationPositionLandmarkDistanceMeter;
  String? get terminalIsAccOnChangeTime => _terminalIsAccOnChangeTime;
  String? get terminalAssignmentCode => _terminalAssignmentCode;
  String? get carrierRegistrationNumber => _carrierRegistrationNumber;
  String? get carrierName => _carrierName;
  dynamic get carrierUserName => _carrierUserName;
  dynamic get carrierUserDesignation => _carrierUserDesignation;
  dynamic get carrierUserDepartment => _carrierUserDepartment;
  String? get carrierTypeName => _carrierTypeName;
  String? get carrierTypeOperatorTitle => _carrierTypeOperatorTitle;
  String? get customerName => _customerName;
  String? get customerCode => _customerCode;
  String? get providerName => _providerName;
  String? get providerCode => _providerCode;
  String? get geoLocationName => _geoLocationName;
  dynamic get terminalInformationID => _terminalInformationID;
  dynamic get terminalInformationSerial => _terminalInformationSerial;
  dynamic get terminalInformationName => _terminalInformationName;
  dynamic get terminalInformationDestination => _terminalInformationDestination;
  dynamic get terminalInformationOverride => _terminalInformationOverride;
  dynamic get terminalInformationOverrideAlways => _terminalInformationOverrideAlways;
  dynamic get terminalInformationUseTagTerminalIsAccOn => _terminalInformationUseTagTerminalIsAccOn;
  dynamic get terminalInformationIsAccOn => _terminalInformationIsAccOn;
  dynamic get terminalInformationLatitude => _terminalInformationLatitude;
  dynamic get terminalInformationLongitude => _terminalInformationLongitude;
  dynamic get tagTerminalID => _tagTerminalID;
  dynamic get tagTerminalTime => _tagTerminalTime;
  dynamic get tagTerminalIsAccOn => _tagTerminalIsAccOn;
  dynamic get tagTerminalVelocity => _tagTerminalVelocity;
  dynamic get tagTerminalLatitude => _tagTerminalLatitude;
  dynamic get tagTerminalLongitude => _tagTerminalLongitude;
  dynamic get operatorName => _operatorName;
  dynamic get operatorPhone => _operatorPhone;
  dynamic get operatorContactName => _operatorContactName;
  dynamic get operatorContactPhone => _operatorContactPhone;
  dynamic get employmentTypeNameOperator => _employmentTypeNameOperator;
  dynamic get dutyTypeNameOperator => _dutyTypeNameOperator;

  LatLng getLatLong(){
    return LatLng(double.parse(_terminalDataLatitudeLast ?? "0"), double.parse(_terminalDataLongitudeLast ?? "0"));
  }

  double getSpeed(){
    if(_terminalDataVelocityLast == null) return 00.0;
    return double.parse(_terminalDataVelocityLast!);
  }

  double getLandMarkDistance(){
    if(_geoLocationPositionLandmarkDistanceMeter == null || _geoLocationPositionLandmarkDistanceMeter == "") return 0.0;
    var meter = double.parse(_geoLocationPositionLandmarkDistanceMeter!);
    return meter/1000;
  }

  String getTerminalAsset(){
    var terminal = "pick_up.png";

    if(_carrierTypeName == "3Wheeler LPG" || _carrierTypeName == "CNG"){
      terminal = "cng.png";
    }
    if(_carrierTypeName == "Car"){
      terminal = "car.png";
    }
    if(_carrierTypeName == "Lorry"){
      terminal = "lorry.png";
    }
    if(_carrierTypeName == "Pick up"){
      terminal = "pick_up.png";
    }
    if(_carrierTypeName == "Bike"){
      terminal = "bike.png";
    }
    if(_carrierTypeName == "Van"){
      terminal = "van.png";
    }

    return "assets/images/terminals/$terminal";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TerminalID'] = _terminalID;
    map['TerminalDataTimeLast'] = _terminalDataTimeLast;
    map['TerminalDataIsAccOnLast'] = _terminalDataIsAccOnLast;
    map['TerminalDataVelocityLast'] = _terminalDataVelocityLast;
    map['TerminalDataLatitudeLast'] = _terminalDataLatitudeLast;
    map['TerminalDataLongitudeLast'] = _terminalDataLongitudeLast;
    map['GeoLocationPositionLandmarkDistanceMeter'] = _geoLocationPositionLandmarkDistanceMeter;
    map['TerminalIsAccOnChangeTime'] = _terminalIsAccOnChangeTime;
    map['TerminalAssignmentCode'] = _terminalAssignmentCode;
    map['CarrierRegistrationNumber'] = _carrierRegistrationNumber;
    map['CarrierName'] = _carrierName;
    map['CarrierUserName'] = _carrierUserName;
    map['CarrierUserDesignation'] = _carrierUserDesignation;
    map['CarrierUserDepartment'] = _carrierUserDepartment;
    map['CarrierTypeName'] = _carrierTypeName;
    map['CarrierTypeOperatorTitle'] = _carrierTypeOperatorTitle;
    map['CustomerName'] = _customerName;
    map['CustomerCode'] = _customerCode;
    map['ProviderName'] = _providerName;
    map['ProviderCode'] = _providerCode;
    map['GeoLocationName'] = _geoLocationName;
    map['TerminalInformationID'] = _terminalInformationID;
    map['TerminalInformationSerial'] = _terminalInformationSerial;
    map['TerminalInformationName'] = _terminalInformationName;
    map['TerminalInformationDestination'] = _terminalInformationDestination;
    map['TerminalInformationOverride'] = _terminalInformationOverride;
    map['TerminalInformationOverrideAlways'] = _terminalInformationOverrideAlways;
    map['TerminalInformationUseTagTerminalIsAccOn'] = _terminalInformationUseTagTerminalIsAccOn;
    map['TerminalInformationIsAccOn'] = _terminalInformationIsAccOn;
    map['TerminalInformationLatitude'] = _terminalInformationLatitude;
    map['TerminalInformationLongitude'] = _terminalInformationLongitude;
    map['TagTerminalID'] = _tagTerminalID;
    map['TagTerminalTime'] = _tagTerminalTime;
    map['TagTerminalIsAccOn'] = _tagTerminalIsAccOn;
    map['TagTerminalVelocity'] = _tagTerminalVelocity;
    map['TagTerminalLatitude'] = _tagTerminalLatitude;
    map['TagTerminalLongitude'] = _tagTerminalLongitude;
    map['OperatorName'] = _operatorName;
    map['OperatorPhone'] = _operatorPhone;
    map['OperatorContactName'] = _operatorContactName;
    map['OperatorContactPhone'] = _operatorContactPhone;
    map['EmploymentTypeNameOperator'] = _employmentTypeNameOperator;
    map['DutyTypeNameOperator'] = _dutyTypeNameOperator;
    return map;
  }

}