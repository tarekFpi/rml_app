import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tmv_lite/core/network/dio_client.dart';
import 'package:tmv_lite/features/auth/auth_controller.dart';
import 'package:tmv_lite/features/terminal/dto/terminal_aggregated_data_response.dart';
import 'package:tmv_lite/features/terminal/model/terminal_data_minutely.dart';
import 'package:tmv_lite/features/terminal/model/terminal_details.dart';
import 'package:tmv_lite/service/location_service.dart';
import 'package:tmv_lite/utils/hexcolor.dart';
import 'package:tmv_lite/utils/resource_ui_state.dart';
import 'package:tmv_lite/widgets/custom_error_widget.dart';
import 'package:tmv_lite/widgets/custom_info_window_loading_widget.dart';

class TerminalDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  AuthController authController = Get.find<AuthController>();
  GlobalKey<ExpandableBottomSheetState> bottomSheetKey = GlobalKey();
  String terminalId = Get.arguments["terminalId"];
  DioClient dioClient = DioClient.instance;
  CancelToken trackingCancelToken = CancelToken();
  CancelToken travelCancelToken = CancelToken();
  GetStorage storage = GetStorage();
  Completer<GoogleMapController> mapController = Completer();
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  late BitmapDescriptor terminalMarker;
  late BitmapDescriptor stepMarker;
  late BitmapDescriptor startPointMarker;
  LatLng? _lastLatLng;
  Timer? _timer;
  LatLng? _lastStepLatLng;
  bool isShowInfoWindow = false;

  final List<Marker> markers = <Marker>[].obs;
  final List<Polyline> polylines = <Polyline>[].obs;
  final List<LatLng> latLngList = <LatLng>[].obs;

  Tween<double> tween = Tween(begin: 0, end: 1);
  Animation<double>? animation;

  final _terminalTrackingState = Rx<ResourceUiState>(ResourceUiState());
  final _currentLocationState = Rx<ResourceUiState>(ResourceUiState());
  final _todayTravelState = Rx<ResourceUiState>(ResourceUiState());

  Status get terminalTrackingState {
    return _terminalTrackingState.value.state;
  }

  Status get currentLocationState {
    return _currentLocationState.value.state;
  }

  Status get todayTravelState {
    return _todayTravelState.value.state;
  }

  final _terminalDetails = Rxn<TerminalDetails>();
  final _terminalDataMinutely = Rxn<TerminalDataMinutely>();

  TerminalDetails? get terminalDetails {
    return _terminalDetails.value;
  }

  TerminalDataMinutely? get terminalDataMinutely {
    return _terminalDataMinutely.value;
  }

  @override
  void onInit() {
    bottomSheetKey.currentState?.expand();
    super.onInit();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    trackingCancelToken.cancel();
    travelCancelToken.cancel();
    customInfoWindowController.dispose();

    super.onClose();
  }

  void getTravelData() async {
    try {
      if (todayTravelState == Status.LOADING) return;
      _todayTravelState(ResourceUiState.loading());

      //we need to send start dateTime and end dateTime to get today total distance traveled
      var today = Jiffy().format("yyyy-MM-dd");

      var formData = dio.FormData.fromMap({
        "_Script": "API/V1/TerminalDataMinutely/Aggregate",
        "TerminalDataMinutelyTimeFrom": "$today 00:00:00",
        "TerminalDataMinutelyTimeTo": "$today 23:59:59",
        "TerminalID": terminalId,
      });
      final res = await dioClient.post("/",
          data: formData,
          options: Options(
            headers: {"Cookie": storage.read("user_cookie")},
          ));
      final terminalAggregatedRes =
          TerminalAggregatedDataResponse.fromJson(res.data);
      final list = terminalAggregatedRes.response?.terminalDataMinutely ?? [];
      if (list.isNotEmpty) {
        _terminalDataMinutely(list[0]);
        _todayTravelState(ResourceUiState.success());
      } else {
        _todayTravelState(ResourceUiState.error("---"));
      }
    } catch (e) {
      _todayTravelState(ResourceUiState.error(e.toString()));
    }
  }

  void getCurrentLocation() async {
    try {
      if (currentLocationState == Status.LOADING) return;
      _currentLocationState(ResourceUiState.loading());

      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      //move camera
      moveCamera(latLng);

      //check if marker exist or new marker
      final index = markers
          .indexWhere((marker) => marker.markerId == const MarkerId("Home"));
      if (index >= 0) {
        markers[index] =
            Marker(markerId: const MarkerId("Home"), position: latLng);
      } else {
        markers.add(Marker(markerId: const MarkerId("Home"), position: latLng));
      }
      _currentLocationState(ResourceUiState.success());
    } catch (e) {
      _currentLocationState(ResourceUiState.error(e.toString()));
    }
  }

  void generateMarker(String? lat, String? lng) async {
    try {
      terminalMarker = await LocationService.generateMarkerFromAsset(
          'assets/images/car_marker.png');
      stepMarker = await LocationService.generateMarkerFromAsset(
          'assets/images/arrow_marker.png');
      startPointMarker = await LocationService.generateMarkerFromAsset(
          'assets/images/start_point_marker.png');
      showInitialMarker(lat, lng);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loginInAgain() async {
    final username = storage.read("username");
    final password = storage.read("password");

    if (username == null || password == null) {
      authController.logout();
    } else {
      final result = await authController.login(username, password);
      if (result == true) {
        getTerminalCurrentState();
      }
    }
  }

  void showInitialMarker(String? lat, String? lng) {
    if (lat == null || lng == null) return;
    var latLng = LatLng(double.parse(lat), double.parse(lng));

    //initial move
    moveMarker(terminalId, latLng, terminalMarker, 0.0);

    //expend in initial state
    bottomSheetKey.currentState?.expand();

    //get current state
    getTerminalCurrentState();
  }

  double lastRotation = -1;

  void getTerminalCurrentState() async {
    try {
      if (terminalTrackingState == Status.LOADING) return;

      _terminalTrackingState(ResourceUiState.loading());
      var formData = dio.FormData.fromMap({
        "_Script": "API/V1/Terminal/GetForLiveLocation",
        "TerminalID": terminalId
      });
      final res = await dioClient.post("/",
          data: formData,
          cancelToken: trackingCancelToken,
          options: Options(
            headers: {"Cookie": storage.read("user_cookie")},
          ));

      //check result is not zero
      if (res.data.length != 0) {
        final terminal = TerminalDetails.fromJson(res.data[0]);

        if (_lastLatLng == null) {
          //start tracking process
          startTerminalTrackingProcess();
        }

        //calculate rotation
        var rotation = LocationService.calculateRotation(
            _lastLatLng, terminal.getLatLong());
        if (rotation != 0) lastRotation = rotation;
        rotation = rotation == 0 ? lastRotation : rotation;

        //set terminal details
        _terminalDetails(terminal);

        //check is same lat and long
        // final sameLatLng = _lastLatLng?.latitude == terminal.getLatLong().latitude && _lastLatLng?.longitude == terminal.getLatLong().longitude;

        //animate marker
        // if(_lastLatLng != null){
        //   animateMarker(_lastLatLng!, terminal.getLatLong(), rotation);
        // }else{
        //   moveMarker(terminalId, terminal.getLatLong(), terminalMarker, rotation);
        //   moveCamera(terminal.getLatLong());
        // }

        _lastLatLng = terminal.getLatLong();

        moveMarker(terminalId, terminal.getLatLong(), terminalMarker, rotation);
        drawPolyLines(terminal.getLatLong());
        drawStep(terminal.getLatLong(), rotation);
        moveCamera(terminal.getLatLong());
        if (isShowInfoWindow) {
          customInfoWindowController.hideInfoWindow!();
          showInfoWindow(terminal.getLatLong());
        }
      }

      _terminalTrackingState(ResourceUiState.success());
    } catch (e) {
      //if cookie is expired it will return Redirect
      if (e.toString() == "Redirect") {
        loginAgainDialog(Get.context!);
      }
      _terminalTrackingState(ResourceUiState.error(e.toString()));
    }
  }

  void loginAgainDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          Get.back();
          return true;
        },
        child: AlertDialog(
          content: CustomErrorWidget(
              message: "Your login session has been expired",
              onClick: () {
                Navigator.of(context).pop();
                loginInAgain();
              },
              icon: const Icon(
                FluentIcons.warning_28_filled,
                color: Colors.orangeAccent,
                size: 60,
              ),
              btnLevel: "Login")
        ),
      ),
    );
  }

  void animateMarker(LatLng fromLatLng, LatLng toLatLng, double rotation) {
    final animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    animation = tween.animate(animationController)
      ..addListener(() async {
        final v = animation!.value;
        double lng = v * toLatLng.longitude + (1 - v) * fromLatLng.longitude;
        double lat = v * toLatLng.latitude + (1 - v) * fromLatLng.latitude;
        LatLng latLng = LatLng(lat, lng);

        //move marker
        moveMarker(terminalId, latLng, terminalMarker, rotation);
        drawPolyLines(latLng);
        moveCamera(latLng);
        if (isShowInfoWindow) {
          customInfoWindowController.hideInfoWindow!();
          showInfoWindow(latLng);
        }
      });

    //Starting the animation
    animationController.forward();
  }

  void startTerminalTrackingProcess() async {
    try {
      _timer = Timer.periodic(const Duration(seconds: 20), (Timer t) {
        getTerminalCurrentState();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void drawStep(LatLng latLng, double rotation) {
    if (_lastStepLatLng == null) {
      _lastStepLatLng = latLng;
    } else {
      if (_lastStepLatLng!.latitude == latLng.latitude &&
          _lastStepLatLng!.longitude == latLng.longitude) return;

      markers.add(Marker(
          markerId: MarkerId(UniqueKey().toString()),
          position: _lastStepLatLng!,
          icon: markers.length == 1 ? startPointMarker : stepMarker,
          rotation: rotation));
      _lastStepLatLng = latLng;
    }
  }

  void navigateToMapApp() {
    LocationService.openMapApp(_lastLatLng?.latitude, _lastLatLng?.longitude);
  }

  void drawPolyLines(LatLng latLng) {
    if (_lastLatLng != null) {
      latLngList.add(latLng);
      polylines.add(Polyline(
          polylineId: PolylineId(UniqueKey().toString()),
          visible: true,
          points: latLngList,
          color: HexColor("#8a8a8a"),
          width: 4));
    }
  }

  void moveCamera(LatLng latLng) async {
    //customInfoWindowController.hideInfoWindow!();
    try {
      GoogleMapController localController = await mapController.future;
      CameraPosition cameraPosition = CameraPosition(
        target: latLng,
        zoom: 16,
      );
      localController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void moveMarker(
      String id, LatLng latLng, BitmapDescriptor icon, double rotation) {
    final index =
        markers.indexWhere((marker) => marker.markerId == MarkerId(id));
    if (index >= 0) {
      markers[index] = Marker(
          markerId: MarkerId(id),
          position: latLng,
          icon: icon,
          rotation: rotation,
          onTap: () {
            isShowInfoWindow = true;
            showInfoWindow(latLng);
          });
    } else {

      markers.add(Marker(
          markerId: MarkerId(id),
          position: latLng,
          icon: icon,
          rotation: rotation,
          onTap: () {
            isShowInfoWindow = true;
            showInfoWindow(latLng);
          }));
    }
  }

  Widget buildLabel(String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: Text(
          text,
          style: const TextStyle(fontSize: 11),
        ))
      ],
    );
  }

  void showInfoWindow(LatLng latLng) {
    customInfoWindowController.addInfoWindow!(
      Card(
        elevation: 8,
        shadowColor: Colors.black38,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            terminalDetails == null
                ? const CustomInfoWindowLoadingWidget()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildLabel("Nearby of: ",
                              "${terminalDetails?.geoLocationName}(${terminalDetails?.getLandMarkDistance().toPrecision(2)} km)"),
                          buildLabel("VRN: ",
                              "${terminalDetails?.carrierName}, ${terminalDetails?.carrierRegistrationNumber}"),
                          buildLabel("Code: ",
                              "RML ${terminalDetails?.terminalAssignmentCode}"),
                          buildLabel(
                              "Time: ",
                              Jiffy(terminalDetails?.terminalDataTimeLast)
                                  .format("MMM do yyyy, h:mm:ss a")),
                          buildLabel("Speed/Engine: ",
                              "${terminalDetails?.terminalDataVelocityLast.toString().substring(0, 4)} KM/H / ${terminalDetails?.terminalDataIsAccOnLast == "1" ? "ON" : "OFF"}"),
                          buildLabel(
                              "Last Eng. On: ",
                              Jiffy(terminalDetails?.terminalIsAccOnChangeTime)
                                  .format("MMM do yyyy, h:mm:ss a")),
                        ],
                      ),
                    ),
                  ),
            Positioned.fill(
                top: -10,
                right: -10,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        isShowInfoWindow = false;
                        customInfoWindowController.hideInfoWindow!();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                      )),
                ))
          ],
        ),
      ),
      latLng,
    );
  }
}
