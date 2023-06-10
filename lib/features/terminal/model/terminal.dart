import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';

class Terminal {
  Terminal({
    String? terminalID,
    String? terminalDataLatitudeLast,
    String? terminalDataLongitudeLast,
    String? terminalAssignmentCode,
    String? carrierRegistrationNumber, String? carrierName, String? carrierTypeName, String? terminalDataTimeLast, String? terminalAssignmentIsSuspended}){
    _terminalID = terminalID;
    _terminalDataLatitudeLast = terminalDataLatitudeLast;
    _terminalDataLongitudeLast = terminalDataLongitudeLast;
    _terminalAssignmentCode = terminalAssignmentCode;
    _carrierRegistrationNumber = carrierRegistrationNumber;
    _carrierName = carrierName;
    _carrierTypeName = carrierTypeName;
    _terminalDataTimeLast = terminalDataTimeLast;
    _terminalAssignmentIsSuspended = terminalAssignmentIsSuspended;
  }

  Terminal.fromJson(dynamic json) {
    _terminalID = json['TerminalID'];
    _terminalDataLatitudeLast = json['TerminalDataLatitudeLast'];
    _terminalDataLongitudeLast = json['TerminalDataLongitudeLast'];
    _terminalAssignmentCode = json['TerminalAssignmentCode'];
    _carrierRegistrationNumber = json['CarrierRegistrationNumber'];
    _carrierName = json['CarrierName'];
    _carrierTypeName = json['CarrierTypeName'];
    _terminalDataTimeLast = json['TerminalDataTimeLast'];
    _terminalAssignmentIsSuspended = json['TerminalAssignmentIsSuspended'];
  }
  String? _terminalID;
  String? _terminalDataLatitudeLast;
  String? _terminalDataLongitudeLast;
  String? _terminalAssignmentCode;
  String? _carrierRegistrationNumber;
  String? _carrierName;
  String? _carrierTypeName;
  String? _terminalDataTimeLast;
  String? _terminalAssignmentIsSuspended;

  String? get terminalID => _terminalID;
  String? get terminalDataLatitudeLast => _terminalDataLatitudeLast;
  String? get terminalDataLongitudeLast => _terminalDataLongitudeLast;
  String? get terminalAssignmentCode => _terminalAssignmentCode;
  String? get carrierRegistrationNumber => _carrierRegistrationNumber;
  String? get carrierName => _carrierName;
  String? get carrierTypeName => _carrierTypeName;
  String? get terminalDataTimeLast => _terminalDataTimeLast;
  String? get terminalAssignmentIsSuspended => _terminalAssignmentIsSuspended;

  bool get isSuspended {
    return _terminalAssignmentIsSuspended == "1";
  }

  bool get hasUpdateIn24Hour {
    if(_terminalDataTimeLast == null || _terminalDataTimeLast == "") return false;
    final hours = DateTime.now().difference(Jiffy(_terminalDataTimeLast).dateTime).inHours;
    return  hours <= 24;
  }

  TerminalStatus get terminalStatus {

    if(isSuspended && !hasUpdateIn24Hour) return TerminalStatus.needMaintenance;
    if(isSuspended && hasUpdateIn24Hour) return TerminalStatus.subscriptionExpired;
    return TerminalStatus.ok;
  }

  DateTime? getDateTimeLast(){
    return _terminalDataTimeLast != null && _terminalDataTimeLast != "" ? Jiffy(_terminalDataTimeLast).dateTime : null;
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
    map['TerminalDataLatitudeLast'] = _terminalDataLatitudeLast;
    map['TerminalDataLongitudeLast'] = _terminalDataLongitudeLast;
    map['TerminalAssignmentCode'] = _terminalAssignmentCode;
    map['CarrierRegistrationNumber'] = _carrierRegistrationNumber;
    map['CarrierName'] = _carrierName;
    map['CarrierTypeName'] = _carrierTypeName;
    map['TerminalDataTimeLast'] = _terminalDataTimeLast;
    map['TerminalAssignmentIsSuspended'] = _terminalAssignmentIsSuspended;
    return map;
  }

}

enum TerminalStatus {
  subscriptionExpired,
  needMaintenance,
  ok
}