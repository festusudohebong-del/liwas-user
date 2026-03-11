import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/location/domain/models/zone_response_model.dart';
import 'package:liwas_user/features/order/controllers/order_controller.dart';
import 'package:liwas_user/helper/address_helper.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/features/checkout/widgets/payment_failed_dialog.dart';

class OrderSuccessfulDialog extends StatefulWidget {
  final String? orderID;
  const OrderSuccessfulDialog({super.key, required this.orderID});

  @override
  State<OrderSuccessfulDialog> createState() => _OrderSuccessfulDialogState();
}

class _OrderSuccessfulDialogState extends State<OrderSuccessfulDialog> {
  bool? _isCashOnDeliveryActive = false;

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().trackOrder(widget.orderID.toString(), null, false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        await Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: GetBuilder<OrderController>(builder: (orderController){
        double total = 0;
        bool success = true;
        bool parcel = false;
        double? maximumCodOrderAmount;
        if(orderController.trackModel != null) {
          total = ((orderController.trackModel!.orderAmount! / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
          success = orderController.trackModel!.paymentStatus == 'paid' || orderController.trackModel!.paymentMethod == 'cash_on_delivery'
              || orderController.trackModel!.paymentMethod == 'partial_payment';
          parcel = orderController.trackModel!.paymentMethod == 'parcel';
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

          if (!success && !Get.isDialogOpen! && orderController.trackModel!.orderStatus != 'canceled') {
            Future.delayed(const Duration(seconds: 1), () {
              Get.dialog(PaymentFailedDialog(
                orderID: widget.orderID, isCashOnDelivery: _isCashOnDeliveryActive, orderAmount: total,
                maxCodOrderAmount: maximumCodOrderAmount, orderType: parcel ? 'parcel' : 'delivery',
                guestId: '',
              ), barrierDismissible: false);
            });
          }
        }

        return orderController.trackModel != null ? Center(
          child: Container(
            width: 500,  height: 390,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              ResponsiveHelper.isDesktop(context) ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.clear),
                ),
              ) : const SizedBox(),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Image.asset(success ? Images.checked : Images.warning, width: 55, height: 55 ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                success ? parcel ? 'You placed the parcel request successfully'.tr
                    : 'You placed the order successfully'.tr : 'Your order is failed to place'.tr,
                style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                child: Text(
                  success ? parcel ? 'Your parcel request is placed successfully'.tr
                      : 'Your order is placed successfully'.tr : 'Your order is failed to place because'.tr,
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),
              // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              //
              // Padding(
              //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              //   child: CustomButton( width: 400, height: 55, buttonText: 'Back to home'.tr, isBold: false, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
              // ),

          ])),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
