import 'package:flutter/gestures.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutCondition extends StatelessWidget {
  final bool isParcel;
  const CheckoutCondition({super.key,  this.isParcel = false});

  @override
  Widget build(BuildContext context) {
    bool activeRefund = Get.find<SplashController>().configModel!.refundPolicyStatus == 1;
    return Row(children: [
      // SizedBox(
      //   width: 24.0,
      //   height: 24.0,
      //   child: Checkbox(
      //     activeColor: Theme.of(context).primaryColor,
      //     value: isParcel ? parcelController.acceptTerms : orderController.acceptTerms,
      //     onChanged: (bool? isChecked) => isParcel ? parcelController.toggleTerms() : orderController.toggleTerms(),
      //   ),
      // ),
      // const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(
        child: RichText(text: TextSpan(children: [
          TextSpan(
            text: '${'I have read and agreed with'.tr} ',
            style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          TextSpan(
            text: 'Privacy policy'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy')),
          ),
          !isParcel && activeRefund ? TextSpan(
            text: ', ',
            style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ) : TextSpan(
            text: ' ${'And'.tr} ',
            style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          TextSpan(
            text: 'Terms conditions'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
          ),
          !isParcel && activeRefund ? TextSpan(text: ' ${'And'.tr} ', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)) : const TextSpan(),

          !isParcel && activeRefund ? TextSpan(
            text: 'Refund policy'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('refund-policy')),
          ) : const TextSpan(),
        ]), textAlign: TextAlign.start, maxLines: 3),
      ),
    ]);
  }
}
