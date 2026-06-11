import 'package:get/get.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/favourite/controllers/favourite_controller.dart';
import 'package:liwas_user/features/location/controllers/location_controller.dart';
import 'package:liwas_user/features/notification/domain/models/notification_body_model.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/address_helper.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/app_constants.dart';

// class SplashRouteHelper{

  void route({NotificationBodyModel? body}) {
    String? minimumVersion = _getMinimumVersion();
    int? minimumBuildNumber = _getMinimumBuildNumber();
    bool isMaintenanceMode = Get.find<SplashController>().configModel!.maintenanceMode!;
    
    bool isVersionOutdated = false;
    if (minimumVersion != null && minimumVersion.isNotEmpty && AppConstants.appVersionString.isNotEmpty) {
      isVersionOutdated = _isVersionOlder(AppConstants.appVersionString, minimumVersion);
    }
    
    bool needsUpdate = isVersionOutdated || (AppConstants.appBuildNumber < (minimumBuildNumber ?? 0));

    if(needsUpdate || isMaintenanceMode) {
      Get.offNamed(RouteHelper.getUpdateRoute(needsUpdate));
    }else if(!GetPlatform.isWeb){
      if(body != null) {
        _forNotificationRouteProcess(body);
      }else {
        _handleUserRouting();
      }
    }
  }

  String? _getMinimumVersion() {
    if (GetPlatform.isAndroid) {
      return Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
    } else if (GetPlatform.isIOS) {
      return Get.find<SplashController>().configModel!.appMinimumVersionIos;
    }
    return '';
  }

  bool _isVersionOlder(String current, String minimum) {
    List<String> cParts = current.split('.');
    List<String> mParts = minimum.split('.');
    for (int i = 0; i < cParts.length && i < mParts.length; i++) {
      int c = int.tryParse(cParts[i]) ?? 0;
      int m = int.tryParse(mParts[i]) ?? 0;
      if (c < m) return true;
      if (c > m) return false;
    }
    return cParts.length < mParts.length;
  }

  int? _getMinimumBuildNumber() {
    if (GetPlatform.isAndroid) {
      return Get.find<SplashController>().configModel!.appMinimumBuildAndroid;
    } else if (GetPlatform.isIOS) {
      return Get.find<SplashController>().configModel!.appMinimumBuildIos;
    }
    return 0;
  }

  void _forNotificationRouteProcess(NotificationBodyModel? notificationBody) {
    final notificationType = notificationBody?.notificationType;

    final Map<NotificationType, Function> notificationActions = {
      NotificationType.order: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(notificationBody!.orderId, fromNotification: true)),
      NotificationType.block: () => Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.notification)),
      NotificationType.unblock: () => Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.notification)),
      NotificationType.message: () =>  Get.toNamed(RouteHelper.getChatRoute(notificationBody: notificationBody, conversationID: notificationBody!.conversationId, fromNotification: true)),
      NotificationType.otp: () => null,
      NotificationType.add_fund: () => Get.toNamed(RouteHelper.getWalletRoute(fromNotification: true)),
      NotificationType.referral_earn: () => Get.toNamed(RouteHelper.getWalletRoute(fromNotification: true)),
      NotificationType.cashback: () => Get.toNamed(RouteHelper.getWalletRoute(fromNotification: true)),
      NotificationType.loyalty_point: () => Get.toNamed(RouteHelper.getLoyaltyRoute(fromNotification: true)),
      NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
    };

    notificationActions[notificationType]?.call();
  }

  Future<void> _forLoggedInUserRouteProcess() async {
    Get.find<AuthController>().updateToken();
    if (AddressHelper.getUserAddressFromSharedPref() != null) {
      if(Get.find<SplashController>().module != null) {
        await Get.find<FavouriteController>().getFavouriteList();
      }
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.find<LocationController>().navigateToLocationScreen('splash', offNamed: true);
    }
  }

  void _newlyRegisteredRouteProcess() {
    if(AppConstants.languages.length > 1) {
      Get.offNamed(RouteHelper.getLanguageRoute('splash'));
    }else {
      Get.offNamed(RouteHelper.getOnBoardingRoute());
    }
  }

  void _forGuestUserRouteProcess() {
    if (AddressHelper.getUserAddressFromSharedPref() != null) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.find<LocationController>().navigateToLocationScreen('splash', offNamed: true);
    }
  }

  Future<void> _handleUserRouting() async {
    if (AuthHelper.isLoggedIn()) {
      _forLoggedInUserRouteProcess();
    } else if (Get.find<SplashController>().showIntro() == true) {
      _newlyRegisteredRouteProcess();
    } else if (AuthHelper.isGuestLoggedIn()) {
      _forGuestUserRouteProcess();
    } else {
      await Get.find<AuthController>().guestLogin();
      _forGuestUserRouteProcess();
    }
  }
// }
