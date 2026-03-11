import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class ReferBottomSheetWidget extends StatelessWidget {
  const ReferBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: isDesktop ? 450 : MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: isDesktop ? 0 : Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isDesktop ? Dimensions.radiusDefault : Dimensions.radiusExtraLarge), topRight: Radius.circular(isDesktop ? Dimensions.radiusDefault :Dimensions.radiusExtraLarge),
          bottomLeft: Radius.circular(isDesktop ? Dimensions.radiusDefault : 0), bottomRight: Radius.circular(isDesktop ? Dimensions.radiusDefault : 0),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        isDesktop ? const SizedBox() : Container(
          height: 5, width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),

        isDesktop ? Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Theme.of(context).disabledColor.withValues(alpha: 0.4), size: 25),
          ),
        ) : const SizedBox(),

        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
              child: Column(children: [

                const Padding(
                  padding: EdgeInsets.only(top: Dimensions.paddingSizeExtremeLarge, bottom: Dimensions.paddingSizeExtraLarge),
                  child: CustomAssetImageWidget(
                    Images.referBg,
                    height: 120, width: 190,
                  ),
                ),

                
                Text('${'Welcome to'.tr} ${AppConstants.appName}!', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  '${'Get ready for a special welcome gift enjoy a special discount on your first order within'.tr} ${Get.find<ProfileController>().userInfoModel!.validity} ${'Start exploring the best services around you'.tr}',
                  textAlign: TextAlign.center, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.5)),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

              ]),
            ),
          ),
        ),

      ]),

    );
  }
}
