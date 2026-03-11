import 'dart:async';
import 'dart:io';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/auth/widgets/sign_in/sign_in_view.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  final bool fromNotification;
  final bool fromResetPassword;
  const SignInScreen(
      {super.key,
      required this.exitFromApp,
      required this.backFromThis,
      this.fromNotification = false,
      this.fromResetPassword = false});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if (widget.fromNotification || widget.fromResetPassword) {
          Navigator.pushNamed(context, RouteHelper.getInitialRoute());
        } else if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Back press again to exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
          }
        } else {
          if (Get.find<AuthController>().isOtpViewEnable) {
            Get.find<AuthController>().enableOtpView(enable: false);
          } else {
            // Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: (ResponsiveHelper.isDesktop(context)
            ? null
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () {
                        if (widget.fromNotification ||
                            widget.fromResetPassword) {
                          Navigator.pushNamed(
                              context, RouteHelper.getInitialRoute());
                        } else if (Get.find<AuthController>().isOtpViewEnable) {
                          Get.find<AuthController>()
                              .enableOtpView(enable: false);
                        } else {
                          Get.back(result: false);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    elevation: 0,
                    backgroundColor: Theme.of(context).cardColor,
                    actions: const [SizedBox()],
                  )
                : null),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: context.width > 700 ? 500 : context.width,
              padding: context.width > 700
                  ? const EdgeInsets.all(50)
                  : const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge),
              margin: context.width > 700
                  ? const EdgeInsets.all(50)
                  : EdgeInsets.zero,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: ResponsiveHelper.isDesktop(context)
                          ? null
                          : const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                    )
                  : null,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.clear),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Image.asset(Images.logo, width: 90),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      Text('Welcome Back!'.tr,
                          style: ralewayBold.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text('Sign in to continue'.tr,
                          style: ralewayRegular.copyWith(
                              color: Theme.of(context).disabledColor)),
                      const SizedBox(
                          height: Dimensions.paddingSizeExtremeLarge),
                      SignInView(
                        exitFromApp: widget.exitFromApp,
                        backFromThis: widget.backFromThis,
                        fromResetPassword: widget.fromResetPassword,
                        isOtpViewEnable: (v) {},
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
