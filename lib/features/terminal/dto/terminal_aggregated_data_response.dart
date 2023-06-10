import 'package:tmv_lite/core/model/error.dart';
import 'package:tmv_lite/features/terminal/model/terminal_data_minutely.dart';

class TerminalAggregatedDataResponse {
  TerminalAggregatedDataResponse({
      Response? response}){
    _error = error;
    _response = response;
}

  TerminalAggregatedDataResponse.fromJson(dynamic json) {
    _error = json['Error'] != null ? Error.fromJson(json['Error']) : null;
    _response = json['Response'] != null ? Response.fromJson(json['Response']) : null;
  }
  Error? _error;
  Response? _response;

  Error? get error => _error;
  Response? get response => _response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_error != null) {
      map['Error'] = _error?.toJson();
    }
    if (_response != null) {
      map['Response'] = _response?.toJson();
    }
    return map;
  }

}

class Response {
  Response({
    List<TerminalDataMinutely>? terminalDataMinutely,
    RecordCount? recordCount,}){
    _terminalDataMinutely = terminalDataMinutely;
    _recordCount = recordCount;
  }

  Response.fromJson(dynamic json) {
    if (json['TerminalDataMinutely'] != null) {
      _terminalDataMinutely = [];
      json['TerminalDataMinutely'].forEach((v) {
        _terminalDataMinutely?.add(TerminalDataMinutely.fromJson(v));
      });
    }
    _recordCount = json['RecordCount'] != null ? RecordCount.fromJson(json['RecordCount']) : null;
  }
  List<TerminalDataMinutely>? _terminalDataMinutely;
  RecordCount? _recordCount;

  List<TerminalDataMinutely>? get terminalDataMinutely => _terminalDataMinutely;
  RecordCount? get recordCount => _recordCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_terminalDataMinutely != null) {
      map['TerminalDataMinutely'] = _terminalDataMinutely?.map((v) => v.toJson()).toList();
    }
    if (_recordCount != null) {
      map['RecordCount'] = _recordCount?.toJson();
    }
    return map;
  }

}

class RecordCount {
  RecordCount({
    int? terminalDataMinutely,}){
    _terminalDataMinutely = terminalDataMinutely;
  }

  RecordCount.fromJson(dynamic json) {
    _terminalDataMinutely = json['TerminalDataMinutely'];
  }
  int? _terminalDataMinutely;

  int? get terminalDataMinutely => _terminalDataMinutely;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TerminalDataMinutely'] = _terminalDataMinutely;
    return map;
  }

}