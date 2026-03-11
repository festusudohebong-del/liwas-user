import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/business/controllers/business_controller.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),
            SizedBox(height: context.height * 0.2),

            Image.asset(Images.checked, height: 90,width: 90),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text('Congratulations'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              'Your registration has been completed successfully'.tr,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center, softWrap: true,
            ),

          ]),
        ),
      );
    });
  }
}
