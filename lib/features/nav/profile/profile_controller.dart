import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tmv_lite/features/auth/model/user.dart';

class ProfileController extends GetxController {

  GetStorage storage = GetStorage();
  RxString appVersion = "".obs;
  Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    getAppVersion();
    getProfileData();
    super.onInit();
  }

  void getProfileData() async {
    try{
      var profile = storage.read("user_info");
      user(User.fromJson(profile));
    }catch(e){
      debugPrint(e.toString());
    }
  }

  void getAppVersion() async {
    try{

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      appVersion(version);
    }catch(e){
      debugPrint(e.toString());
    }
  }
}