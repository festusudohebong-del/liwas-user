import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TrackingHelper {
  static Future<void> requestTrackingPermission() async {
    if (GetPlatform.isIOS) {
      try {
        final TrackingStatus status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          // Show the ATT dialog
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } catch (e) {
        debugPrint('Error requesting tracking permission: $e');
      }
    }
  }
}
