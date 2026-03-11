import 'package:flutter/gestures.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionCheckBoxWidget extends StatelessWidget {
  final bool forDeliveryMan;
  final bool forSignUp;
  const ConditionCheckBoxWidget({super.key, this.forDeliveryMan = false, this.forSignUp = true});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [

      forDeliveryMan ? GetBuilder<DeliverymanRegistrationController>(builder: (dmRegController) {
        return GetBuilder<AuthController>(builder: (authController) {
          return Checkbox(
            activeColor: Theme.of(context).primaryColor,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            value: forSignUp ? authController.acceptTerms : dmRegController.acceptTerms,
            onChanged: (bool? isChecked) => forSignUp ? authController.toggleTerms() : dmRegController.toggleTerms(),
          );
        });
      }) : const SizedBox(),

      forDeliveryMan ? const SizedBox() : Text( '* ', style: ralewayRegular.copyWith(color: Theme.of(context).hintColor)),

      Flexible(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: forDeliveryMan ? 'I agree with all the'.tr :'I agree with all the'.tr,
              style: ralewayRegular.copyWith(color: forDeliveryMan ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).hintColor, fontSize: forDeliveryMan ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
              text: 'Terms conditions'.tr,
              style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
            ),
          ]),
        ),
      ),

    ]);
  }
}
