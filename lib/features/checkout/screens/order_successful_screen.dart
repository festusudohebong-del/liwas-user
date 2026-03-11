import 'dart:async';
import 'package:liwas_user/features/auth/widgets/auth_dialog_widget.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/common/controllers/theme_controller.dart';
import 'package:liwas_user/features/location/domain/models/zone_response_model.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/order/controllers/order_controller.dart';
import 'package:liwas_user/helper/address_helper.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/web_menu_bar.dart';
import 'package:liwas_user/features/checkout/widgets/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderID;
  final String? contactPersonNumber;
  final bool? createAccount;
  final String guestId;
  const OrderSuccessfulScreen({super.key, required this.orderID, this.contactPersonNumber, this.createAccount = false, required this.guestId});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {

  bool? _isCashOnDeliveryActive = false;
  String? orderId;

  @override
  void initState() {
    super.initState();

    orderId = widget.orderID!;
    if(widget.orderID != null) {
      if(widget.orderID!.contains('?')){
        var parts = widget.orderID!.split('?');
        String id = parts[0].trim();
        orderId = id;
      }
    }

    if(!widget.createAccount!) {
      Get.find<OrderController>().trackOrder(orderId.toString(), null, false, contactNumber: widget.contactPersonNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<OrderController>(builder: (orderController){
          double total = 0;
          bool success = true;
          bool parcel = false;
          bool takeAway = false;
          double? maximumCodOrderAmount;
          if(orderController.trackModel != null) {
            total = ((orderController.trackModel!.orderAmount! / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
            success = orderController.trackModel!.paymentStatus == 'paid' || orderController.trackModel!.paymentMethod == 'cash_on_delivery'
              || orderController.trackModel!.paymentMethod == 'partial_payment' || orderController.trackModel!.paymentMethod == 'wallet';
            parcel = orderController.trackModel!.orderType == 'parcel';
            takeAway = orderController.trackModel!.orderType == 'take_away';
            for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
              for(Modules m in zData.modules!) {
                if(m.id == Get.find<SplashController>().module!.id) {
                  maximumCodOrderAmount = m.pivot!.maximumCodOrderAmount;
                  break;
                }
              }
              if(zData.id ==  AddressHelper.getUserAddressFromSharedPref()!.zoneId){
                _isCashOnDeliveryActive = zData.cashOnDelivery;
              }
            }

            if (!success && !Get.isDialogOpen! && orderController.trackModel!.orderStatus != 'canceled' && Get.currentRoute.startsWith(RouteHelper.orderSuccess)) {
              Future.delayed(const Duration(seconds: 1), () {
                Get.dialog(PaymentFailedDialog(
                  orderID: orderId, isCashOnDelivery: _isCashOnDeliveryActive, orderAmount: total, maxCodOrderAmount: maximumCodOrderAmount,
                  orderType: parcel ? 'parcel' : 'delivery', guestId: widget.guestId,
                ), barrierDismissible: false);
              });
            }
          }

          return orderController.trackModel != null || widget.createAccount! ? Center(
            child: SingleChildScrollView(
              child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                Image.asset(success ? Images.checked : Images.warning, width: 100, height: 100),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(
                  success ? parcel ? 'You placed the parcel request successfully'.tr
                      : 'You placed the order successfully'.tr : 'Your order is failed to place'.tr,
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                widget.createAccount! ? Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'And create account successfully'.tr,
                      style: ralewayMedium,
                    ),
                    InkWell(
                      onTap: () {
                        if(ResponsiveHelper.isDesktop(context)){
                          Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false)));
                        }else{
                          Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Text('Sign in'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ]),
                ) : const SizedBox(),

                AuthHelper.isGuestLoggedIn() ? SelectableText(
                  '${'Order id'.tr}: $orderId',
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                ) : const SizedBox(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                  child: Text(
                    success ? parcel ? 'Your parcel request is placed successfully'.tr : takeAway ? 'Thank you for your order'.tr
                        : 'Your order is placed successfully'.tr : 'Your order is failed to place because'.tr,
                    style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),

                ResponsiveHelper.isDesktop(context) && (success && Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 && total.floor() > 0 ) && AuthHelper.isLoggedIn()  ? Column(children: [

                  Image.asset(Get.find<ThemeController>().darkTheme ? Images.congratulationDark : Images.congratulationLight, width: 150, height: 150),

                  Text('Congratulations'.tr , style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Text(
                      '${'You have earned'.tr} ${total.floor().toString()} ${'Points it will add to'.tr}',
                      style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ]) : const SizedBox.shrink() ,
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CustomButton(
                  width: ResponsiveHelper.isDesktop(context) ? 300 : double.infinity,
                  buttonText: 'Back to home'.tr, onPressed: () {
                    if(AuthHelper.isLoggedIn()) {
                      Get.find<AuthController>().saveEarningPoint(total.toStringAsFixed(0));
                    }
                    Get.offAllNamed(RouteHelper.getInitialRoute());
                  }),
                ),
              ]))),
            ),
          ) : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
