import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/auth/widgets/auth_dialog_widget.dart';
import 'package:liwas_user/features/profile/widgets/notification_status_change_bottom_sheet.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/common/controllers/theme_controller.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/features/verification/screens/new_pass_screen.dart';
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
import 'package:liwas_user/features/profile/widgets/profile_button_widget.dart';
import 'package:liwas_user/features/profile/widgets/profile_card_widget.dart';

class WebProfileWidget extends StatelessWidget {
  const WebProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController> (builder: (profileController) {
      bool isLoggedIn = AuthHelper.isLoggedIn();

      return SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(children : [

          SizedBox(
            height: isLoggedIn ? 243 : 190,
            child: Stack(children: [
              Container(
                height: 162,
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                    child: Text('Profile'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),
                ),
              ),

              !isLoggedIn ? Positioned(
                top: MediaQuery.of(context).padding.top + 55, left: 0, right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtremeLarge),
                  child: Row(children: [

                    ClipOval(child: CustomImage(
                      placeholder: Images.guestIcon,
                      image: '',
                      height: 70, width: 70, fit: BoxFit.cover, color: Theme.of(context).primaryColor,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'Guest user'.tr,
                          style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        InkWell(
                          onTap: () async {
                            Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false)));
                          },
                          child: Text(
                            'Login to view all feature'.tr,
                            style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    InkWell(
                      onTap: () async {
                        Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          'Login'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).cardColor),
                        ),
                      ),
                    ),

                  ]),
                ),
              ) : const SizedBox(),

              isLoggedIn ? Positioned(
                top: 96,
                left: (Dimensions.webMaxWidth/2) - 60,
                child: ClipOval(child: CustomImage(
                  placeholder: Images.guestIcon,
                  image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                  height: 120, width: 120, fit: BoxFit.cover,
                )),
              ) : const SizedBox(),

              isLoggedIn ? Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    isLoggedIn ? '${profileController.userInfoModel?.fName ?? ''} ${profileController.userInfoModel?.lName ?? ''}' : 'Guest user'.tr,
                    style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),
              ) : const SizedBox(),

              isLoggedIn ? Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      Get.dialog(ConfirmationDialog(icon: Images.support,
                        title: 'Are you sure to delete account'.tr,
                        description: 'It will remove your all information'.tr, isLogOut: true,
                        onYesPressed: () => profileController.deleteUser(),
                      ), useSafeArea: false);
                    },
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(Images.profileDelete, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text('Delete account'.tr , style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    ]),
                  ),
                ),
              ) : const SizedBox(),
            ]),
          ),
          SizedBox(height: isLoggedIn ? Dimensions.paddingSizeLarge : 0),

          isLoggedIn ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const SizedBox( width: Dimensions.paddingSizeLarge),
            Expanded(
              child: Container(
                height: ResponsiveHelper.isDesktop(context) ? 130 :112,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.1),
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), blurRadius: 5, spreadRadius: 1)],
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipOval(child: CustomImage(
                    placeholder: Images.guestIcon,
                    image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                    height: 30, width: 30, fit: BoxFit.cover,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!), textDirection: TextDirection.ltr,
                    style: ralewayMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeExtraLarge),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('Since joining'.tr, style: ralewayRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                  )),
                ]),
              ),
            ),
            const SizedBox( width: Dimensions.paddingSizeExtremeLarge),

            isLoggedIn  && Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Expanded(child: ProfileCardWidget(
              image: Images.walletProfile,
              data: PriceConverter.convertPrice(profileController.userInfoModel!.walletBalance),
              title: 'Wallet balance'.tr,
            )) : const SizedBox(),
            SizedBox(width: isLoggedIn  && Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeExtremeLarge : 0),

            isLoggedIn ? Expanded(child: ProfileCardWidget(
              image: Images.shoppingBagIcon,
              data: profileController.userInfoModel!.orderCount.toString(),
              title: 'Total order'.tr,
            )) : const SizedBox(),
            SizedBox(width: isLoggedIn && Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeExtremeLarge : 0),

            isLoggedIn  && Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Expanded(child: ProfileCardWidget(
              image: Images.loyaltyIcon,
              data: profileController.userInfoModel!.loyaltyPoint != null ? profileController.userInfoModel!.loyaltyPoint.toString() : '0',
              title: 'Loyalty points'.tr,
            )) : const SizedBox(),
            SizedBox(width: isLoggedIn && Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Dimensions.paddingSizeLarge : 0),
          ]) : const SizedBox(),
          SizedBox(height: isLoggedIn ? Dimensions.paddingSizeExtremeLarge : 0),

          !isLoggedIn ? ProfileButtonWidget(icon: Icons.tonality_outlined, title: 'Dark mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
            Get.find<ThemeController>().toggleTheme();
          }) : const SizedBox(),

          isLoggedIn ? GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 9,
            children: <Widget>[

              ProfileButtonWidget(icon: Icons.tonality_outlined, title: 'Dark mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),

              isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                return ProfileButtonWidget(
                  icon: Icons.notifications, title: 'Notification'.tr,
                  isButtonActive: authController.notification,
                  onTap: () {
                    Get.dialog(const Dialog(child: NotificationStatusChangeBottomSheet()));
                  },
                );
              }) : const SizedBox(),

              isLoggedIn && Get.find<SplashController>().configModel!.centralizeLoginSetup!.manualLoginStatus! ? ProfileButtonWidget(icon: Icons.lock, title: 'Change password'.tr, onTap: () {
                Get.dialog(const NewPassScreen(fromPasswordChange: true, fromDialog: true, resetToken: '', number: ''));
              }) : const SizedBox(),

              isLoggedIn ? ProfileButtonWidget(icon: Icons.edit, title: 'Edit profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }) : const SizedBox(),

            ],
          ) : const SizedBox(),
          const SizedBox(height: 100),

        ]),
      );
    });
  }
}
