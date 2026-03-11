import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:liwas_user/features/loyalty/widgets/loyalty_bottom_sheet_widget.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';

class LoyaltyCardWidget extends StatelessWidget {
  final JustTheController tooltipController;
  const LoyaltyCardWidget({super.key, required this.tooltipController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all( ResponsiveHelper.isDesktop(context) ? 35 : Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                Image.asset(Images.loyal , height: 60, width: 60),
                const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text(
                    '${'Convertible points'.tr} !',
                    style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),

                  Text(
                    profileController.userInfoModel!.loyaltyPoint == null ? '0' : profileController.userInfoModel!.loyaltyPoint.toString(),
                    style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),

                  ResponsiveHelper.isDesktop(context) ? Text(
                    '${'Convertible points'.tr} !',
                    style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ) : const SizedBox(),

                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ]),
              ]),
            ),

            ResponsiveHelper.isDesktop(context) ? const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),

            ResponsiveHelper.isDesktop(context) ? Text('How to use'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)) : const SizedBox(),
            ResponsiveHelper.isDesktop(context) ? const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),

            !ResponsiveHelper.isDesktop(context) ? const SizedBox() : const LoyaltyStepper(),
          ],
        );
      }
    );
  }
}



class LoyaltyStepper extends StatelessWidget {
  const LoyaltyStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2)
                    ),
                  ),

                  Expanded(
                    child: VerticalDivider(
                      thickness: 3,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.30),
                    ),
                  ),

                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2)
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Convert your loyalty point to wallet money'.tr, style: ralewayRegular),
                    Text('${'minimun'.tr} ${Get.find<SplashController>().configModel!.loyaltyPointExchangeRate} ${'Points required to convert into currency'.tr}', style: ralewayRegular),
                  ],
                ),
              ),

            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        CustomButton(
          radius: Dimensions.radiusSmall,
          isBold: true,
          buttonText: 'Convert to currency now'.tr,
          onPressed: () {
            Get.dialog(
              Dialog(backgroundColor: Colors.transparent, child: LoyaltyBottomSheetWidget(
                amount: Get.find<ProfileController>().userInfoModel!.loyaltyPoint == null
                  ? '0' : Get.find<ProfileController>().userInfoModel!.loyaltyPoint.toString(),
              )),
            );
          },
        ),
      ],
    );
  }
}

