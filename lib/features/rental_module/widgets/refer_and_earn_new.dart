import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

import '../../../util/images.dart';

class ReferAndEarnCard extends StatelessWidget {
  const ReferAndEarnCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
      ),
      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text('Refer and earn'.tr, style: ralewayBold.copyWith(fontSize: 14),),
            const SizedBox(height: 5),

            Text('Invite friends and family to get'.tr, style: ralewayRegular.copyWith(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            GetBuilder<ProfileController>(
              builder: (profileController) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).disabledColor, width: 0.2),
                    )
                  ),
                  onPressed: () {
                    if(AuthHelper.isLoggedIn()) {
                      SharePlus.instance.share(
                        ShareParams(
                          text: Get.find<SplashController>().configModel?.appUrlAndroid != null ? '${AppConstants.appName} ${'Referral code'.tr}: ${profileController.userInfoModel!.refCode} \n${'Download app from this link'.tr}: ${Get.find<SplashController>().configModel?.appUrlAndroid}'
                          : '${AppConstants.appName} ${'Referral code'.tr}: ${profileController.userInfoModel!.refCode}',
                        ),
                      );
                    }else {
                      showCustomSnackBar('You are not logged in to explore feature'.tr);
                    }
                  },
                  child: Text('invite'.tr, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                );
              }
            )],
          ),
        ),

        Column(children: [
          Padding(padding: const EdgeInsets.all(8.0),
            child: Image.asset(Images.referIconNew, height: 80, width: 80,
            ),
          )],
        )],
      ),
    );
  }
}


