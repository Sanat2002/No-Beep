import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  void launchTelegramGroup() async {
    final Uri uri = Uri.file('https://t.me/+iCMWKqYCZVU0NjU9');
    await launchUrl(uri);
  }

  void launchMail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'cparktools@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Some sugesstions regarding NoBeep.',
      }),
    );

    launchUrl(emailLaunchUri);
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
