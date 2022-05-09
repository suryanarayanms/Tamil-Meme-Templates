import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Snackbar {
  showFlushbar({required BuildContext context, required String message}) {
    double deviceWidth = MediaQuery.of(context).size.width;
    Flushbar(
      messageText: Center(
          child: Text(message, style: const TextStyle(color: Colors.white))),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 2),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      backgroundColor: Colors.black45,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur: 18,
      margin: EdgeInsets.only(
          bottom: 20, left: deviceWidth / 6, right: deviceWidth / 6),
      borderRadius: BorderRadius.circular(15),
    ).show(context);
  }
}
