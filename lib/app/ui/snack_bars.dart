import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class SnackBarUtils {
  static void showNoInternetSnackbar(
    BuildContext context,
    String message,
    Color color,
  ) =>
      showSimpleNotification(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [Text('Opps! No Internet'), Icon(Icons.warning)],
          ),
        ),
        duration: Duration(seconds: 5),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Few features may not work\nPlease turn on Internet Connection."),
        ),
        background: color,
      );
}
