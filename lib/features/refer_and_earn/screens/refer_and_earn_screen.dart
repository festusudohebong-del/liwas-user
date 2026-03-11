import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'package:liwas_user/common/widgets/custom_ink_well.dart';
import 'package:liwas_user/features/refer_and_earn/widgets/bottom_sheet_view_widget.dart';
import 'package:liwas_user/features/refer_and_earn/widgets/bottomsheet_for_mobile.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/not_logged_in_screen.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall(){
    if(AuthHelper.isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return SafeArea(
      child: Scaffold(
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        appBar: CustomAppBar(
          title: 'Refer and earn'.tr,
          menuWidget: Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: CustomInkWell(
              onTap: () {
                Get.bottomSheet(BottomSheetForMobile());
              },
              child: Image.asset(Images.commentInfo, height: 25),
            ),
          ),
        ),
        body: ExpandableBottomSheet(
          background: isLoggedIn ? SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                WebScreenTitleWidget(title: 'Refer and earn'.tr ),
                FooterView(
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: GetBuilder<ProfileController>(builder: (profileController) {
                        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Image.asset(
                            Images.referImage, width: 500,
                            height: ResponsiveHelper.isDesktop(context) ? 250 : 180, fit: BoxFit.contain,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, 5))],
                            ),
                            padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeLarge),
                            margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
                            child: Column(children: [
                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('Earn more by referring friends'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(
                                  '${'One referral'.tr}= ', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                ),
                                Text(
                                  PriceConverter.convertPrice(Get.find<SplashController>().configModel != null
                                      ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0),
                                  style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault), textDirection: TextDirection.ltr,
                                ),
                              ]),
                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : const SizedBox(height: 40),

                              Text('Invite friends and business'.tr , style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeOverLarge), textAlign: TextAlign.center),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              ResponsiveHelper.isDesktop(context) ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(
                                  '${'One referral'.tr}= ', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                Text(
                                  PriceConverter.convertPrice(Get.find<SplashController>().configModel != null
                                      ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0),
                                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                                ),
                              ]) : const SizedBox(),
                              ResponsiveHelper.isDesktop(context) ?  const SizedBox(height: 40) : const SizedBox(),

                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('Copy your code share it with your friends'.tr , style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              ResponsiveHelper.isDesktop(context) ? Align(
                                alignment: Alignment.topLeft,
                                child: Text('Your personal code'.tr , style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                              ) : const SizedBox(),
                              ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('Your personal code'.tr , style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  color: Colors.blueAccent,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [8, 5],
                                  padding: const EdgeInsets.all(0),
                                  radius: Radius.circular( ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 50),
                                ),
                                child: SizedBox(
                                  height: 50,
                                  child: (profileController.userInfoModel != null) ? Row(children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                                        child: Text(
                                          profileController.userInfoModel != null ? profileController.userInfoModel!.refCode ?? '' : '',
                                          style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if(profileController.userInfoModel!.refCode!.isNotEmpty){
                                          Clipboard.setData(ClipboardData(text: '${profileController.userInfoModel != null ? profileController.userInfoModel!.refCode : ''}'));
                                          showCustomSnackBar('Referral code copied'.tr, isError: false);
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular( ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 50)),
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        child: Text('Copy'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault)),
                                      ),
                                    ),
                                  ]) : const CircularProgressIndicator(),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              Text('Or share'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              Wrap(children: [

                                InkWell(
                                  onTap: () {
                                    SharePlus.instance.share(
                                      ShareParams(
                                        text: Get.find<SplashController>().configModel?.appUrlAndroid != null ? '${AppConstants.appName} ${'Referral code'.tr}: ${profileController.userInfoModel!.refCode} \n${'Download app from this link'.tr}: ${Get.find<SplashController>().configModel?.appUrlAndroid}'
                                            : '${AppConstants.appName} ${'Referral code'.tr}: ${profileController.userInfoModel!.refCode}',
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), blurRadius: 5)],
                                    ),
                                    padding: const EdgeInsets.all(7),
                                    child: const Icon(Icons.share),
                                  ),
                                )
                              ]),
                            ]),
                          ),

                          ResponsiveHelper.isDesktop(context) ? const Padding(
                            padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                            child: BottomSheetViewWidget(),
                          ) : const SizedBox(),

                        ]);
                      }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ) : NotLoggedInScreen(callBack: (value){
            _initCall();
            setState(() {});
          }),
          key: key,
          expandableContent: const SizedBox(),
        ),
      ),
    );
  }
}
