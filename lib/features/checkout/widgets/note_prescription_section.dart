import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/checkout/controllers/checkout_controller.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';

class NoteAndPrescriptionSection extends StatelessWidget {
  final CheckoutController checkoutController;
  final int? storeId;
  const NoteAndPrescriptionSection({super.key, required this.checkoutController, this.storeId, });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Additional note'.tr, style: ralewayMedium),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      CustomTextField(
        controller: checkoutController.noteController,
        titleText: 'Please provide extra napkin'.tr,
        showLabelText: false,
        maxLines: 3,
        inputType: TextInputType.multiline,
        inputAction: TextInputAction.done,
        capitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      /*storeId == null && Get.find<SplashController>().configModel!.moduleConfig!.module!.orderAttachment! ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Prescription'.tr, style: ralewayMedium),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '(${'Max size 2 mb'.tr})',
              style: ralewayRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ImagePickerWidget(
            image: '', rawFile: checkoutController.rawAttachment,
            onTap: () => checkoutController.pickImage(),
          ),
        ],
      ) : const SizedBox(),*/
    ]);
  }
}
