import 'package:flutter/material.dart';

void showBottomSheetModal(BuildContext context, String message,
    {String type = "error"}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:
        type == "error" ? Colors.redAccent[700] : Colors.green[800],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (bottomSheetContext) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type == "error" ? 'Error!' : 'Success!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(bottomSheetContext, rootNavigator: true).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor:
                      type == "error" ? Colors.red : Colors.green[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
