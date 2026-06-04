import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/common/widgets/custom_card.dart';
import 'package:liwas_user/features/order/widgets/support_reason_bottom_sheet.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/order/controllers/order_controller.dart';
import 'package:liwas_user/features/order/domain/models/order_model.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/features/order/widgets/order_item_widget.dart';
import 'package:liwas_user/features/parcel/widgets/details_widget.dart';

class OrderCalculationWidget extends StatelessWidget {
  final OrderController orderController;
  final OrderModel order;
  final bool ongoing;
  final bool parcel;
  final bool prescriptionOrder;
  final double deliveryCharge;
  final double itemsPrice;
  final double discount;
  final double couponDiscount;
  final double tax;
  final double addOns;
  final double dmTips;
  final bool taxIncluded;
  final double subTotal;
  final double total;
  final Widget bottomView;
  final double extraPackagingAmount;
  final double referrerBonusAmount;
  final Function timerCancel;
  final Function startApiCall;
  
  const OrderCalculationWidget({
    super.key, required this.orderController, required this.order, required this.ongoing,
    required this.parcel, required this.prescriptionOrder, required this.deliveryCharge,
    required this.itemsPrice, required this.discount, required this.couponDiscount, required this.tax,
    required this.addOns, required this.dmTips, required this.taxIncluded, required this.subTotal,
    required this.total, required this.bottomView, required this.extraPackagingAmount, required this.referrerBonusAmount, required this.timerCancel, required this.startApiCall,
  });

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);
    
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: isDesktop ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeSmall),
        child: CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (isDesktop && orderController.orderDetails!.isNotEmpty) ? Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: parcel ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                DetailsWidget(title: 'Sender details'.tr, address: order.deliveryAddress),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                DetailsWidget(title: 'Receiver details'.tr, address: order.receiverDetails),
              ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderController.orderDetails!.length,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    return OrderItemWidget(order: order, orderDetails: orderController.orderDetails![index]);
                  },
                ),
              ]),
            ) : const SizedBox(),
            SizedBox(height: parcel &&  orderController.orderDetails!.isNotEmpty ? Dimensions.paddingSizeLarge : 0),

            SizedBox(height: (order.orderAttachmentFullUrl != null && order.orderAttachmentFullUrl!.isNotEmpty ) ? Dimensions.paddingSizeLarge : 0),

            Text('Billing summary'.tr, style: ralewaySemiBold),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Column(children: [
              parcel ? Column(children: [

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Delivery fee'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  Text(
                    '(+) ${PriceConverter.convertPrice(order.deliveryCharge)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                  ),
                ]),
                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Delivery man tips'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  Text('(+) ${PriceConverter.convertPrice(order.dmTips)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]),
                (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                (tax == 0) || taxIncluded ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Vat tax'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text('(+) ${PriceConverter.convertPrice(tax)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]),
                SizedBox(height: (tax == 0) || taxIncluded ? 0 : 10),

                (order.additionalCharge != null && order.additionalCharge! > 0 && Get.find<SplashController>().activeAdditionalCharges != null && Get.find<SplashController>().activeAdditionalCharges!.isNotEmpty) ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Get.find<SplashController>().activeAdditionalCharges!.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Expanded(child: Text(Get.find<SplashController>().activeAdditionalCharges![index].chargeName!, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),
                        const SizedBox(width: 10),

                        Text('(+) ${PriceConverter.convertPrice(Get.find<SplashController>().activeAdditionalCharges![index].chargeAmount)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ]),
                    );
                  },
                ) : (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  )),
                  const SizedBox(width: 10),

                  Text('(+) ${PriceConverter.convertPrice(order.additionalCharge)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]) : const SizedBox(),

              ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Item price'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  Text(PriceConverter.convertPrice(itemsPrice), style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]),
                const SizedBox(height: 10),

                Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Addons'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    Text('(+) ${PriceConverter.convertPrice(addOns)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                  ],
                ) : const SizedBox(),

                Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5),) : const SizedBox(),

                Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    Text(PriceConverter.convertPrice(subTotal), style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                  ],
                ) : const SizedBox(),
                SizedBox(height: Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? 10 : 0),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Discount'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  Text('(-) ${PriceConverter.convertPrice(discount)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]),
                const SizedBox(height: 10),

                couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Coupon discount'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  Text(
                    '(-) ${PriceConverter.convertPrice(couponDiscount)}',
                    style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                  ),
                ]) : const SizedBox(),
                SizedBox(height: couponDiscount > 0 ? 10 : 0),

                (referrerBonusAmount > 0) ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Referral discount'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    Text('(+) ${PriceConverter.convertPrice(referrerBonusAmount)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                  ],
                ) : const SizedBox(),
                SizedBox(height: referrerBonusAmount > 0 ? 10 : 0),

                (order.additionalCharge != null && order.additionalCharge! > 0 && Get.find<SplashController>().activeAdditionalCharges != null && Get.find<SplashController>().activeAdditionalCharges!.isNotEmpty) ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Get.find<SplashController>().activeAdditionalCharges!.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Expanded(child: Text(Get.find<SplashController>().activeAdditionalCharges![index].chargeName!, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),
                        const SizedBox(width: 10),

                        Text('(+) ${PriceConverter.convertPrice(Get.find<SplashController>().activeAdditionalCharges![index].chargeAmount)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ]),
                    );
                  },
                ) : (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    child: Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 10),

                  Text('(+) ${PriceConverter.convertPrice(order.additionalCharge)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]) : const SizedBox(),
                (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                (tax == 0) || taxIncluded ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Vat tax'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  Text('(+) ${PriceConverter.convertPrice(tax)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                ]),
                SizedBox(height: (tax == 0) || taxIncluded ? 0 : 10),

                (dmTips > 0) ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery man tips'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    Text('(+) ${PriceConverter.convertPrice(dmTips)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                  ],
                ) : const SizedBox(),
                SizedBox(height: dmTips > 0 ? 10 : 0),

                (extraPackagingAmount > 0) ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Extra packaging'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    Text('(+) ${PriceConverter.convertPrice(extraPackagingAmount)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                  ],
                ) : const SizedBox(),
                SizedBox(height: extraPackagingAmount > 0 ? 10 : 0),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Delivery fee'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  deliveryCharge > 0 ? Text(
                    '(+) ${PriceConverter.convertPrice(deliveryCharge)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                  ) : Text('Free'.tr, style: ralewayRegular.copyWith( fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                ]),
              ]),
            ]),
            Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

            order.paymentMethod == 'partial_payment' ? Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 1,
                    strokeCap: StrokeCap.butt,
                    dashPattern: const [8, 5],
                    padding: const EdgeInsets.all(8),
                    radius: const Radius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total amount'.tr, style: ralewayMedium.copyWith(
                        fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor,
                      )),
                      Text(
                        PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                        style: ralewayMedium.copyWith(fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Paid by wallet'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text(
                        PriceConverter.convertPrice(order.payments?[0].amount ?? 0),
                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        '${order.payments?[1].paymentStatus == 'paid' ? 'Paid by'.tr : 'Due amount'.tr} (${order.payments?[1].paymentMethod?.tr})',
                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                      Text(
                        PriceConverter.convertPrice(order.payments?[1].amount ?? 0),
                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ]),

                  ]),
                ),
              ),
            ) : Row(children: [
              Text('Total amount'.tr, style: ralewayBold.copyWith(
                fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
              )),

              taxIncluded ? Text(' ${'Vat tax inc'.tr}', style: ralewayMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
              )) : const SizedBox(),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              if(parcel)
                Container(
                  decoration: BoxDecoration(
                    color: order.paymentStatus == 'paid' ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                    child: Text(
                      order.paymentStatus == 'paid' ? 'Paid'.tr : 'due'.tr,
                      style: ralewayRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: order.paymentStatus == 'paid' ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              const Expanded(child: SizedBox()),

              Text(
                PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                style: ralewayBold.copyWith(fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault),
              ),
            ]),
            SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),

            order.parcelCancellation?.returnFee != null && order.parcelCancellation!.returnFee! > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Text('Return fee'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: order.parcelCancellation!.returnFeePaymentStatus == 'paid' ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                      child: Text(
                        order.parcelCancellation!.returnFeePaymentStatus == 'paid' ? 'Paid'.tr : 'due'.tr,
                        style: ralewayRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: order.parcelCancellation!.returnFeePaymentStatus == 'paid' ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ]),

                Text('(+) ${PriceConverter.convertPrice(order.parcelCancellation?.returnFee)}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
              ]),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total'.tr, style: ralewayBold),

                Text(PriceConverter.convertPrice(total + order.parcelCancellation!.returnFee!), style: ralewayBold, textDirection: TextDirection.ltr),
              ]),
            ]) : const SizedBox(),
            order.parcelCancellation?.returnFee != null && order.parcelCancellation!.returnFee! > 0 ? SizedBox(height: isDesktop ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall) : SizedBox(),

            isDesktop ? bottomView : const SizedBox(),
            SizedBox(height: isDesktop ? Dimensions.paddingSizeDefault : 0),

            isDesktop && AuthHelper.isLoggedIn() ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () async {
                    if(isDesktop) {
                      await Get.dialog(Dialog(child: SupportReasonBottomSheet(orderId: order.id!, timerCancel: timerCancel, startApiCall: startApiCall,)));
                    } else {
                      await Get.bottomSheet(SupportReasonBottomSheet(orderId: order.id!, timerCancel: timerCancel, startApiCall: startApiCall,), backgroundColor: Colors.transparent, isScrollControlled: true,);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const CustomAssetImageWidget(Images.chatSupport, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Flexible(
                        child: RichText(text: TextSpan(children: [
                          TextSpan(
                            text: '${'Message to'.tr} ',
                            style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                          ),
                          TextSpan(
                            text: Get.find<SplashController>().configModel!.businessName,
                            style: ralewayMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeDefault, decoration: TextDecoration.underline),
                          ),
                        ]), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ) : const SizedBox(),

          ]),
        ),
      ),

      !isDesktop && AuthHelper.isLoggedIn() ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () async {
            if(isDesktop) {
              await Get.dialog(Dialog(child: SupportReasonBottomSheet(orderId: order.id!, timerCancel: timerCancel, startApiCall: startApiCall,)));
            } else {
              await Get.bottomSheet(SupportReasonBottomSheet(orderId: order.id!, timerCancel: timerCancel, startApiCall: startApiCall,), backgroundColor: Colors.transparent, isScrollControlled: true,);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const CustomAssetImageWidget(Images.chatSupport, height: 20, width: 20),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Flexible(
                child: RichText(text: TextSpan(children: [
                  TextSpan(
                    text: '${'Message to'.tr} ',
                    style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                  TextSpan(
                    text: Get.find<SplashController>().configModel!.businessName,
                    style: ralewayMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeDefault, decoration: TextDecoration.underline),
                  ),
                ]), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ) : const SizedBox(),

    ]);
  }
}
