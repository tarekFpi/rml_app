import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmv_lite/features/auth/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String username;
  final String token;

  const ResetPasswordScreen(
      {Key? key, required this.username, required this.token})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthController authController = AuthController();

  Timer? _timer;
  int _start = 10 * 60;
  bool obscureText = true;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 10 * 60;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  // Toggles the password show status
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create new password",
                  style: textTheme.headline6,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    "Verify your OTP and your new password must be different from the previous password.",
                    style: textTheme.bodySmall),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "OTP",
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null) {
                              return 'Enter OTP';
                            }
                            if (val.trim().isEmpty) {
                              return 'Enter OTP';
                            }

                            if (val.trim().length < 4) {
                              return 'Enter 4 digit OTP';
                            }
                            return null;
                          },
                          maxLength: 4,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              suffixIcon: Container(
                                height: 50,
                                width: 70,
                                child: Center(
                                  child: _timer?.isActive == true
                                      ? Text(formatHHMMSS(_start))
                                      : TextButton(
                                          child: const Text("Resend"),
                                          onPressed: () {
                                            startTimer();
                                          },
                                        ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "e.g. 2345",
                              hintStyle:
                                  textTheme.bodySmall?.copyWith(fontSize: 15)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "New Password",
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          obscureText: obscureText,
                          validator: (val) {
                            if (val == null) {
                              return 'Enter new password';
                            }
                            if (val.trim().isEmpty) {
                              return 'Enter new password';
                            }

                            if (val.trim().length < 6) {
                              return 'Password length must be 6 or greater';
                            }
                            return null;
                          },
                          controller: newPasswordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "e.g. @2345!klA",
                              hintStyle:
                                  textTheme.bodySmall?.copyWith(fontSize: 15), suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: togglePasswordVisibility)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Confirm Password",
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          obscureText: obscureText,
                          validator: (val) {
                            if (val == null) {
                              return 'Enter confirm password';
                            }
                            if (val.trim().isEmpty) {
                              return 'Enter confirm password';
                            }

                            if (val.trim() != newPasswordController.text) {
                              return "Confirm password doesn't match";
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "e.g. @2345!klA",
                              hintStyle:
                                  textTheme.bodySmall?.copyWith(fontSize: 15), suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: togglePasswordVisibility)),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final otp = otpController.text;
                                final password = newPasswordController.text;

                                authController.resetPassword(password, otp, widget.token, widget.username);
                              }
                            },
                            child: const Text('Reset Password'),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
