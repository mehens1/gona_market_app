import 'package:flutter/material.dart';

class LoadingModal {
  static void show(BuildContext context, String s,
      {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by clicking outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent closing by back button
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
