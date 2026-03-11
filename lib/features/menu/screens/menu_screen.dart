import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:liwas_user/common/controllers/theme_controller.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/features/auth/widgets/auth_dialog_widget.dart';
import 'package:liwas_user/features/cart/controllers/cart_controller.dart';
import 'package:liwas_user/features/home/controllers/home_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/features/favourite/controllers/favourite_controller.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/rental_module/rental_cart_screen/controllers/taxi_cart_controller.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/date_converter.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/confirmation_dialog.dart';
import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/features/menu/widgets/portion_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GetBuilder<ProfileController>(builder: (profileController) {
        final bool isLoggedIn = AuthHelper.isLoggedIn();
        final theme = Theme.of(context);

        return Column(children: [
          // Header with gradient
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.85),
                  theme.primaryColor.withOpacity(0.75),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeLarge,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeLarge,
                  Dimensions.paddingSizeExtremeLarge,
                ),
                child: Column(
                  children: [
                    // Profile row
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.9),
                                width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: CustomImage(
                              placeholder: Images.guestIconLight,
                              image:
                                  '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                              height: 64,
                              width: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isLoggedIn &&
                                      profileController.userInfoModel == null
                                  ? Shimmer(
                                      child: Container(
                                        height: 20,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      isLoggedIn
                                          ? '${profileController.userInfoModel?.fName ?? ''} ${profileController.userInfoModel?.lName ?? ''}'
                                          : 'Guest user'.tr,
                                      style: ralewayBold.copyWith(
                                        fontSize: 22,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              const SizedBox(height: 6),
                              isLoggedIn &&
                                      profileController.userInfoModel == null
                                  ? Shimmer(
                                      child: Container(
                                        height: 14,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      isLoggedIn
                                          ? '${'Joined'.tr} ${profileController.userInfoModel != null ? DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!) : ''}'
                                          : 'Enjoy your experience'.tr,
                                      style: ralewayRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.white.withOpacity(0.2),
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () =>
                                Get.find<ThemeController>().toggleTheme(),
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Get.find<ThemeController>().darkTheme
                                  ? const Icon(Icons.wb_sunny_rounded,
                                      color: Colors.white, size: 22)
                                  : Image.asset(
                                      Images.moon,
                                      height: 22,
                                      width: 22,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isLoggedIn) ...[
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(
                              Dimensions.radiusLarge),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'For more personalised and smooth experience'.tr,
                                style: ralewayRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                              child: InkWell(
                                onTap: () async {
                                  if (!ResponsiveHelper.isDesktop(context)) {
                                    await Get.toNamed(RouteHelper
                                        .getSignInRoute(Get.currentRoute));
                                    if (AuthHelper.isLoggedIn()) {
                                      profileController.getUserInfo();
                                    }
                                  } else {
                                    Get.dialog(const Center(
                                        child: AuthDialogWidget(
                                            exitFromApp: true,
                                            backFromThis: true)));
                                  }
                                },
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    'Login signup'.tr,
                                    style: ralewayBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: Dimensions.paddingSizeLarge,
                bottom: 20,
              ),
              child: Column(
                children: [
                  if (isLoggedIn && profileController.userInfoModel != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: Row(
                        children: [
                          infoCard(
                              profileController,
                              context,
                              Images.loyaltyIcon,
                              double.tryParse(profileController
                                      .userInfoModel!.loyaltyPoint
                                      .toString()) ??
                                  0,
                              'Loyalty points'.tr),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          infoCard(
                              profileController,
                              context,
                              Images.orderProfile,
                              double.tryParse(profileController
                                      .userInfoModel!.orderCount
                                      .toString()) ??
                                  0,
                              'Orders'.tr),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          infoCard(
                              profileController,
                              context,
                              Images.walletProfile,
                              double.tryParse(profileController
                                      .userInfoModel!.walletBalance
                                      .toString()) ??
                                  0,
                              'Wallet balance'.tr,
                              isAmount: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ],
              _buildMenuSection(
                context,
                'General'.tr,
                [
                  PortionWidget(
                      icon: Images.profileIcon,
                      title: 'Edit profile'.tr,
                      route: RouteHelper.getUpdateProfileRoute()),
                  PortionWidget(
                      icon: Images.addressIcon,
                      title: 'My address'.tr,
                      route: RouteHelper.getAddressRoute()),
                  PortionWidget(
                      icon: Images.settings,
                      title: 'Settings'.tr,
                      hideDivider: true,
                      route: RouteHelper.getSettingScreen()),
                ],
              ),
              _buildMenuSection(
                context,
                'Promotional activity'.tr,
                [
                  PortionWidget(
                    icon: Images.couponIcon,
                    title: 'Coupon'.tr,
                    route: RouteHelper.getCouponRoute(),
                    hideDivider: Get.find<SplashController>()
                                    .configModel!
                                    .loyaltyPointStatus ==
                                1 ||
                            Get.find<SplashController>()
                                    .configModel!
                                    .customerWalletStatus ==
                                1
                        ? false
                        : true,
                  ),
                  if (Get.find<SplashController>()
                          .configModel!
                          .loyaltyPointStatus ==
                      1)
                    PortionWidget(
                      icon: Images.pointIcon,
                      title: 'Loyalty points'.tr,
                      route: RouteHelper.getLoyaltyRoute(),
                      hideDivider: Get.find<SplashController>()
                                  .configModel!
                                  .customerWalletStatus ==
                              1
                          ? false
                          : true,
                    ),
                  if (Get.find<SplashController>()
                          .configModel!
                          .customerWalletStatus ==
                      1)
                    PortionWidget(
                      icon: Images.walletIcon,
                      title: 'My wallet'.tr,
                      hideDivider: true,
                      route: RouteHelper.getWalletRoute(),
                    ),
                ],
              ),
              if ((Get.find<SplashController>().configModel!.refEarningStatus ==
                      1) ||
                  (Get.find<SplashController>()
                          .configModel!
                          .toggleDmRegistration! &&
                      !ResponsiveHelper.isDesktop(context)) ||
                  (Get.find<SplashController>()
                          .configModel!
                          .toggleStoreRegistration! &&
                      !ResponsiveHelper.isDesktop(context)))
                _buildMenuSection(
                  context,
                  'Earnings'.tr,
                  [
                    if (Get.find<SplashController>()
                            .configModel!
                            .refEarningStatus ==
                        1)
                      PortionWidget(
                        icon: Images.referIcon,
                        title: 'Refer and earn'.tr,
                        route: RouteHelper.getReferAndEarnRoute(),
                        hideDivider: (Get.find<SplashController>()
                                    .configModel!
                                    .toggleDmRegistration! &&
                                !ResponsiveHelper.isDesktop(context)) ||
                            (Get.find<SplashController>()
                                    .configModel!
                                    .toggleStoreRegistration! &&
                                !ResponsiveHelper.isDesktop(context)),
                      ),
                    if (Get.find<SplashController>()
                            .configModel!
                            .toggleDmRegistration! &&
                        !ResponsiveHelper.isDesktop(context))
                      PortionWidget(
                        icon: Images.dmIcon,
                        title: 'Join as a delivery man'.tr,
                        route: RouteHelper.getDeliverymanRegistrationRoute(),
                        hideDivider: (Get.find<SplashController>()
                                .configModel!
                                .toggleStoreRegistration! &&
                            !ResponsiveHelper.isDesktop(context)),
                      ),
                    if (Get.find<SplashController>()
                            .configModel!
                            .toggleStoreRegistration! &&
                        !ResponsiveHelper.isDesktop(context))
                      PortionWidget(
                        icon: Images.storeIcon,
                        title: 'Open vendor'.tr,
                        hideDivider: true,
                        route: RouteHelper.getRestaurantRegistrationRoute(),
                      ),
                  ],
                ),
              _buildMenuSection(
                context,
                'Help and support'.tr,
                [
                  PortionWidget(
                      icon: Images.chatIcon,
                      title: 'Live chat'.tr,
                      route: RouteHelper.getConversationRoute()),
                  PortionWidget(
                      icon: Images.helpIcon,
                      title: 'Help and support'.tr,
                      route: RouteHelper.getSupportRoute()),
                  PortionWidget(
                      icon: Images.aboutIcon,
                      title: 'About us'.tr,
                      route: RouteHelper.getHtmlRoute('about-us')),
                  PortionWidget(
                      icon: Images.termsIcon,
                      title: 'Terms conditions'.tr,
                      route: RouteHelper.getHtmlRoute('terms-and-condition')),
                  PortionWidget(
                      icon: Images.privacyIcon,
                      title: 'Privacy policy'.tr,
                      route: RouteHelper.getHtmlRoute('privacy-policy')),
                  if (Get.find<SplashController>()
                          .configModel!
                          .refundPolicyStatus ==
                      1)
                    PortionWidget(
                      icon: Images.refundIcon,
                      title: 'Refund policy'.tr,
                      route: RouteHelper.getHtmlRoute('refund-policy'),
                      hideDivider: (Get.find<SplashController>()
                                  .configModel!
                                  .cancellationPolicyStatus ==
                              1) ||
                          (Get.find<SplashController>()
                                  .configModel!
                                  .shippingPolicyStatus ==
                              1),
                    ),
                  if (Get.find<SplashController>()
                          .configModel!
                          .cancellationPolicyStatus ==
                      1)
                    PortionWidget(
                      icon: Images.cancelationIcon,
                      title: 'Cancellation policy'.tr,
                      route: RouteHelper.getHtmlRoute('cancellation-policy'),
                      hideDivider: (Get.find<SplashController>()
                              .configModel!
                              .shippingPolicyStatus ==
                          1),
                    ),
                  if (Get.find<SplashController>()
                          .configModel!
                          .shippingPolicyStatus ==
                      1)
                    PortionWidget(
                      icon: Images.shippingIcon,
                      title: 'Shipping policy'.tr,
                      hideDivider: true,
                      route: RouteHelper.getHtmlRoute('shipping-policy'),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault,
                ),
                child: Material(
                  color: isLoggedIn
                      ? Theme.of(context).colorScheme.error.withOpacity(0.08)
                      : theme.primaryColor.withOpacity(0.08),
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusLarge),
                  child: InkWell(
                    onTap: () async {
                      if (isLoggedIn) {
                        Get.dialog(
                            ConfirmationDialog(
                                icon: Images.support,
                                description: 'Are you sure to logout'.tr,
                                isLogOut: true,
                                onYesPressed: () async {
                                  Get.find<AuthController>().resetOtpView();
                                  Get.find<ProfileController>().clearUserInfo();
                                  Get.find<AuthController>().socialLogout();
                                  Get.find<CartController>()
                                      .clearCartList(canRemoveOnline: false);
                                  Get.find<FavouriteController>()
                                      .removeFavourite();
                                  await Get.find<AuthController>()
                                      .clearSharedData();
                                  Get.find<HomeController>()
                                      .forcefullyNullCashBackOffers();
                                  if (Get.find<SplashController>().module !=
                                      null) {
                                    Get.find<TaxiCartController>()
                                        .getCarCartList();
                                  }
                                  Get.back();
                                  showCustomSnackBar('Logout successful'.tr,
                                      isError: false);
                                }),
                            useSafeArea: false);
                      } else {
                        Get.find<FavouriteController>().removeFavourite();
                        await Get.toNamed(
                            RouteHelper.getSignInRoute(Get.currentRoute));
                        if (AuthHelper.isLoggedIn()) {
                          await Get.find<FavouriteController>()
                              .getFavouriteList();
                          profileController.getUserInfo();
                        }
                      }
                    },
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusLarge),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault + 4,
                        horizontal: Dimensions.paddingSizeLarge,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isLoggedIn
                                ? Icons.logout_rounded
                                : Icons.login_rounded,
                            size: 22,
                            color: isLoggedIn
                                ? Theme.of(context).colorScheme.error
                                : theme.primaryColor,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Text(
                            isLoggedIn ? 'Logout'.tr : 'Sign in'.tr,
                            style: ralewayBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: isLoggedIn
                                  ? Theme.of(context).colorScheme.error
                                  : theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ]),
          )),
        ]);
      }),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, String title, List<Widget> items) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeExtraSmall,
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                title.toUpperCase(),
                style: ralewayBold.copyWith(
                  fontSize: 11,
                  color: theme.disabledColor.withOpacity(0.7),
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : theme.shadowColor)
                    .withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: isDark ? 8 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget infoCard(ProfileController profileController, BuildContext context,
      String image, double value, String title,
      {bool isAmount = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : theme.shadowColor)
                  .withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: isDark ? 8 : 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeDefault + 4,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                image,
                height: 22,
                width: 22,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              isAmount
                  ? PriceConverter.convertPrice(value, forMenuWallet: true)
                  : value.toStringAsFixed(0),
              style: ralewayBold.copyWith(
                fontSize: 17,
                color: theme.primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: ralewayMedium.copyWith(
                fontSize: 10,
                color: theme.disabledColor.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
