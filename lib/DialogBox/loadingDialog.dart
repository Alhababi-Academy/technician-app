import 'package:flutter/material.dart';

import '../Widgets/loadingWidget.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String? message;
  const LoadingAlertDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          Text(message!),
        ],
      ),
    );
  }
}
