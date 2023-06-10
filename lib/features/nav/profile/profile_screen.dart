import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmv_lite/features/auth/auth_controller.dart';
import 'package:tmv_lite/features/nav/profile/profile_controller.dart';
import 'package:tmv_lite/service/helpline_service.dart';
import 'package:tmv_lite/utils/hexcolor.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final profileController = Get.put(ProfileController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            Card(
              elevation: 2,
              shadowColor: Colors.black45,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: colorTheme.primary,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Obx(() => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorTheme.onPrimary,
                        radius: 30.0,
                        child: const CircleAvatar(
                          radius: 26.5,
                          backgroundImage:
                              AssetImage("assets/images/runner_dp.jpg"),
                        ),
                      ),
                      title: Text(
                        "${profileController.user.value?.userName}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${profileController.user.value?.userEmail}",
                        style: const TextStyle(color: Colors.white60),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey.withOpacity(0.06),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "App Version",
                      style: textTheme.bodySmall?.copyWith(fontSize: 14),
                    ),
                    trailing: Obx(() => Text("${profileController.appVersion}",
                        style: textTheme.bodySmall?.copyWith(fontSize: 14))),
                  ),
                  const Divider(
                    height: 1.3,
                  ),
                  ListTile(
                    onTap: () {
                      HelplineService.callHelpLine("+8809639595959");
                    },
                    title: Text(
                      "Call for support",
                      style: textTheme.bodySmall?.copyWith(fontSize: 14),
                    ),
                    trailing: const Icon(
                      FluentIcons.call_24_regular,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey.withOpacity(0.06),
              child: ListTile(
                onTap: () {
                  authController.logoutDialog(context);
                },
                title: Text(
                  "Logout",
                  style: TextStyle(color: HexColor("#FF6464")),
                ),
                trailing: Icon(
                  FluentIcons.sign_out_24_regular,
                  color: HexColor("#FF6464").withOpacity(0.6),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
