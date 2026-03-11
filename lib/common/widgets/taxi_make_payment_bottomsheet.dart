import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/features/rental_module/rental_order/screens/taxi_order_details_screen.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
class TaxiMakePaymentBottomSheet extends StatelessWidget {
  final String orderId;
  const TaxiMakePaymentBottomSheet({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Image.asset(Images.taxiPay, height: 100, width: 100,),

        Text('You have reached your destination'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(
          '${'Your last trip'.tr} #$orderId ${'Has been completed'.tr}', textAlign: TextAlign.center,
          style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

        CustomButton(
          buttonText: 'Make payment'.tr,
          onPressed: () {
            Get.back();
            Get.to(()=> TaxiOrderDetailsScreen(tripId: int.parse(orderId)));
          },
        ),

      ]),
    );
  }
}
