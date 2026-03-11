import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';
import 'package:liwas_user/features/checkout/controllers/checkout_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/validate_check.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class GuestCreateAccount extends StatelessWidget {
  final TextEditingController guestPasswordController;
  final TextEditingController guestConfirmPasswordController;
  final FocusNode guestPasswordNode;
  final FocusNode guestConfirmPasswordNode;
  final bool fromParcel;
  const GuestCreateAccount({super.key, required this.guestPasswordController, required this.guestConfirmPasswordController, required this.guestPasswordNode,
    required this.guestConfirmPasswordNode, this.fromParcel = false});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<CheckoutController>(builder: (checkoutController) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: fromParcel ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, spreadRadius: 1)] : [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
        child: Column(children: [

          Row(children: [

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Create account with existing info'.tr, style: ralewayMedium),
                Text('Your provided phone number use as a login credential'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              ]),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            SizedBox(
              height: 24, width: 24,
              child: Checkbox(
                value: checkoutController.isCreateAccount,
                onChanged: (bool? value) => checkoutController.toggleCreateAccount(),
                activeColor: Theme.of(context).primaryColor,
              ),
            ),

          ]),
          SizedBox(height:  checkoutController.isCreateAccount ? Dimensions.paddingSizeLarge : 0),

          Visibility(
            visible: checkoutController.isCreateAccount,
            child: isDesktop ? Row(children: [

              Expanded(
                child: CustomTextField(
                  labelText: 'Password'.tr,
                  titleText: '8 character'.tr,
                  controller: guestPasswordController,
                  focusNode: guestPasswordNode,
                  nextFocus: guestConfirmPasswordNode,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  required: true,
                  validator: (value) => ValidateCheck.validateEmptyText(value, null),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: CustomTextField(
                  labelText: 'Confirm password'.tr,
                  titleText: '8 character'.tr,
                  controller: guestConfirmPasswordController,
                  focusNode: guestConfirmPasswordNode,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  required: true,
                  validator: (value) => ValidateCheck.validateEmptyText(value, null),
                ),
              ),

            ]) : Column(children: [

              CustomTextField(
                labelText: 'Password'.tr,
                titleText: '8 character'.tr,
                controller: guestPasswordController,
                focusNode: guestPasswordNode,
                nextFocus: guestConfirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                isPassword: true,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, null),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

              CustomTextField(
                labelText: 'Confirm password'.tr,
                titleText: '8 character'.tr,
                controller: guestConfirmPasswordController,
                focusNode: guestConfirmPasswordNode,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                isPassword: true,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, null),
              ),

            ]),
          ),

        ]),
      );
    });
  }
}
