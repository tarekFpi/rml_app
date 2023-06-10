import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tmv_lite/features/auth/auth_controller.dart';
import 'package:tmv_lite/features/auth/reset_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset password",
                  style: textTheme.headline6,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text("Enter your username below to reset your password.",
                    style: textTheme.bodySmall),
              ],
            ),
            Form(key: formKey,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username",
                  style: textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: usernameController,
                  validator: (val) {
                    if (val == null || val.toString().trim().isEmpty) {
                      return 'Enter valid username';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: "e.g. user1234",hintStyle: textTheme.bodySmall?.copyWith(fontSize: 15)),
                )
              ],
            )),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                onPressed: () {
                  if(formKey.currentState!.validate()){
                    FocusScope.of(context).unfocus();
                    authController.sendOtp(usernameController.text);
                  }
                },
                child: const Text('Continue'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
