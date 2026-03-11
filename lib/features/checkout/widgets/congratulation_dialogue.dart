import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/controllers/theme_controller.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
class CongratulationDialogue extends StatelessWidget {
  const CongratulationDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(Get.find<ThemeController>().darkTheme ? Images.congratulationDark : Images.congratulationLight, width: 100, height: 100),

                Text('Congratulations'.tr , style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(
                    '${'You will earn'.tr} ${Get.find<AuthController>().getEarningPint()} ${'Points after completing this order'.tr}',
                    style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                CustomButton(
                  buttonText: 'Visit loyalty points'.tr,
                  onPressed: (){
                    Get.find<AuthController>().saveEarningPoint('');
                    Get.back();
                    Get.toNamed(RouteHelper.getLoyaltyRoute());
                  },
                )
              ]),
            ),

            Positioned(
              top: 5, right: 5,
                child: InkWell(
                  onTap: (){
                    Get.find<AuthController>().saveEarningPoint('');
                    Get.back();
                  },
                    child: const Icon(Icons.clear, size: 18),
                ),
            )
          ],
        ),
      ),
    );
  }
}
