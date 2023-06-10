import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Toast {
  static successToast(String title, String message, {SnackPosition? snackPosition = SnackPosition.BOTTOM}) {
    Get.snackbar(title, message,
        snackPosition: snackPosition,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        colorText: Colors.white);
  }

  static errorToast(String title, String message, {SnackPosition? snackPosition = SnackPosition.BOTTOM}) {
    Get.snackbar(title, message,
        snackPosition: snackPosition,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        colorText: Colors.white);
  }

  static warningToast(String title, String message, {int? second = 3, SnackPosition? snackPosition = SnackPosition.BOTTOM}) {
    Get.snackbar(title, message,
        snackPosition: snackPosition,
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: second!),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        colorText: Colors.black);
  }
}