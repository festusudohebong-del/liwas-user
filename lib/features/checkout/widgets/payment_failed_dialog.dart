import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/order/controllers/order_controller.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';

class PaymentFailedDialog extends StatelessWidget {
  final String? orderID;
  final String? orderType;
  final double? orderAmount;
  final double? maxCodOrderAmount;
  final bool? isCashOnDelivery;
  final String guestId;
  const PaymentFailedDialog({super.key, required this.orderID, required this.maxCodOrderAmount, required this.orderAmount, required this.orderType, required this.isCashOnDelivery, required this.guestId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Image.asset(Images.warning, width: 70, height: 70),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              'Are you agree with this order fail'.tr, textAlign: TextAlign.center,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(
              'If you do not pay'.tr,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<OrderController>(builder: (orderController) {
            return !orderController.isLoading ? Column(children: [
              isCashOnDelivery! ? CustomButton(
                buttonText: 'Switch to cash on delivery'.tr,
                onPressed: () {
                  if((((maxCodOrderAmount != null && orderAmount! < maxCodOrderAmount!) || maxCodOrderAmount == null || maxCodOrderAmount == 0) && orderType != 'parcel') || orderType == 'parcel'){
                    orderController.switchToCOD(orderID, guestId: guestId.isNotEmpty ? guestId : null).then((success){
                      if(success){
                        double total = ((orderAmount! / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
                        if(AuthHelper.isLoggedIn()) {
                          Get.find<AuthController>().saveEarningPoint(total.toStringAsFixed(0));
                        }
                      }
                    });
                  }else{
                    if(Get.isDialogOpen!) {
                      Get.back();
                    }
                    showCustomSnackBar('${'You cant order more then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'In cash on delivery'.tr}');
                  }
                },
                radius: Dimensions.radiusSmall, height: 40,
              ) : const SizedBox(),
              SizedBox(height: Get.find<SplashController>().configModel!.cashOnDelivery! ? Dimensions.paddingSizeLarge : 0),

              TextButton(
                onPressed: () {
                  Get.find<OrderController>().cancelOrder(orderID: int.parse(orderID!), reason: 'Digital payment issue', isParcel: false, guestId: guestId.isNotEmpty ? guestId : null).then((success) {
                    if(success){
                      Get.offAllNamed(RouteHelper.getInitialRoute());
                    }
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.3), minimumSize: const Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                ),
                child: Text('Cancel order'.tr, textAlign: TextAlign.center, style: ralewayBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
              ),
            ]) : const Center(child: CircularProgressIndicator());
          }),

        ]),
      )),
    );
  }
}
