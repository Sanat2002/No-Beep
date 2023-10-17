import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoInternetDialog extends StatefulWidget {
  final Widget child;

  NoInternetDialog({required this.child});

  @override
  _NoInternetDialogState createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<NoInternetDialog> {
  var _connectivityResult;
  var _subscription;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _subscribeToConnectivityChanges();
  }

  @override
  void dispose() {
    _unsubscribeFromConnectivityChanges();
    super.dispose();
  }

  _checkInternetConnection() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    if (_connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("No internet connection"),
          content: Text("Please check your internet connection and try again."),
          actions: <Widget>[
            TextButton(
                onPressed: () => _checkInternetConnection(),
                child: Text('Retry'))
          ],
        );
      },
    );
  }

  _subscribeToConnectivityChanges() {
    _subscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        Navigator.of(context).pop();
      }
    });
  }

  _unsubscribeFromConnectivityChanges() {
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: <Widget>[
          widget.child,
        ],
      ),
    );
  }
}
