import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/features/wallet/widgets/add_fund_dialogue_widget.dart';

class WalletCardWidget extends StatelessWidget {
  final JustTheController tooltipController;
  const WalletCardWidget({super.key, required this.tooltipController});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    final ScrollController cardScrollController = ScrollController();

    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDesktop ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),

            Stack(children: [
              Container(
                padding: EdgeInsets.all( isDesktop ? 35 : Dimensions.paddingSizeExtraLarge),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text('Wallet amount'.tr,style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [
                    Text(
                      PriceConverter.convertPrice(profileController.userInfoModel!.walletBalance), textDirection: TextDirection.ltr,
                      style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Get.find<SplashController>().configModel!.addFundStatus! && Get.find<SplashController>().configModel!.digitalPayment! ? JustTheTooltip(
                      backgroundColor: Colors.black87,
                      controller: tooltipController,
                      preferredDirection: AxisDirection.right,
                      tailLength: 14,
                      tailBaseWidth: 20,
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'If you want to add fund to your wallet then click add fund button'.tr,
                          style: ralewayRegular.copyWith(color: Colors.white),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => tooltipController.showTooltip(),
                        child: Icon(Icons.info_outline, color: Theme.of(context).cardColor),
                      ),
                    ) : const SizedBox(),
                  ]),
                ]),
              ),

              Get.find<SplashController>().configModel!.addFundStatus! && Get.find<SplashController>().configModel!.digitalPayment! ? Positioned(
                top: 30, right: Get.find<LocalizationController>().isLtr ? 20 : null,
                left: Get.find<LocalizationController>().isLtr ? null : 10,
                child: InkWell(
                  onTap: () {
                    Get.dialog(
                      Dialog(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, child: SizedBox(
                        width: 500, child: SingleChildScrollView(controller: cardScrollController, child: AddFundDialogueWidget(cardScrollController: cardScrollController)),
                      )),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: const Icon(Icons.add),
                  ),
                ),
              ) : const SizedBox(),

            ]),
            isDesktop ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),
            isDesktop ? const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),

            isDesktop ? Text('How to use'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)) : const SizedBox(),
            isDesktop ? const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),

            !isDesktop ? const SizedBox() : const WalletStepper(),
          ],
        );
      }
    );
  }
}

class WalletStepper extends StatelessWidget {
  const WalletStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
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
                Text('Earn money to your wallet by completing the offer challenged'.tr, style: ralewayRegular),
                Text('Convert your loyalty points into wallet money'.tr, style: ralewayRegular),
                Text('Amin also reward their top customers with wallet money'.tr, style: ralewayRegular),
                Text('Send your wallet money while order'.tr, style: ralewayRegular),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

