import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreRegistrationSuccessBottomSheet extends StatelessWidget {
  const StoreRegistrationSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.isDesktop(context) ? 500 : context.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius : ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(Dimensions.radiusExtraLarge) : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
          topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        ResponsiveHelper.isDesktop(context) ? const SizedBox() : Center(
          child: Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
            height: 5, width: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
          ),
        ),

        ResponsiveHelper.isDesktop(context) ? Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ) : const SizedBox(),

        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const CustomAssetImageWidget(Images.storeRegistrationSuccess),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('${'Welcome to'.tr} ${AppConstants.appName}!', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(
                'Thanks for joining us your registration is under review hang tight we ll notify you once approved'.tr,
                textAlign: TextAlign.center,
                style: ralewayRegular,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

              SafeArea(
                child: CustomButton(
                  width: 100,
                  buttonText: 'Okay'.tr,
                  isBold: false,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]),
          ),
        ),
      ]),
    );
  }
}
