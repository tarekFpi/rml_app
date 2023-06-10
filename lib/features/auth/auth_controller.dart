import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tmv_lite/core/network/dio_client.dart';
import 'package:tmv_lite/features/auth/login_screen.dart';
import 'package:tmv_lite/features/auth/model/login_response.dart';
import 'package:tmv_lite/features/auth/reset_password_screen.dart';
import 'package:tmv_lite/features/nav/home/home_controller.dart';
import 'package:tmv_lite/features/nav/profile/profile_controller.dart';
import 'package:tmv_lite/utils/hexcolor.dart';
import 'package:tmv_lite/utils/toast.dart';

class AuthController extends GetxController {


  final dioClient = DioClient.instance;
  final storage = GetStorage();


  void resetPassword(String password, String otp, String token, String username) async {

    EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.custom);

    try{

      var formData = Dio.FormData.fromMap({
        "_Script": "API/V1/User/Password_Reset_Set",
        "OTPCode": otp,
        "UserPassword": password,
        "UserSignInName": username,
        "UserEmail": username,
        "OTPToken": token,
      });

      final res = await dioClient.post("/", data: formData);
      if(res.data["Error"]["Code"] != 0){
        Toast.errorToast("${res.data["Error"]["Description"]}", "Error Occur");
      }else{
        Toast.successToast("Password has been changed", "Success");
        Get.offAll(() => const LoginScreen());
      }

    }catch(e){
      Toast.errorToast(e.toString(), "Error Occur");
      debugPrint(e.toString());
    }

    EasyLoading.dismiss();
  }

  void sendOtp(String username) async {
    EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.custom);

    try{

      var formData = Dio.FormData.fromMap({
        "_Script": "API/V1/User/Password_Reset_Initiate",
        "UserSignInName": username,
        "UserEmail": username,
      });

      final res = await dioClient.post("/", data: formData);
      if(res.data["Error"]["Code"] != 0){
        Toast.errorToast("${res.data["Error"]["Description"]}", "Error Occur");
      }else{
        Toast.successToast("OTP has been sent", "Success");
        final token = res.data["Response"]["OTP"]["Token"];

        Get.to(()=> ResetPasswordScreen(username: username, token: token,));

      }

    }catch(e){
      Toast.errorToast(e.toString(), "Error Occur");
      debugPrint(e.toString());
    }

    EasyLoading.dismiss();
  }


  Future<bool> login(username, password) async {
    EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.custom);
    try {
      var formData = Dio.FormData.fromMap({
        "_Script": "API/V1/User/SignIn",
        "UserSignInName": username,
        "UserEmail": username,
        "UserPassword": password
      });

      final res = await dioClient.post("/", data: formData);
      final loginResponse = LoginResponse.fromJson(res.data);
      if(loginResponse.error?.code != 0){
        Toast.errorToast("${loginResponse.error?.description}", "Error Occur");

        EasyLoading.dismiss();
        return false;
      }else{
        final cookie = res.headers["Set-Cookie"].toString().split(";").first.replaceAll("[", "");
        final user = res.data["Response"]["User"];

        //save cookie to local storage

        storage.remove("user_cookie");
        storage.remove("user_info");

        saveCookie(cookie);
        saveUser(user);

        EasyLoading.dismiss();
        return true;
      }

    } catch (e) {
      debugPrint(e.toString());
      Toast.errorToast(e.toString(), "Error occur");
      EasyLoading.dismiss();
      return false;
    }
  }

  void logoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Yes', style: TextStyle(
              color: HexColor("#FF6464")
            ),),
            onPressed: () => logout(context: context),
          ),
        ],
      ),
    );
  }

  void logout({BuildContext? context}) async {
    if(context != null) Navigator.of(context).pop();
    try {
      storage.remove("user_cookie");
      storage.remove("user_info");
    } catch (e) {
      storage.remove("user_cookie");
      storage.remove("user_info");
    }
    Get.delete<HomeController>();
    Get.delete<ProfileController>();
    Get.offAll(()=> const LoginScreen());
  }


  void saveCookie(cookie){
    storage.write("user_cookie", cookie);
  }
  void saveUser(user){
    storage.write("user_info", user);
  }

  bool isLoggedIn(){
    if(storage.read("user_cookie") != null) return true;
    return false;
  }
}
