import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:tmv_lite/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineService {

  static callHelpLine(String phoneNumber) async {

    if(Platform.isIOS){
      _makeCallFromIos(phoneNumber);
    }else{
      if(await Permission.phone.isGranted){
        //make call
        _makeCallFromAndroid(phoneNumber);
      }else{
        var callBack = await Permission.phone.request();
        if(callBack.isGranted){
          //make call
          _makeCallFromAndroid(phoneNumber);
        }
      }
    }

  }

  static _makeCallFromIos(String phoneNumber) async {
    try{
      Uri callUrl = Uri.parse('tel:=$phoneNumber');
      if (await canLaunchUrl(callUrl)) {
        await launchUrl(callUrl);
      } else {
        Toast.errorToast("Could not open the dialler.", "Error occur");
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  static _makeCallFromAndroid(String phoneNumber) async {
    try{
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.CALL',
        data: 'tel:$phoneNumber',
      );
      await intent.launch();
    }catch(e){
      debugPrint(e.toString());
    }
  }
}