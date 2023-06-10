import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tmv_lite/core/network/dio_client.dart';
import 'package:tmv_lite/features/route_analysis/dto/route_analysis_response.dart';
import 'package:tmv_lite/features/route_analysis/model/terminal_state.dart';
import 'package:tmv_lite/features/terminal/model/terminal.dart';
import 'package:tmv_lite/features/terminal/ui/details/terminal_details_screen.dart';
import 'package:tmv_lite/service/location_service.dart';
import 'package:tmv_lite/utils/hexcolor.dart';
import 'package:tmv_lite/utils/resource_ui_state.dart';
import 'package:tmv_lite/utils/toast.dart';

class RouteAnalysisController extends GetxController
    with GetTickerProviderStateMixin {
  GetStorage storage = GetStorage();
  DioClient dioClient = DioClient.instance;
  CancelToken cancelToken = CancelToken();
  final terminalId = Get.arguments["terminalId"];
  final terminal = Terminal.fromJson(Get.arguments["terminal"]);

  ToastFuture? toastFuture;
  Animation<int>? animation;
  Tween<int>? tween;
  AnimationController? animationController;
  final _animState = Rx<AnimState>(AnimState.PAUSE);

  final List<Marker> markers = <Marker>[].obs;
  final List<Polyline> polylines = <Polyline>[].obs;
  final List<LatLng> latLngList = <LatLng>[].obs;
  final List<TerminalState> terminalStates = <TerminalState>[].obs;

  late BitmapDescriptor terminalMarker;
  late BitmapDescriptor routeBeginMarker;
  late BitmapDescriptor routeEndMarker;

  bool initialMapZoom = true;

  Completer<GoogleMapController> mapController = Completer();

  LatLng? lastLatLng;

  AnimState get animState {
    return _animState.value;
  }

  final _fetchDataState = Rx<ResourceUiState>(ResourceUiState());

  Status get fetchDataState {
    return _fetchDataState.value.state;
  }

  final _dateTime = Rx<DateTime>(DateTime.now());

  DateTime get dateTime {
    return _dateTime.value;
  }

  final _sliderValue = Rx<int>(0);

  int get sliderValue {
    return _sliderValue.value;
  }

  final _visibleController = Rx<bool>(false);

  bool get visibleController {
    return _visibleController.value;
  }

  void toggleControllerVisibility() {
    _visibleController(!visibleController);
    if (visibleController) {
      playRoute();
    } else {
      pauseRoute();
    }
  }

  void updateSliderValue(dynamic value) {
    final isPlaying = animationController?.isAnimating ?? false;
    if (isPlaying) pauseRoute();

    _sliderValue(value.toInt());
    setUpAnimController(value.toInt(), terminalStates.length - 1);
    if (isPlaying) playRoute();
  }

  void moveToFirst() {

    //we don't want bound zoom at initial state
    initialMapZoom = true;
    pauseRoute();
    setUpAnimController(0, terminalStates.length - 1);
    moveCameraBound();
  }

  void moveToLast() {

    //we don't want bound zoom at initial state
    initialMapZoom = true;
    pauseRoute();
    setUpAnimController(terminalStates.length - 1, terminalStates.length - 1);
    moveCameraBound();
  }

  void fastForward() {
    if (sliderValue < terminalStates.length - 1) {
      final isPlaying = animationController?.isAnimating ?? false;
      if (isPlaying) pauseRoute();

      final newValue = sliderValue + 1;
      _sliderValue(newValue);
      setUpAnimController(newValue, terminalStates.length - 1);

      if (isPlaying) playRoute();
    }
  }

  void fastBackward() {
    if (sliderValue > 0) {
      final isPlaying = animationController?.isAnimating ?? false;
      if (isPlaying) pauseRoute();

      final newValue = sliderValue - 1;
      _sliderValue(newValue);
      setUpAnimController(newValue, terminalStates.length - 1);

      if (isPlaying) playRoute();
    }
  }

  @override
  void onInit() {
    generateMarker();
    super.onInit();
  }

  @override
  void onReady() {
    openDatePicker();
    super.onReady();
  }


  void moveToTerminalDetails() async {

    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(double.parse(terminal.terminalDataLatitudeLast!),
          double.parse(terminal.terminalDataLongitudeLast!)),
      zoom: 16,
    );

    //Navigate to Terminal Details
    Get.off(
            () => TerminalDetailsScreen(
          terminal: terminal,
          initialCameraPosition: cameraPosition,
        ),
        arguments: {"terminalId": terminal.terminalID});
  }
  
  void openDatePicker() async {
    try {
      DateTime? selectedDateTime = await showDatePicker(
          context: Get.context!,
          initialDate: dateTime,
          firstDate: DateTime(1950),
          lastDate: DateTime.now());
      if (selectedDateTime != null &&
          selectedDateTime != dateTime) {
        getRouteAnalysisData(selectedDateTime);
      }else{

        //if terminal state is empty that's mean we have not got any data. we can close the analysis page :)
        if(terminalStates.isEmpty) moveToTerminalDetails();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getRouteAnalysisData(DateTime dateTime) async {

    if(fetchDataState == Status.LOADING) return;
    toastFuture = showToast('Preparing route analytics. It may take couple of minutes.',
        position: ToastPosition.top, backgroundColor: Colors.white, textStyle: const TextStyle(
          color: Colors.black
        ), dismissOtherToast: true, duration: const Duration(minutes: 1));

    _fetchDataState(ResourceUiState.loading());
    pauseRoute();
    try {
      //we need to send start date and end date to get route analysis
      var date = Jiffy(dateTime).format("yyyy-MM-dd");

      var query = {
        "_Script": "API/V2/TerminalData/List",
        "TerminalDataTimeFrom": "$date 00:00:00",
        "TerminalDataTimeTo": "$date 23:59:59",
        "TerminalID": terminalId,
        "VehicleRouteMode": 1, //initial 1
      };

      final res = await dioClient.get("/",
          queryParameters: query,
          options: Options(
            headers: {"Cookie": storage.read("user_cookie")},
          ),
          cancelToken: cancelToken);


      final routeAnalysis = RouteAnalysisResponse.fromJson(res);
      if (routeAnalysis.error?.code != 0 ||
          routeAnalysis.response?.data?.isEmpty == true ||
          routeAnalysis.response!.data!.length < 2) {

        toastFuture = showToast("Route Analytics not found",
            position: ToastPosition.top, backgroundColor: Colors.red, dismissOtherToast: true);

        if (terminalStates.isNotEmpty) {
          _fetchDataState(ResourceUiState.success());
        } else {
          _fetchDataState(
              ResourceUiState.error("${routeAnalysis.error?.description}"));
        }
      } else {

        //we don't want bound zoom at initial state
        initialMapZoom = true;

        _dateTime(dateTime);
        markers.clear();
        final list = routeAnalysis.response?.data ?? [];
        terminalStates.clear();
        terminalStates.addAll(list);

        final rotation = LocationService.calculateRotation(
            lastLatLng, terminalStates.first.getLatLng());
        moveMarker(terminalId, terminalStates.first.getLatLng(), terminalMarker,
            rotation);
        lastLatLng = terminalStates.first.getLatLng();

        setUpAnimController(0, list.length - 1);
        //reset animation

        drawBeginEndMarker();
        drawPolyLines();
        moveCameraBound();

        //checking if the page is closed or not visible
        if (isClosed) return;

        toastFuture = showToast('Route Analytics found',
            position: ToastPosition.top, backgroundColor: Colors.green, dismissOtherToast: true);
        _fetchDataState(ResourceUiState.success());
      }
    } catch (e) {
      //checking if the page is closed or not visible

      if (isClosed) return;
      toastFuture = showToast(e.toString(),
          position: ToastPosition.top, backgroundColor: Colors.red, dismissOtherToast: true);

      if (terminalStates.isNotEmpty) {
        _fetchDataState(ResourceUiState.success());
      } else {
        _fetchDataState(ResourceUiState.error(e.toString()));
      }
    }
  }

  void drawBeginEndMarker() {
    if (terminalStates.length > 2) {
      final rotation = LocationService.calculateRotation(
          terminalStates.first.getLatLng(), terminalStates[1].getLatLng());
      markers.add(Marker(
        markerId: const MarkerId("route_begin_marker"),
        position: terminalStates.first.getLatLng(),
        icon: routeBeginMarker,
        rotation: rotation,
      ));
    } else {
      markers.add(Marker(
        markerId: const MarkerId("route_begin_marker"),
        position: terminalStates.first.getLatLng(),
        icon: routeBeginMarker,
      ));
    }

    markers.add(Marker(
      markerId: const MarkerId("route_end_marker"),
      position: terminalStates.last.getLatLng(),
      icon: routeEndMarker,
    ));
  }

  void drawPolyLines() {
    final colorScheme = Theme.of(Get.context!).colorScheme;

    polylines.clear();
    latLngList.clear();
    for (var terminalState in terminalStates) {
      latLngList.add(terminalState.getLatLng());
    }
    polylines.add(Polyline(
        polylineId: PolylineId(UniqueKey().toString()),
        visible: true,
        points: latLngList,
        color: colorScheme.primary,
        width: 2));
  }

  void generateMarker() async {
    try {
      terminalMarker = await LocationService.generateMarkerFromAsset(
          'assets/images/car_marker.png');
      routeEndMarker = await LocationService.generateMarkerFromAsset(
          'assets/images/route_end_marker.png');
      routeBeginMarker = await LocationService.generateMarkerFromAsset(
          'assets/images/route_begin_marker.png');
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
          rotation: rotation);
    } else {
      markers.add(Marker(
        markerId: MarkerId(id),
        position: latLng,
        icon: icon,
        rotation: rotation,
      ));
    }
  }

  void setUpAnimController(int begin, int end) {
    final listLength = terminalStates.sublist(begin, end);

    animationController = AnimationController(
      duration: Duration(milliseconds: 200 * listLength.length),
      vsync: this,
    );

    tween = IntTween(begin: begin, end: end);

    animation = tween!.animate(animationController!)
      ..addListener(onPlayAnimation)
      ..addStatusListener(onStatusChangeListener);

    animationController?.reset();
  }

  double lastRotation = -1;

  void onPlayAnimation() async {
    final v = animation!.value;
    _sliderValue(v);
    final terminalState = terminalStates[v];
    final rotation = LocationService.calculateRotation(
        lastLatLng, terminalState.getLatLng());
    if (rotation != 0) lastRotation = rotation;

    moveMarker(terminalId, terminalState.getLatLng(), terminalMarker,
        rotation == 0 ? lastRotation : rotation);


    //we don't want bound zoom at initial state
    if(initialMapZoom == false){
      moveCamera(terminalState.getLatLng());
    }else{
      initialMapZoom = false;
    }

    lastLatLng = terminalState.getLatLng();
  }

  void moveCamera(LatLng latLng) async {
    try {
      GoogleMapController localController = await mapController.future;
      LatLngBounds bounds = await localController.getVisibleRegion();
      bounds = LocationService.reduceLatLngBoundBy(bounds, 0.5);

      if (!bounds.contains(latLng)) {
        CameraPosition cameraPosition = CameraPosition(
          target: latLng,
          zoom: 13,
        );
        localController
            .moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> latLngList) {
    assert(latLngList.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in latLngList) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void moveCameraBound() async {
    try {
      GoogleMapController localController = await mapController.future;

      localController.animateCamera(CameraUpdate.newLatLngBounds(
          boundsFromLatLngList(
              terminalStates.map((element) => element.getLatLng()).toList()),
          30));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onStatusChangeListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animState(AnimState.PAUSE);

      //reset everything when play completed
      lastLatLng = null;
    }
  }

  @override
  void onClose() {
    if(toastFuture != null){
      if(!toastFuture!.dismissed){
        toastFuture?.dismiss();
      }
    }

    animationController?.stop();
    animationController?.dispose();
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    super.onClose();
  }

  void playRoute() {
    if (terminalStates.isEmpty) return;
    _animState(AnimState.PLAY);
    if (animationController?.isCompleted == true) animationController?.reset();
    animationController?.play();
  }

  void pauseRoute() {
    if (animationController?.isAnimating == true) {
      _animState(AnimState.PAUSE);
      animationController?.stop();
    }
  }
}

enum AnimState {
  PLAY,
  PAUSE,
}
