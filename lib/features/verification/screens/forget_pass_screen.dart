import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/verification/controllers/verification_controller.dart';
import 'package:liwas_user/features/verification/screens/verification_screen.dart';
import 'package:liwas_user/helper/custom_validator.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/helper/validate_check.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromDialog;
  const ForgetPassScreen({super.key, this.fromDialog = false});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  String? _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
  GlobalKey<FormState>? _formKeyLogin;
  bool isEmail = false;
  bool isPhone = false;

  @override
  void initState() {
    super.initState();

    isPhone = (Get.find<SplashController>().configModel!.isSmsActive! || Get.find<SplashController>().configModel!.firebaseOtpVerification!);
    isEmail = Get.find<SplashController>().configModel!.isMailActive!;

    _formKeyLogin = GlobalKey<FormState>();
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          FocusScope.of(Get.context!).requestFocus(_numberFocusNode);
        });
      });
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? null : CustomAppBar(title: 'Forgot password'.tr),
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      body: Center(child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(
          child: Container(
            height: widget.fromDialog ? 600 : null,
            width: widget.fromDialog ? 475 : context.width > 700 ? 700 : context.width,
            decoration: context.width > 700 ? BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow:  ResponsiveHelper.isDesktop(context) ?  null : [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
            ) : null,
            child: Column(
              children: [
                ResponsiveHelper.isDesktop(context) ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ) : const SizedBox(),

                (isPhone || isEmail) ? Padding(
                  padding: widget.fromDialog ? const EdgeInsets.all(Dimensions.paddingSizeExtremeLarge) : context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(children: [

                    Image.asset(Images.logo, width: 135),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                      child: Text('Forgot your password'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: Text(
                        isPhone ? 'Please enter the registered phone where you want'.tr : 'Please enter the registered email where you want'.tr,
                        style: ralewayRegular.copyWith(fontSize: widget.fromDialog ? Dimensions.fontSizeSmall : null, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                    Form(
                      key: _formKeyLogin,
                      child: isPhone ? CustomTextField(
                        titleText: 'xxx-xxx-xxxxx'.tr,
                        controller: _numberController,
                        focusNode: _numberFocusNode,
                        inputType: TextInputType.phone,
                        inputAction: TextInputAction.done,
                        isPhone: true,
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code ?? Get.find<LocalizationController>().locale.countryCode,
                        onSubmit: (text) => GetPlatform.isWeb ? _onPressedForgetPass(_countryDialCode!) : null,
                        labelText: 'Phone'.tr,
                        validator: (value) => ValidateCheck.validateEmptyText(value, null),
                      ) : CustomTextField(
                        titleText: 'Enter email'.tr,
                        labelText: 'Email'.tr,
                        showLabelText: true,
                        required: true,
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.done,
                        prefixIcon: CupertinoIcons.mail_solid,
                        validator: (value) => ValidateCheck.validateEmail(value),
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                    GetBuilder<VerificationController>(builder: (verificationController) {
                      return GetBuilder<AuthController>(builder: (authController) {
                        return CustomButton(
                          radius: Dimensions.radiusDefault,
                          buttonText: 'Request otp'.tr,
                          isLoading: verificationController.isLoading || authController.isLoading,
                          onPressed: () => _onPressedForgetPass(_countryDialCode!),
                        );
                      });
                    }),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text('Or'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    RichText(text: TextSpan(children: [
                      TextSpan(
                        text: '${'Back to'.tr} ',
                        style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      TextSpan(
                        text: 'Login in'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.back(),
                      ),
                    ]), textAlign: TextAlign.center, maxLines: 3),

                  ]),
                ) : Padding(
                  padding: widget.fromDialog ? const EdgeInsets.all(Dimensions.paddingSizeExtremeLarge) : context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(children: [

                    Image.asset(Images.forgot, height:  widget.fromDialog ? 160 : 220),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                      child: Text('Sorry something went wrong'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: Text(
                        'Please try again after some time or contact with our support team'.tr,
                        style: ralewayRegular.copyWith(fontSize: widget.fromDialog ? Dimensions.fontSizeSmall : null, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                    CustomButton(
                      buttonText: 'Help and support'.tr,
                      onPressed: () {
                        Get.toNamed(RouteHelper.getSupportRoute());
                      }
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    RichText(text: TextSpan(children: [
                      TextSpan(
                        text: '${'Continue as'.tr} ',
                        style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                      ),
                      TextSpan(
                        text: 'Guest'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.offAllNamed(RouteHelper.getInitialRoute()),
                      ),
                    ]), textAlign: TextAlign.center, maxLines: 3),

                  ]),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _onPressedForgetPass(String countryCode) async {
    String phone = _numberController.text.trim();
    String email = _emailController.text.trim();

    String numberWithCountryCode = countryCode+phone;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if(_formKeyLogin!.currentState!.validate()) {
      if (!phoneValid.isValid && !isEmail) {
        showCustomSnackBar('Invalid phone number'.tr);
      } else {
        Get.find<VerificationController>().forgetPassword(email: email, phone: numberWithCountryCode).then((status) async {
          if (status.isSuccess) {
            if(Get.find<SplashController>().configModel!.centralizeLoginSetup!.phoneVerificationStatus! && Get.find<SplashController>().configModel!.firebaseOtpVerification!) {
              Get.find<AuthController>().firebaseVerifyPhoneNumber(numberWithCountryCode, status.message, '', fromSignUp: false);
            } else {
              if(ResponsiveHelper.isDesktop(Get.context)) {
                Get.back();
                Get.dialog(VerificationScreen(
                  number: numberWithCountryCode, email: email, token: '', fromSignUp: false,
                  fromForgetPassword: true, loginType: '', password: '',
                ));
              } else {
                Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, email, '', RouteHelper.forgotPassword, '', ''));
              }
            }
          }else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}
