import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/semantic_version.dart';

class UpdateNotifier extends ChangeNotifier {
  // ignore: unused_field
  late final Timer _timer;
  late final SemanticVersion version;

  SemanticVersion? newerVersion;

  UpdateNotifier() {
    fetchVersionAndBuildNumber().then((result) {
      version = result;

      if (kDebugMode) {
        print('Loaded version: ${result.text}');
      }
    });

    const timerDuration =
        kDebugMode ? Duration(seconds: 10) : Duration(hours: 3);

    _timer = Timer.periodic(timerDuration, (timer) {
      if (kDebugMode) {
        print('Checking for new version...');
      }

      fetchVersionAndBuildNumber().then((result) {
        if (!kDebugMode && !result.isNewerThan(version)) {
          return;
        }

        if (kDebugMode) {
          print('New version detected: ${result.text}');
          _timer.cancel();
        }

        newerVersion = result;
        notifyListeners();
      });
    });
  }

  Future<SemanticVersion> fetchVersionAndBuildNumber() async {
    final versionUri = Uri.base.removeFragment().replace(path: '/version.json');
    final response = await Dio().getUri(versionUri);
    final data = jsonDecode(response.data) as Map<String, dynamic>;

    return SemanticVersion.from(
        data['version'] as String, data['build_number'] as String);
  }

  static UpdateNotifier? _instance;

  static UpdateNotifier get instance {
    if (_instance != null) {
      return _instance!;
    }

    _instance = UpdateNotifier();
    return _instance!;
  }
}
