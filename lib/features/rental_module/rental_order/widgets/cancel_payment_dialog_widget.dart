import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class CancelPaymentDialogWidget extends StatelessWidget {
  const CancelPaymentDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Image.asset(Images.warning, width: 70, height: 70),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                'Do you want to cancel this payment'.tr, textAlign: TextAlign.center,
                style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
              ),
            ),

            TextButton(
              onPressed: () {
                if(Get.isDialogOpen!){
                  Get.back();
                }
                Get.back();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.3), minimumSize: const Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              ),
              child: Text('Cancel payment'.tr, textAlign: TextAlign.center, style: ralewayBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
            ),
          ]),
        ),
      ),
    );
  }
}
