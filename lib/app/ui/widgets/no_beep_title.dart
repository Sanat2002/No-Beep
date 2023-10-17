import 'package:flutter/material.dart';

class NoBeepTitle extends StatelessWidget {
  const NoBeepTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('NOBEEP',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(letterSpacing: 6));
  }
}
