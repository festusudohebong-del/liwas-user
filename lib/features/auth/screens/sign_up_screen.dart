import 'package:liwas_user/features/auth/widgets/sign_up_widget.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  final bool exitFromApp;
  const SignUpScreen({super.key, this.exitFromApp = false});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? null
          : !widget.exitFromApp
              ? AppBar(
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: const [SizedBox()],
                )
              : null),
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).cardColor,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Center(
          child: Container(
            width: context.width > 700 ? 700 : context.width,
            padding: context.width > 700
                ? const EdgeInsets.all(0)
                : const EdgeInsets.all(Dimensions.paddingSizeLarge),
            margin: context.width > 700
                ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                : null,
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  )
                : null,
            child: SingleChildScrollView(
              child: Column(children: [
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
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
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
                Text('Create Account'.tr,
                    style: ralewayBold.copyWith(
                        fontSize: Dimensions.fontSizeOverLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text('Join us to get started'.tr,
                    style: ralewayRegular.copyWith(
                        color: Theme.of(context).disabledColor)),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                const SignUpWidget(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
