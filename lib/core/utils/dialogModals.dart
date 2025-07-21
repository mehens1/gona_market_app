import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/button.dart';

Future<void> showErrorDialog(
    BuildContext context, String heading, String message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          heading.isEmpty ? 'Error!' : heading,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showMessageDialog(
  BuildContext context,
  String type,
  String heading,
  String message,
) {
  IconData icon = Icons.error; // default icon
  Color iconColor = Colors.red; // default color

  switch (type) {
    case "success":
      icon = Icons.check_circle;
      iconColor = Colors.green;
      break;
    case "info":
      icon = Icons.info;
      iconColor = Colors.orange;
      break;
    case "error":
      icon = Icons.error;
      iconColor = Colors.red;
      break;
    default:
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCcontext) {
      return AlertDialog(
        title: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: iconColor,
            ),
            Text(
              heading.isEmpty ? '${type.toUpperCase()}!' : heading,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          PrimaryButton(
            text: "Ok",
            onPressed: () {
              Navigator.of(dialogCcontext).pop();
            },
          ),
        ],
      );
    },
  );
}
