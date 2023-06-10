import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tmv_lite/core/network/dio_client.dart';
import 'package:tmv_lite/features/terminal/model/terminal.dart';
import 'package:tmv_lite/features/terminal/dto/terminal_response.dart';

class HomeController extends GetxController with StateMixin<List<Terminal>> {
  final dioClient = DioClient.instance;
  final List<Terminal> terminals = <Terminal>[].obs;
  final RxInt listLength = 0.obs;
  final storage = GetStorage();
  final columns = [
    "TerminalID",
    "TerminalDataLatitudeLast",
    "TerminalDataLongitudeLast",
    "TerminalAssignmentCode",
    "CarrierRegistrationNumber",
    "CarrierName",
    "CarrierTypeName",
    "TerminalDataTimeLast",
    "TerminalAssignmentIsSuspended"
  ];

  ToastFuture? toastFuture;
  Timer? timer;
  int escapedTimeInSec = 0;
  int toastTrigger = 20;
  CancelToken? cancelToken;

  void startTimer(){
    stopTimer();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t){
      escapedTimeInSec += 1;
      if(escapedTimeInSec > toastTrigger){
        //show toast that take long time
        stopTimer();
        displayToast();
      }
    });
  }

  void stopTimer(){
    if(timer != null) {
      timer!.cancel();
      escapedTimeInSec = 0;
    }
  }

  void displayToast(){
    toastFuture = showToast('Please wait a moment. Processing your request',
        position: ToastPosition.center, backgroundColor: Colors.white, textStyle: const TextStyle(
            color: Colors.black
        ), dismissOtherToast: true, duration: const Duration(minutes: 1), textPadding: const EdgeInsets.symmetric(vertical: 8));
  }

  void dismissToast(){
    if(toastFuture != null){
      if(!toastFuture!.dismissed){
        toastFuture?.dismiss();
      }
    }
  }

  void cancelRequest(){
    if(cancelToken != null){
      if(!cancelToken!.isCancelled){
        cancelToken!.cancel();
      }
    }
  }

  void clear() {
    stopTimer();
    dismissToast();
    cancelRequest();
    super.onClose();
  }

  void filterTerminals(String? query) async {
    if(terminals.isEmpty) return;
    if (query == null ||
        query.isEmpty ||
        query.toLowerCase().trim() == "r" ||
        query.toLowerCase().trim() == "rm" ||
        query.toLowerCase().trim() == "rml") {
      listLength(terminals.length);
      change(terminals, status: RxStatus.success());
    } else {

      try {
        final modifiedQuery = query.replaceAll("rml", "").replaceAll("RML", "");
        final list = terminals
            .where((element) =>
                element.terminalID!
                    .toLowerCase()
                    .contains(modifiedQuery.toLowerCase().trim()) ||
                element.terminalAssignmentCode!
                    .toLowerCase()
                    .contains(modifiedQuery.toLowerCase().trim()) ||
                element.carrierRegistrationNumber!
                    .toLowerCase()
                    .contains(modifiedQuery.toLowerCase().trim()))
            .toList();

        listLength(list.length);

        if (list.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(list, status: RxStatus.success());
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> getTerminalList() async {
    try {
      change(null, status: RxStatus.loading());

      //start timer to track loading time
      startTimer();

      //clear list length
      terminals.clear();
      listLength(0);

      var stringColumns = columns.toString().replaceAll('[', '').replaceAll(']', '');

      var formData = dio.FormData.fromMap(
          {"_Script": "API/V1/Terminal/List", "Column": stringColumns});

      //cancel token for request cancel
      cancelToken = CancelToken();

      final res = await dioClient.post("/",
          data: formData,
          options: Options(
            headers: {"Cookie": storage.read("user_cookie")},
          ), cancelToken: cancelToken);
      final vehicleResponse = TerminalResponse.fromJson(res.data);
      if (vehicleResponse.error?.code != 0) {
        change(null,
            status: RxStatus.error(vehicleResponse.error?.description));
      }else{
        final list = vehicleResponse.response?.terminal ?? [];

        //set vehicle list
        //sort by date
        final sortedByDateList = await sortByDate(list);
        //final filterBySuspend = sortedByDateList.where((element) => element.isSuspended()).toList();

        terminals.addAll(sortedByDateList);
        listLength(sortedByDateList.length);

        if (sortedByDateList.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(sortedByDateList, status: RxStatus.success());
        }
      }

    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error(e.toString()));
    }

    dismissToast();
    stopTimer();
  }


  static List<Terminal> sort(List<Terminal> list) {
    list.sort((a, b) {
      if (a.getDateTimeLast() == null && b.getDateTimeLast() == null) {
        return 0;
      } else if (a.getDateTimeLast() == null) {
        return 1;
      } else if (b.getDateTimeLast() == null) {
        return -1;
      } else {
        return b
            .getDateTimeLast()!
            .millisecondsSinceEpoch
            .compareTo(a.getDateTimeLast()!.millisecondsSinceEpoch);
      }
    });
    return list;
  }

  Future<List<Terminal>> sortByDate(List<Terminal> list) async {

    final result = await compute(sort, list);

    return result;
  }
}
