import 'package:tmv_lite/features/route_analysis/model/event.dart';
import 'package:tmv_lite/features/route_analysis/model/geo_location.dart';
import 'package:tmv_lite/features/route_analysis/model/motion_state.dart';
import 'package:tmv_lite/features/route_analysis/model/terminal_state.dart';
import 'package:tmv_lite/features/terminal/model/terminal.dart';
import 'package:tmv_lite/core/model/error.dart';

class RouteAnalysisResponse {
  RouteAnalysisResponse({
      Error? error, 
      Response? response,}){
    _error = error;
    _response = response;
}

  RouteAnalysisResponse.fromJson(dynamic json) {
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
      List<MotionState>? motionState, 
      List<TerminalState>? data,
      List<GeoLocation>? geoLocation, 
      List<Terminal>? terminal, 
      List<Event>? event,}){
    _motionState = motionState;
    _data = data;
    _geoLocation = geoLocation;
    _terminal = terminal;
    _event = event;
}

  Response.fromJson(dynamic json) {
    if (json['MotionState'] != null) {
      _motionState = [];
      json['MotionState'].forEach((v) {
        _motionState?.add(MotionState.fromJson(v));
      });
    }
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(TerminalState.fromJson(v));
      });
    }
    if (json['GeoLocation'] != null) {
      _geoLocation = [];
      json['GeoLocation'].forEach((v) {
        _geoLocation?.add(GeoLocation.fromJson(v));
      });
    }
    if (json['Terminal'] != null) {
      _terminal = [];
      json['Terminal'].forEach((v) {
        _terminal?.add(Terminal.fromJson(v));
      });
    }
    if (json['Event'] != null) {
      _event = [];
      json['Event'].forEach((v) {
        _event?.add(Event.fromJson(v));
      });
    }
  }
  List<MotionState>? _motionState;
  List<TerminalState>? _data;
  List<GeoLocation>? _geoLocation;
  List<Terminal>? _terminal;
  List<Event>? _event;

  List<MotionState>? get motionState => _motionState;
  List<TerminalState>? get data => _data;
  List<GeoLocation>? get geoLocation => _geoLocation;
  List<Terminal>? get terminal => _terminal;
  List<Event>? get event => _event;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_motionState != null) {
      map['MotionState'] = _motionState?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_geoLocation != null) {
      map['GeoLocation'] = _geoLocation?.map((v) => v.toJson()).toList();
    }
    if (_terminal != null) {
      map['Terminal'] = _terminal?.map((v) => v.toJson()).toList();
    }
    if (_event != null) {
      map['Event'] = _event?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}