import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_tool_tip_widget.dart';
import 'package:liwas_user/features/cart/controllers/cart_controller.dart';
import 'package:liwas_user/features/checkout/widgets/extra_discount_view_widget.dart';
import 'package:liwas_user/features/checkout/widgets/prescription_image_picker_widget.dart';
import 'package:liwas_user/features/coupon/controllers/coupon_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/profile/controllers/profile_controller.dart';
import 'package:liwas_user/common/models/config_model.dart';
import 'package:liwas_user/features/checkout/controllers/checkout_controller.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/features/checkout/widgets/condition_check_box.dart';
import 'package:liwas_user/features/checkout/widgets/coupon_section.dart';
import 'package:liwas_user/features/checkout/widgets/note_prescription_section.dart';
import 'package:liwas_user/features/checkout/widgets/partial_pay_view.dart';

class BottomSection extends StatelessWidget {
  final CheckoutController checkoutController;
  final double total;
  final Module module;
  final double subTotal;
  final double discount;
  final CouponController couponController;
  final bool taxIncluded;
  final double tax;
  final double deliveryCharge;
  final bool todayClosed;
  final bool tomorrowClosed;
  final double orderAmount;
  final double? maxCodOrderAmount;
  final int? storeId;
  final double? taxPercent;
  final double price;
  final double addOns;
  final Widget? checkoutButton;
  final bool isPrescriptionRequired;
  final double referralDiscount;
  final double variationPrice;
  final double extraDiscount;

  const BottomSection(
      {super.key,
      required this.checkoutController,
      required this.total,
      required this.module,
      required this.subTotal,
      required this.discount,
      required this.couponController,
      required this.taxIncluded,
      required this.tax,
      required this.deliveryCharge,
      required this.todayClosed,
      required this.tomorrowClosed,
      required this.orderAmount,
      this.maxCodOrderAmount,
      this.storeId,
      this.taxPercent,
      required this.price,
      required this.addOns,
      this.checkoutButton,
      required this.isPrescriptionRequired,
      required this.referralDiscount,
      required this.variationPrice,
      required this.extraDiscount});

  @override
  Widget build(BuildContext context) {
    bool takeAway = checkoutController.orderType == 'take_away';
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
              ],
            )
          : null,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(children: [
        isDesktop
            ? pricingView(context: context, takeAway: takeAway)
            : const SizedBox(),

        const SizedBox(height: Dimensions.paddingSizeSmall),

        /// Coupon
        isDesktop && !isGuestLoggedIn
            ? CouponSection(
                storeId: storeId,
                checkoutController: checkoutController,
                total: total,
                price: price,
                discount: discount,
                addOns: addOns,
                deliveryCharge: deliveryCharge,
                variationPrice: variationPrice,
              )
            : const SizedBox(),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault,
              horizontal: Dimensions.paddingSizeLarge),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ///Additional Note & prescription..
            NoteAndPrescriptionSection(
                checkoutController: checkoutController, storeId: storeId),

            isDesktop && !isGuestLoggedIn
                ? PartialPayView(
                    totalPrice: total, isPrescription: storeId != null)
                : const SizedBox(),

            !isDesktop
                ? pricingView(context: context, takeAway: takeAway)
                : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            PrescriptionImagePickerWidget(
                checkoutController: checkoutController,
                storeId: storeId,
                isPrescriptionRequired: isPrescriptionRequired),

            const CheckoutCondition(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            ExtraDiscountViewWidget(extraDiscount: extraDiscount),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            ResponsiveHelper.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Total amount'.tr,
                                    style: ralewayMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).primaryColor)),
                                storeId == null
                                    ? const SizedBox()
                                    : Text(
                                        'Once your order is confirmed you will receive'
                                            .tr,
                                        style: ralewayRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeOverSmall,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                              ],
                            ),
                            storeId == null
                                ? const SizedBox()
                                : Text(
                                    'A notification with your bill total'.tr,
                                    style: ralewayRegular.copyWith(
                                      fontSize: Dimensions.fontSizeOverSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                          ],
                        ),
                        PriceConverter.convertAnimationPrice(
                          checkoutController.viewTotalPrice,
                          textStyle: ralewayMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: checkoutController.isPartialPay
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color
                                  : Theme.of(context).primaryColor),
                        ),
                      ])
                : const SizedBox(),
          ]),
        ),

        ResponsiveHelper.isDesktop(context)
            ? Padding(
                padding:
                    const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: checkoutButton,
              )
            : const SizedBox(),
      ]),
    );
  }

  Widget pricingView({required BuildContext context, required bool takeAway}) {
    return Column(children: [
      ResponsiveHelper.isDesktop(context)
          ? Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall),
                child: Text('Order summary'.tr,
                    style: ralewayBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
              ),
            )
          : const SizedBox(),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeLarge
                : 0),
        child: Column(
          children: [
            storeId == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(module.addOn! ? 'Subtotal'.tr : 'Item price'.tr,
                            style: ralewayRegular),
                        Text(PriceConverter.convertPrice(subTotal),
                            style: ralewayMedium,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            SizedBox(height: storeId == null ? Dimensions.paddingSizeSmall : 0),
            storeId == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('Discount'.tr, style: ralewayRegular),
                        Text('(-) ${PriceConverter.convertPrice(discount)}',
                            style: ralewayRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            (couponController.discount! > 0 || couponController.freeDelivery)
                ? Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Coupon discount'.tr, style: ralewayRegular),
                          (couponController.coupon != null &&
                                  couponController.coupon!.couponType ==
                                      'free_delivery')
                              ? Text(
                                  'Free delivery'.tr,
                                  style: ralewayRegular.copyWith(
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                                  style: ralewayRegular,
                                  textDirection: TextDirection.ltr,
                                ),
                        ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ])
                : const SizedBox(),
            referralDiscount > 0
                ? Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Referral discount'.tr, style: ralewayRegular),
                          Text(
                            '(-) ${PriceConverter.convertPrice(referralDiscount)}',
                            style: ralewayRegular,
                            textDirection: TextDirection.ltr,
                          ),
                        ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ])
                : const SizedBox(),
            ((checkoutController.taxIncluded == null) ||
                    taxIncluded ||
                    (checkoutController.orderTax == 0))
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('Vat tax'.tr, style: ralewayRegular),
                        Text(('(+) ') + PriceConverter.convertPrice(tax),
                            style: ralewayRegular,
                            textDirection: TextDirection.ltr),
                      ]),
            SizedBox(
                height: ((checkoutController.taxIncluded == null) ||
                        taxIncluded ||
                        (checkoutController.orderTax == 0))
                    ? 0
                    : Dimensions.paddingSizeSmall),
            (!takeAway &&
                    Get.find<SplashController>().configModel!.dmTipsStatus == 1)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery man tips'.tr, style: ralewayRegular),
                      Text(
                          '(+) ${PriceConverter.convertPrice(checkoutController.tips)}',
                          style: ralewayRegular,
                          textDirection: TextDirection.ltr),
                    ],
                  )
                : const SizedBox.shrink(),
            SizedBox(
                height: !takeAway &&
                        Get.find<SplashController>()
                                .configModel!
                                .dmTipsStatus ==
                            1
                    ? Dimensions.paddingSizeSmall
                    : 0.0),
            storeId == null
                ? (checkoutController.store!.extraPackagingStatus! &&
                        Get.find<CartController>().needExtraPackage)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Extra packaging'.tr, style: ralewayRegular),
                          Text(
                              '(+) ${PriceConverter.convertPrice(checkoutController.store!.extraPackagingAmount!)}',
                              style: ralewayRegular,
                              textDirection: TextDirection.ltr),
                        ],
                      )
                    : const SizedBox.shrink()
                : const SizedBox(),
            SizedBox(
                height: storeId == null
                    ? (checkoutController.store!.extraPackagingStatus! &&
                            Get.find<CartController>().needExtraPackage)
                        ? Dimensions.paddingSizeSmall
                        : 0.0
                    : 0.0),
            (AuthHelper.isGuestLoggedIn() &&
                    checkoutController.guestAddress == null)
                ? const SizedBox()
                : Row(children: [
                    Text('Delivery fee'.tr, style: ralewayRegular),
                    const SizedBox(width: 5),
                    (checkoutController.orderType == 'delivery') &&
                            (checkoutController.store?.selfDeliverySystem ==
                                0) &&
                            (checkoutController
                                    .surgePrice?.customerNoteStatus ==
                                1)
                        ? CustomToolTip(
                            message:
                                '${'This delivery fee includes all the applicable charges on delivery'.tr} ${checkoutController.surgePrice?.customerNote ?? ''}',
                          )
                        : const SizedBox(),
                    const Spacer(),
                    checkoutController.distance == -1
                        ? Text(
                            'Calculating'.tr,
                            style: ralewayRegular.copyWith(color: Colors.red),
                          )
                        : (deliveryCharge == 0 ||
                                (couponController.coupon != null &&
                                    couponController.coupon!.couponType ==
                                        'free_delivery'))
                            ? Text(
                                'Free'.tr,
                                style: ralewayRegular.copyWith(
                                    color: Theme.of(context).primaryColor),
                              )
                            : Text(
                                '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                style: ralewayRegular,
                                textDirection: TextDirection.ltr,
                              ),
                  ]),
            SizedBox(
                height: Get.find<SplashController>()
                            .configModel!
                            .additionalChargeStatus! &&
                        !(AuthHelper.isGuestLoggedIn() &&
                            checkoutController.guestAddress == null)
                    ? Dimensions.paddingSizeSmall
                    : 0),
            Get.find<SplashController>().configModel!.additionalChargeStatus!
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              Get.find<SplashController>().configModel!.additionalChargeName!,
                              style: ralewayRegular,
                            ),
                          ),
                          Text(
                            '(+) ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.additionCharge!)}',
                            style: ralewayRegular,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                      if (Get.find<SplashController>().activeAdditionalCharges != null &&
                          Get.find<SplashController>().activeAdditionalCharges!.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Get.find<SplashController>().activeAdditionalCharges!.length,
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      Get.find<SplashController>().activeAdditionalCharges![index].chargeName!,
                                      style: ralewayRegular,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Text(
                                    '(+) ${PriceConverter.convertPrice(Get.find<SplashController>().activeAdditionalCharges![index].chargeAmount)}',
                                    style: ralewayRegular,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(
                height: checkoutController.isPartialPay
                    ? Dimensions.paddingSizeSmall
                    : 0),
            checkoutController.isPartialPay
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('Paid by wallet'.tr, style: ralewayRegular),
                        Text(
                            '(-) ${PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance!)}',
                            style: ralewayRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            SizedBox(
                height: checkoutController.isPartialPay
                    ? Dimensions.paddingSizeSmall
                    : 0),
            checkoutController.isPartialPay
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                          'Due payment'.tr,
                          style: ralewayMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: !ResponsiveHelper.isDesktop(context)
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color
                                  : Theme.of(context).primaryColor),
                        ),
                        PriceConverter.convertAnimationPrice(
                          checkoutController.viewTotalPrice,
                          textStyle: ralewayMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: !ResponsiveHelper.isDesktop(context)
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color
                                  : Theme.of(context).primaryColor),
                        )
                      ])
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              child: Divider(
                  thickness: 1,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    ]);
  }
}
