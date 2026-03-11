import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/features/checkout/controllers/checkout_controller.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';

class PartialPayDialogWidget extends StatelessWidget {
  final bool isPartialPay;
  final double totalPrice;
  const PartialPayDialogWidget({super.key, required this.isPartialPay, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Align(alignment: Alignment.topRight, child: InkWell(
            onTap: ()=> Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.clear, size: 24),
            ),
          )),

          Image.asset(Images.note, width: 35, height: 35),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            'Note'.tr, textAlign: TextAlign.center,
            style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Text(
              isPartialPay ? 'You do not have sufficient balance to pay full amount via wallet'.tr
                  : 'You can pay the full amount with your wallet'.tr,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
            ),
          ),

          Text(
            isPartialPay ? 'Want to pay partially with wallet'.tr : 'Want to pay via wallet'.tr,
            style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor), textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Image.asset(Images.partialWallet, height: 35, width: 35),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance!),
            style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).primaryColor),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Text(
              isPartialPay ? 'Can be paid via wallet'.tr
                  : '${'Remaining wallet balance'.tr}: ${PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance! - totalPrice)}',
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Row(children: [
              Expanded(child: CustomButton(buttonText: 'No'.tr, color: Theme.of(context).disabledColor,
                onPressed: (){
                Get.find<CheckoutController>().setPaymentMethod(-1);
                if(Get.find<CheckoutController>().isPartialPay){
                  Get.find<CheckoutController>().changePartialPayment();
                }
                Get.back();
                },
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: CustomButton(buttonText: 'Yes pay'.tr, onPressed: (){
                if(isPartialPay){
                  if(!Get.find<CheckoutController>().isPartialPay){
                    Get.find<CheckoutController>().changePartialPayment();
                  }
                }else{
                  Get.find<CheckoutController>().setPaymentMethod(1);
                }
                Get.back();
              })),
            ]),
          ),
        ]),
      ),
    );
  }
}
