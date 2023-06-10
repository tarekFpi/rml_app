import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tmv_lite/features/route_analysis/ui/route_analysis_controller.dart';
import 'package:tmv_lite/features/terminal/model/terminal.dart';
import 'package:tmv_lite/features/terminal/ui/details/terminal_details_screen.dart';
import 'package:tmv_lite/utils/hexcolor.dart';
import 'package:tmv_lite/utils/resource_ui_state.dart';
import 'package:tmv_lite/widgets/custom_route_analysis_bar_loading_widget.dart';

class RouteAnalysisScreen extends StatelessWidget {
  final Terminal terminal;

  RouteAnalysisScreen({Key? key, required this.terminal}) : super(key: key);

  final routeAnalysisCont = Get.put(RouteAnalysisController());


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (!routeAnalysisCont.visibleController) {
          routeAnalysisCont.moveToTerminalDetails();
          return true;
        } else {
          routeAnalysisCont.toggleControllerVisibility();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Stack(
          children: <Widget>[
            Obx(() => GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(23.777176, 90.399452),
                    zoom: 7,
                  ),
                  mapType: MapType.normal,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  markers: Set.from(routeAnalysisCont.markers),
                  polylines: Set.from(routeAnalysisCont.polylines),
                  onMapCreated: (GoogleMapController controller) {
                    routeAnalysisCont.mapController.complete(controller);
                  },
                )),
            Obx(() => Positioned.fill(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedOpacity(
                        opacity: routeAnalysisCont.visibleController ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${terminal.carrierRegistrationNumber}, ${terminal.carrierName}",
                                    style: textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: HexColor("#303192")),
                                  ),
                                  Text(
                                    "RML ${terminal.terminalAssignmentCode}",
                                    style: textTheme.bodySmall?.copyWith(
                                        color: HexColor("#303192")
                                            .withOpacity(0.6)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                )),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17, left: 8),
                    child: FloatingActionButton.small(
                      heroTag: UniqueKey(),
                      onPressed: () {
                        if (!routeAnalysisCont.visibleController) {
                          routeAnalysisCont.moveToTerminalDetails();

                        } else {
                          routeAnalysisCont.toggleControllerVisibility();
                        }
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  )),
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: routeAnalysisCont.visibleController
                        ? Card(
                            key: const Key("controller"),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: Platform.isIOS ?  32:16),
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.black38,
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SfSliderTheme(
                                    data: SfSliderThemeData(
                                      activeTrackHeight: 4,
                                      tooltipBackgroundColor:
                                          colorScheme.primary,
                                      thumbRadius: 8,
                                      tooltipTextStyle: const TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        SfSlider(
                                          min: 0,
                                          max: routeAnalysisCont
                                                  .terminalStates.length -
                                              1,
                                          value: routeAnalysisCont.sliderValue
                                              .toInt(),
                                          interval: 1,
                                          showTicks: false,
                                          showLabels: false,
                                          enableTooltip: true,
                                          shouldAlwaysShowTooltip: true,
                                          tooltipShape:
                                              const SfRectangularTooltipShape(),
                                          tooltipTextFormatterCallback:
                                              (dynamic actualValue,
                                                  String value) {
                                            final dateTime = routeAnalysisCont
                                                .terminalStates[
                                                    int.parse(value)]
                                                .time;
                                            return Jiffy(dateTime)
                                                .format('h:mm a');
                                          },
                                          onChanged: (dynamic value) {
                                            routeAnalysisCont
                                                .updateSliderValue(value);
                                          },
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 22),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Jiffy(routeAnalysisCont
                                                            .terminalStates
                                                            .first
                                                            .time)
                                                        .format('h:mm a'),
                                                    style: textTheme.caption,
                                                  ),
                                                  Text(
                                                      Jiffy(routeAnalysisCont
                                                              .terminalStates
                                                              .last
                                                              .time)
                                                          .format('h:mm a'),
                                                      style: textTheme.caption),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                            onPressed: () {
                                              routeAnalysisCont.moveToFirst();
                                            },
                                            icon: const Icon(
                                                Icons.skip_previous_outlined)),
                                        IconButton(
                                            onPressed: () {
                                              routeAnalysisCont.fastBackward();
                                            },
                                            icon: const Icon(
                                                Icons.fast_rewind_outlined)),
                                        routeAnalysisCont.animState ==
                                                AnimState.PAUSE
                                            ? IconButton(
                                                onPressed: () {
                                                  routeAnalysisCont.playRoute();
                                                },
                                                icon: const Icon(FluentIcons
                                                    .play_24_regular))
                                            : IconButton(
                                                onPressed: () {
                                                  routeAnalysisCont
                                                      .pauseRoute();
                                                },
                                                icon: const Icon(FluentIcons
                                                    .pause_24_regular)),
                                        IconButton(
                                            onPressed: () {
                                              routeAnalysisCont.fastForward();
                                            },
                                            icon: const Icon(
                                                Icons.fast_forward_outlined)),
                                        IconButton(
                                            onPressed: () {
                                              routeAnalysisCont.moveToLast();
                                            },
                                            icon: const Icon(
                                                Icons.skip_next_outlined))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Card(
                            key: const Key("bar"),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: Platform.isIOS ?  32:16),
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 26, horizontal: 16),
                              child: routeAnalysisCont.fetchDataState ==
                                      Status.LOADING
                                  ? const CustomRouteAnalysisBarLoadingWidget()
                                  : Row(
                                      children: <Widget>[
                                        Card(
                                          elevation: 0,
                                          color: HexColor("#F5F6FC"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              routeAnalysisCont
                                                  .openDatePicker();
                                            },
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                        "${routeAnalysisCont.dateTime.day}",
                                                        style: textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                          color: HexColor(
                                                              "#303192"),
                                                          fontSize: 15,
                                                        )),
                                                    Text(
                                                        DateFormat('MMM').format(
                                                            routeAnalysisCont
                                                                .dateTime),
                                                        style: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: HexColor(
                                                                        "#303192")
                                                                    .withOpacity(
                                                                        0.6))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Image.asset(
                                          terminal.getTerminalAsset(),
                                          width: 50,
                                          height: 50,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "${terminal.carrierRegistrationNumber}, ${terminal.carrierName}",
                                              style: textTheme.labelLarge
                                                  ?.copyWith(
                                                      color:
                                                          HexColor("#303192")),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "RML ${terminal.terminalAssignmentCode}",
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: HexColor("#303192")
                                                          .withOpacity(0.6)),
                                            )
                                          ],
                                        )),
                                        routeAnalysisCont.fetchDataState ==
                                                    Status.ERROR ||
                                                routeAnalysisCont
                                                        .fetchDataState ==
                                                    Status.IDEAL
                                            ? IconButton(
                                                onPressed: () {
                                                  routeAnalysisCont
                                                      .getRouteAnalysisData(
                                                          routeAnalysisCont
                                                              .dateTime);
                                                },
                                                icon: const Icon(Icons.refresh))
                                            : IconButton(
                                                onPressed: () {
                                                  routeAnalysisCont
                                                      .toggleControllerVisibility();
                                                },
                                                icon: const Icon(FluentIcons
                                                    .play_24_regular))
                                      ],
                                    ),
                            ),
                          ),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
