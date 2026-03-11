import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/features/language/widgets/language_card_widget.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class WebLanguageScreen extends StatelessWidget {
  const WebLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizationController) {
      return Column(children: [
        WebScreenTitleWidget(title: 'Language'.tr),

        Expanded(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FooterView(
            child: Center(child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

               Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                   color: Theme.of(context).cardColor,
                   boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                 ),
                 padding: const EdgeInsets.all(Dimensions.paddingSizeExtraOverLarge),
                 margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge, top: Dimensions.paddingSizeExtraLarge),
                 child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                   Expanded(
                     child: Container(
                       height: 400,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                         color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                       ),
                       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                       child: const CustomAssetImageWidget(
                         Images.languageBackground, fit: BoxFit.contain,
                       ),
                     ),
                   ),
                   const SizedBox(width: 70),

                   Expanded(child: Padding(
                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                     child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                       Text('Choose your language'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                       Text('Choose your language to proceed'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                       const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                       SingleChildScrollView(
                         child: ListView.builder(
                           itemCount: localizationController.languages.length,
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                               child: LanguageCardWidget(
                                 languageModel: localizationController.languages[index],
                                 localizationController: localizationController,
                                 index: index,
                                 fromWeb: true,
                               ),
                             );
                           },
                         ),
                       ),
                       const SizedBox(height: Dimensions.paddingSizeLarge),

                       CustomButton(
                         buttonText: 'Update'.tr,
                         width: 200,
                         onPressed: () {

                           int index = localizationController.selectedLanguageIndex;

                           localizationController.setLanguage(Locale(
                             AppConstants.languages[index].languageCode!,
                             AppConstants.languages[index].countryCode,
                           ));

                           if(localizationController.languages.isNotEmpty && localizationController.selectedLanguageIndex != -1) {
                             localizationController.saveCacheLanguage(Locale(
                               AppConstants.languages[localizationController.selectedLanguageIndex].languageCode!,
                               AppConstants.languages[localizationController.selectedLanguageIndex].countryCode,
                             ));
                           }
                           showCustomSnackBar('Language updated successfully'.tr, isError: false);
                         },
                       ),

                     ]),
                   )),

                 ]),
               ),


              ]),
            )),
          ),
        )),
      ]);
    });
  }
}
