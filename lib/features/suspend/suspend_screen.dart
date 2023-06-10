import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:tmv_lite/features/terminal/model/terminal.dart';
import 'package:tmv_lite/service/helpline_service.dart';

class SuspendScreen extends StatelessWidget {
  final Terminal terminal;

  const SuspendScreen({Key? key, required this.terminal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/map_bg.png',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 8),
            child: Container(
              color: Colors.white.withOpacity(0.5),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.redAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                      child: Text(
                        terminal.terminalStatus == TerminalStatus.subscriptionExpired
                            ? "SUBSCRIPTION EXPIRED"
                            : "NEED MAINTENANCE",

                        style:
                            textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    terminal.terminalStatus == TerminalStatus.subscriptionExpired
                        ? "Renew your subscription"
                        : "Your vehicle is offline",
                    style: textTheme.titleMedium,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      terminal.terminalStatus == TerminalStatus.subscriptionExpired
                          ? "The service is temporarily paused and requires subscription renewal. For more information, please call our help center."
                          : "Your vehicle is offline and cannot show live location. For more information, please call our help center.",
                      style: textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlueAccent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        HelplineService.callHelpLine("+8809639595959");
                      },
                      child: const Text("Call Help Center")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
