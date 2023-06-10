import 'dart:io';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tmv_lite/features/route_analysis/ui/route_analysis_screen.dart';
import 'package:tmv_lite/features/terminal/model/terminal.dart';
import 'package:tmv_lite/features/terminal/ui/details/terminal_details_controller.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:tmv_lite/service/location_service.dart';
import 'package:tmv_lite/utils/hexcolor.dart';
import 'package:tmv_lite/utils/resource_ui_state.dart';
import 'package:jiffy/jiffy.dart';

class TerminalDetailsScreen extends StatelessWidget {
  final Terminal terminal;
  final CameraPosition initialCameraPosition;

  TerminalDetailsScreen(
      {Key? key, required this.terminal, required this.initialCameraPosition})
      : super(key: key);

  final detailsCon = Get.put(TerminalDetailsController());

  void getMyCurrentLocation(BuildContext context) async {
    try {
      final status = await LocationService.getLocationState();
      if (status == LocationStatus.PERMISSION_OK) {
        //permission is ok
        detailsCon.getCurrentLocation();
      }
      if (status == LocationStatus.SERVICE_DISABLE) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location services are disabled."),
            content: const Text(
                "Please enable the location service from app settings"),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Go to settings'),
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
      if (status == LocationStatus.PERMISSION_DENIED) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location permissions are denied"),
            content: const Text(
                "Location permissions are require to use this app. Please accept location permissions"),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  getMyCurrentLocation(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
      if (status == LocationStatus.PERMISSION_DENIED) {
        if (status == LocationStatus.PERMISSION_DENIED) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                  "Location permissions are permanently denied, we cannot request permissions"),
              content: const Text(
                  "Please accept location permission from app setting"),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Open Settings'),
                  onPressed: () {
                    Geolocator.openLocationSettings();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void moveToRouteAnalysis() {
    Get.off(
        () => RouteAnalysisScreen(
              terminal: terminal,
            ),
        arguments: {"terminalId": terminal.terminalID, "terminal": terminal.toJson()});
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: ExpandableBottomSheet(
          key: detailsCon.bottomSheetKey,
          background: Stack(
            children: <Widget>[
              Obx(() => GoogleMap(
                    markers: Set.from(detailsCon.markers),
                    polylines: Set.from(detailsCon.polylines),
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    initialCameraPosition: initialCameraPosition,
                    onCameraMove: (position) {
                      try {
                        if (detailsCon
                                .customInfoWindowController.onCameraMove !=
                            null) {
                          detailsCon.customInfoWindowController.onCameraMove!();
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    onMapCreated: (GoogleMapController c) {
                      detailsCon.mapController.complete(c);
                      detailsCon
                          .customInfoWindowController.googleMapController = c;
                      //init
                      detailsCon.generateMarker(terminal.terminalDataLatitudeLast,
                          terminal.terminalDataLongitudeLast);
                    },
                  )),
              CustomInfoWindow(
                controller: detailsCon.customInfoWindowController,
                height: 140,
                width: 280,
                offset: 30,
              ),
              Positioned.fill(
                  child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Obx(() => FloatingActionButton.small(
                        onPressed: () {
                          getMyCurrentLocation(context);
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        heroTag: UniqueKey(),
                        child: detailsCon.currentLocationState == Status.LOADING
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location,
                                color: Colors.white),
                      )),
                ),
              )),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: FloatingActionButton.small(
                        heroTag: UniqueKey(),
                        onPressed: () {
                          Get.back();
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
          persistentHeader: Obx(() => Container(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FloatingActionButton.small(
                          onPressed: () {
                            detailsCon.getTerminalCurrentState();
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          heroTag: UniqueKey(),
                          child: detailsCon.terminalTrackingState ==
                                  Status.LOADING
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        FloatingActionButton.small(
                          onPressed: () {
                            detailsCon.navigateToMapApp();
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          heroTag: UniqueKey(),
                          child:
                              const Icon(Icons.directions, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: 100,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Obx(() => Container(
                                height: 140,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        if (detailsCon.latLngList.isNotEmpty) {
                                          detailsCon.moveCamera(
                                              detailsCon.latLngList.last);
                                        }
                                      },
                                      trailing: Column(
                                        children: <Widget>[
                                          Card(
                                            elevation: 0,
                                            color: HexColor("#F5F6FC"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                moveToRouteAnalysis();
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Image.asset(
                                                  "assets/images/route.png",
                                                  width: 16,
                                                  height: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              moveToRouteAnalysis();
                                            },
                                            child: Text(
                                              "Route",
                                              style: textTheme.caption
                                                  ?.copyWith(
                                                      color:
                                                          colorScheme.primary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10),
                                            ),
                                          )
                                        ],
                                      ),
                                      leading: Image.asset(
                                        terminal.getTerminalAsset(),
                                        width: 55,
                                        height: 55,
                                      ),
                                      title: Text(
                                        "${terminal.carrierRegistrationNumber}${terminal.carrierName == null || terminal.carrierName == "" ? "" : ", ${terminal.carrierName}"}",
                                        style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "RML ${terminal.terminalAssignmentCode}",
                                            style: textTheme.bodySmall,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            detailsCon.terminalDetails ==
                                                        null &&
                                                    detailsCon
                                                            .terminalTrackingState ==
                                                        Status.LOADING
                                                ? "Loading.."
                                                : detailsCon.terminalDetails ==
                                                            null &&
                                                        detailsCon
                                                                .terminalTrackingState !=
                                                            Status.LOADING
                                                    ? "---"
                                                    : "Nearby of ${detailsCon.terminalDetails?.geoLocationName}(${detailsCon.terminalDetails?.getLandMarkDistance().toPrecision(2)} km)",
                                            style: textTheme.labelMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.2),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              detailsCon.terminalDetails ==
                                                          null &&
                                                      detailsCon
                                                              .terminalTrackingState ==
                                                          Status.LOADING
                                                  ? "Loading.."
                                                  : detailsCon.terminalDetails ==
                                                              null &&
                                                          detailsCon
                                                                  .terminalTrackingState !=
                                                              Status.LOADING
                                                      ? "---"
                                                      : "Last update ${Jiffy(detailsCon.terminalDetails?.terminalDataTimeLast).fromNow()}",
                                              style: textTheme.caption
                                                  ?.copyWith(fontSize: 11))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )),
          expandableContent: Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: Platform.isIOS ? const EdgeInsets.only(bottom: 24) : null,
              child: Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            "Travel (KM)",
                            style: textTheme.labelLarge,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          detailsCon.todayTravelState == Status.LOADING
                              ? Container(
                                  width: 42,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: LinearProgressIndicator(),
                                  ),
                                )
                              : detailsCon.todayTravelState == Status.IDEAL
                                  ? GestureDetector(
                                      onTap: detailsCon.getTravelData,
                                      child: const Icon(
                                        Icons.refresh,
                                        size: 20,
                                      ))
                                  : GestureDetector(
                                      onTap: detailsCon.getTravelData,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          detailsCon.todayTravelState ==
                                                  Status.ERROR
                                              ? const Text("---")
                                              : Text(
                                                  "${detailsCon.terminalDataMinutely?.getDistanceInKm().toPrecision(2)}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Icon(
                                            Icons.refresh,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    )
                        ],
                      )),
                      Container(
                        color: Colors.black12,
                        width: 2,
                        height: 30,
                      ),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            "Engine",
                            style: textTheme.labelLarge,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            detailsCon.terminalDetails == null
                                ? "---"
                                : detailsCon.terminalDetails
                                            ?.terminalDataIsAccOnLast ==
                                        "1"
                                    ? "ON"
                                    : "OFF",
                            style: textTheme.labelLarge?.copyWith(
                                color: detailsCon.terminalDetails == null
                                    ? null
                                    : detailsCon.terminalDetails
                                                ?.terminalDataIsAccOnLast ==
                                            "1"
                                        ? Colors.green
                                        : Colors.red),
                          )
                        ],
                      )),
                      Container(
                        color: Colors.black12,
                        width: 2,
                        height: 30,
                      ),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            "Speed",
                            style: textTheme.labelLarge,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              "${detailsCon.terminalDetails == null ? "---" : detailsCon.terminalDetails?.getSpeed().toPrecision(2)} KM/H")
                        ],
                      ))
                    ],
                  )),
            ),
          ),
        ));
  }
}
