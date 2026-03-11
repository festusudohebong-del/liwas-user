import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/confirmation_dialog.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';
import 'package:liwas_user/features/auth/widgets/web_registration_stepper_widget.dart';
import 'package:liwas_user/features/business/controllers/business_controller.dart';
import 'package:liwas_user/features/business/widgets/payment_cart_widget.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final int storeId;
  final int packageId;
  const SubscriptionPaymentScreen({super.key, required this.storeId, required this.packageId});

  @override
  State<SubscriptionPaymentScreen> createState() => _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final bool _canBack = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    // Get.find<BusinessController>().getPackageList(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<BusinessController>(builder: (businessController) {
      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, result) async{
          if(_canBack) {
          }else {
            _showBackPressedDialogue('Your business plan not setup yet'.tr);
          }
        },
        child: Scaffold(
          appBar: isDesktop ? CustomAppBar(title: 'Vendor registration'.tr) : null,
          endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,

          body: Column(children: [

            WebScreenTitleWidget(title: 'Join as vendor'.tr),

            const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

            isDesktop ? SizedBox(
              width: Dimensions.webMaxWidth,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: RegistrationStepperWidget(status: Get.find<BusinessController>().businessPlanStatus),
              ),
            ) : Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  'Vendor registration'.tr,
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                Text(
                  'You are one step away choose your business plan'.tr,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                  value: 0.75,
                ),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: FooterView(
                  minHeight: 0.45,
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(children: [

                      Container(
                        margin: EdgeInsets.only(top: isDesktop ? Dimensions.paddingSizeSmall : 0),
                        decoration: isDesktop ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                        ) : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 50 : 0,
                          vertical:  isDesktop ? Dimensions.paddingSizeDefault : 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(children: [

                            Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus ?? false ? PaymentCartWidget(
                              title: '${'Continue with'.tr} ${Get.find<SplashController>().configModel!.subscriptionFreeTrialDays} '
                                  '${Get.find<SplashController>().configModel!.subscriptionFreeTrialType} ${'Days free trial'.tr}',
                              index: 0,
                              onTap: () {
                                businessController.setPaymentIndex(0);
                              },
                            ) : const SizedBox(),
                            SizedBox(height: Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus??false ? Dimensions.paddingSizeExtremeLarge : 0),

                            Get.find<SplashController>().configModel!.digitalPayment! ? Column(children: [
                              Row(children: [
                                Text('${'Pay via online'.tr} ', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                Text(
                                  'Faster and secure way to pay bill'.tr,
                                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                ),
                              ]),

                              SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),

                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                                  mainAxisSpacing: Dimensions.paddingSizeLarge,
                                  mainAxisExtent: 55,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                                itemBuilder: (context, index) {
                                  bool isSelected = businessController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == businessController.digitalPaymentName;

                                  return InkWell(
                                    onTap: (){
                                      businessController.setPaymentIndex(1);
                                      businessController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: isSelected ? Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 0.3) : null,
                                        boxShadow: isSelected ? null : [const BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                                      child: Row(children: [
                                        Container(
                                          height: 20, width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                            border: Border.all(color: Theme.of(context).disabledColor),
                                          ),
                                          child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        Text(
                                          Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayTitle!,
                                          style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                        ),
                                        const Spacer(),

                                        CustomImage(
                                          height: 20, fit: BoxFit.contain,
                                          image: '${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImageFullUrl}',
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                      ]),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: !isDesktop ? Dimensions.paddingSizeLarge : 0),
                            ]) : const SizedBox(),

                          ]),
                        ),
                      ),

                      SizedBox(height: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),

                      isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
                          ),
                          width: 120,
                          child: CustomButton(
                            transparent: true,
                            textColor: Theme.of(context).disabledColor,
                            radius: Dimensions.radiusSmall,
                            onPressed: () {
                              Get.back();
                            },
                            buttonText: 'Back'.tr,
                            isBold: false,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomButton(
                          textColor: Theme.of(context).cardColor,
                          radius: Dimensions.radiusSmall,
                          width: 140,
                          buttonText: 'Confirm'.tr,
                          onPressed: () {
                            businessController.submitBusinessPlan(storeId: widget.storeId, packageId: widget.packageId);
                          },
                          isBold: false,
                          fontSize: Dimensions.fontSizeSmall,
                        ),

                      ]) : const SizedBox(),

                    ]),
                  ),
                ),
              ),
            ),

            !isDesktop ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
              child: CustomButton(
                buttonText: 'Confirm'.tr,
                isLoading: businessController.isLoading,
                onPressed: () {
                  businessController.submitBusinessPlan(storeId: widget.storeId, packageId: widget.packageId);
                },
              ),
            ) : const SizedBox(),

          ]),
        ),
      );
    });
  }

  void _showBackPressedDialogue(String title){
    Get.dialog(ConfirmationDialog(icon: Images.support,
      title: title,
      description: 'Are you sure to go back'.tr, isLogOut: true,
      onYesPressed: () {
        if(Get.isDialogOpen!){
          Get.back();
        }
        Get.back();
      },
    ), useSafeArea: false);
  }
}
