import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static bool get isDebug => kDebugMode;

  static String get bannerAdUnitId {
    if (isDebug) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8499191067388588/9757524063';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8499191067388588/4775137612';
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (isDebug) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8499191067388588/3064957351';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8499191067388588/4761182401';
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
