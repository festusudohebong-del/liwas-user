import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';
import 'package:liwas_user/features/auth/widgets/web_registration_stepper_widget.dart';
import 'package:liwas_user/features/business/controllers/business_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class SubscriptionSuccessOrFailedScreen extends StatefulWidget {
  final bool success;
  final bool fromSubscription;
  final int? storeId;
  const SubscriptionSuccessOrFailedScreen({super.key, required this.success, required this.fromSubscription, this.storeId});

  @override
  State<SubscriptionSuccessOrFailedScreen> createState() => _SubscriptionSuccessOrFailedScreenState();
}

class _SubscriptionSuccessOrFailedScreenState extends State<SubscriptionSuccessOrFailedScreen> {
  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: Scaffold(
        appBar: isDesktop ? CustomAppBar(title: 'Join as vendor'.tr) : null,
        endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,

        body: SingleChildScrollView(
          child: FooterView(
            child: Column(children: [

              WebScreenTitleWidget(title: 'Join as vendor'.tr),

              SizedBox(width: Dimensions.webMaxWidth, child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

                  SizedBox(height: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),

                  isDesktop ? GetBuilder<BusinessController>(
                    builder: (businessController) {
                      return const SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: RegistrationStepperWidget(status: 'complete'),
                      );
                    }
                  ) : Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeExtraOverLarge, bottom: Dimensions.paddingSizeLarge,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(
                        'Vendor registration'.tr,
                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),

                      Text(
                        widget.success ? 'Registration success'.tr : 'Transaction failed'.tr,
                        style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      LinearProgressIndicator(
                        backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                        value: widget.success ? 1 : 0.75,
                      ),

                    ]),
                  ),
                  SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraOverLarge : context.height * 0.2),

                  Container(
                    width: Dimensions.webMaxWidth,
                    padding: EdgeInsets.all(isDesktop ? 40 : 0),
                    decoration: isDesktop ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                    ) : null,
                    child: Column(children: [

                      CustomAssetImageWidget(
                        widget.success ? Images.checkGif : Images.cancelGif,
                        height: isDesktop ? 100 : 100,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: widget.success ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            '${'Congratulations'.tr}!',
                            style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            width: isDesktop ? 500 : context.width,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(style: ralewayRegular.copyWith(color: Theme.of(context).hintColor, height: 1.7), children: [
                                TextSpan(text: widget.fromSubscription ? '${'Subscription success message'.tr} ' : '${'Commission base success message'.tr} '),
                              ]),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                          TextButton(
                            onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
                            child: Text(
                              'Continue to home page'.tr,
                              style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                            ),
                          ),

                        ]) : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text(
                            '${'Transaction failed'.tr}!',
                            style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            width: isDesktop ? 500 : context.width,
                            child: Text(
                              'Sorry your transaction can not be completed please choose another payment method or try again'.tr,
                              style: ralewayRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          TextButton(
                            onPressed: () {
                              // Get.toNamed(RouteHelper.getBusinessPlanRoute(widget.storeId));
                            },
                            child: Text(
                              'Try again'.tr,
                              style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                            ),
                          ),

                        ]),
                      ),
                    ]),
                  ),

                ]),
              )),

            ]),
          ),
        ),
      ),
    );
  }
}
