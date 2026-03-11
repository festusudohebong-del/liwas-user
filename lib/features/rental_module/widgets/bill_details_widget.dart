import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_tool_tip_widget.dart';
import 'package:liwas_user/features/rental_module/rental_cart_screen/controllers/taxi_cart_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class BillDetailsWidget extends StatelessWidget {
  final double tripCost;
  final double tripDiscountCost;
  final double couponDiscountCost;
  final double subtotal;
  final double vat;
  final double serviceFee;
  final bool isCompleted;
  final bool? taxInclude;
  final double? taxPercent;
  const BillDetailsWidget({
    super.key, required this.tripCost, required this.tripDiscountCost, required this.couponDiscountCost,
    required this.subtotal, required this.vat, required this.serviceFee, this.isCompleted = false,
    this.taxInclude = false, this.taxPercent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          !isCompleted ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text('Bill details'.tr, style: ralewayBold.copyWith(fontSize: 14)),

            CustomToolTip(
              message: 'Taxi bill info'.tr,
              preferredDirection: AxisDirection.up,
              child: Icon(Icons.info, size: 18, color: Theme.of(context).primaryColor),
            ),

          ]) : Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            child: Text('Trip cost info'.tr, style: ralewayBold),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Trip cost'.tr, style: ralewayRegular),
            Text(PriceConverter.convertPrice(tripCost, forTaxi: true), style: ralewayRegular, textDirection: TextDirection.ltr),
          ]),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Trip discount'.tr, style: ralewayRegular),
            Text('- ${PriceConverter.convertPrice(tripDiscountCost, forTaxi: true)}', style: ralewayRegular, textDirection: TextDirection.ltr),
          ]),

          if(couponDiscountCost > 0)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Coupon discount'.tr, style: ralewayRegular),
            Text('- ${PriceConverter.convertPrice(couponDiscountCost, forTaxi: true)}', style: ralewayRegular, textDirection: TextDirection.ltr),
          ]),

          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Subtotal'.tr, style: ralewayBold),
            Text(PriceConverter.convertPrice(subtotal, forTaxi: true), style: ralewayRegular, textDirection: TextDirection.ltr),
          ]),

          ((Get.find<TaxiCartController>().taxIncluded == null) || taxInclude! || (Get.find<TaxiCartController>().tripTax == 0)) ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Vat tax'.tr, style: ralewayRegular),
            ]),

            Text('+ ${PriceConverter.convertPrice(vat, forTaxi: true)}', style: ralewayRegular, textDirection: TextDirection.ltr),
          ]),

          if(Get.find<SplashController>().configModel!.additionalChargeStatus!)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: ralewayRegular),
            Text(
              '+ ${PriceConverter.convertPrice(serviceFee, forTaxi: true)}',
              style: ralewayRegular, textDirection: TextDirection.ltr,
            ),
          ]),


    ]);
  }
}
