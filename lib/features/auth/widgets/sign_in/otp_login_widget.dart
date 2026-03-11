import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/auth/widgets/social_login_widget.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/validate_check.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class OtpLoginWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final FocusNode phoneFocus;
  final String? countryDialCode;
  final Function(CountryCode countryCode)? onCountryChanged;
  final Function() onClickLoginButton;
  final bool socialEnable;
  final bool backFromThis;
  const OtpLoginWidget({super.key, required this.phoneController, required this.phoneFocus, required this.onCountryChanged, required this.countryDialCode,
    required this.onClickLoginButton, this.socialEnable = false, required this.backFromThis});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<AuthController>(builder: (authController) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Hey there welcome back'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
          const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

          CustomTextField(
            titleText: 'xxx-xxx-xxxxx'.tr,
            controller: phoneController,
            focusNode: phoneFocus,
            inputAction: TextInputAction.done,
            inputType: TextInputType.phone,
            isPhone: true,
            onCountryChanged: onCountryChanged,
            countryDialCode: countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
            labelText: 'Phone'.tr,
            required: true,
            validator: (value) => ValidateCheck.validateEmptyText(value, "Please enter phone number".tr),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => authController.toggleRememberMe(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      side: BorderSide(color: Theme.of(context).hintColor),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Theme.of(context).primaryColor,
                      value: authController.isActiveRememberMe,
                      onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('Remember me'.tr, style: ralewayRegular),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // const ConditionCheckBoxWidget(forSignUp: true),
          // const SizedBox(height: Dimensions.paddingSizeLarge),

          CustomButton(
            buttonText: 'Login'.tr,
            radius: Dimensions.radiusDefault,
            isBold: isDesktop ? false : true,
            isLoading: authController.isLoading,
            onPressed: onClickLoginButton,
            fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          socialEnable ? SocialLoginWidget(onlySocialLogin: false, backFromThis: backFromThis) : const SizedBox(),

          socialEnable && isDesktop ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

          !socialEnable ? const SizedBox(height: 100) : const SizedBox(),

        ]),
      );
    });
  }
}
