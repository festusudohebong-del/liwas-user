import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/common/controllers/theme_controller.dart';
import 'package:liwas_user/features/coupon/domain/models/coupon_model.dart';
import 'package:liwas_user/helper/date_converter.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponModel coupon;
  final int index;
  final List<JustTheController>? toolTipController;
  const CouponCardWidget({super.key, required this.coupon, required this.index, this.toolTipController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(color: Get.isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
      ),
      child: Stack(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Transform.rotate(
            angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
            child: Image.asset(
              Get.find<ThemeController>().darkTheme ? Images.couponBgDark : Images.couponBgLight,
              height: ResponsiveHelper.isMobilePhone() ? 160 : 150, width: size.width,
              fit: ResponsiveHelper.isMobilePhone() ? BoxFit.cover : BoxFit.contain,
            ),
          ),
        ),

        Container(
          alignment: Alignment.center,
          child: Row(children: [

            Container(
              alignment: Alignment.center,

              width: ResponsiveHelper.isDesktop(context) ? 150 : size.width * 0.3,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(
                  coupon.discountType == 'percent' ? Images.percentCouponOffer : coupon.couponType
                      == 'free_delivery' ? Images.freeDelivery : Images.money,
                  height: 25, width: 25,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(
                  '${coupon.discount}${coupon.discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} ${'Off'.tr}',
                  style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                coupon.store == null ?  Flexible(child: Text(
                  coupon.couponType == 'store_wise' ? '${'On'.tr} ${coupon.data}' : 'On all store'.tr,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )) : Flexible(child: Text(
                  coupon.couponType == 'default' ? '${coupon.store!.name}' : '',
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )),
              ]),
            ),
            SizedBox(width: ResponsiveHelper.isDesktop(context) ? 10 : 20),

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

                JustTheTooltip(
                  backgroundColor: Get.find<ThemeController>().darkTheme ? Theme.of(context).cardColor : Colors.black87,
                  controller: toolTipController?[index],
                  preferredDirection: AxisDirection.up,
                  tailLength: 14,
                  tailBaseWidth: 20,
                  triggerMode: TooltipTriggerMode.manual,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${'Code copied'.tr} !',style: ralewayRegular.copyWith(color: Theme.of(context).cardColor)),
                  ),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: Colors.blueAccent,
                      strokeWidth: 1,
                      strokeCap: StrokeCap.butt,
                      dashPattern: const [5, 5],
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                      radius: const Radius.circular(50),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [

                      Text(
                        '${coupon.code}',
                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Icon(Icons.copy_rounded, color: Colors.blueAccent, size: 20),

                    ]),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  '${DateConverter.stringDateTimeToDate(coupon.startDate!)} - ${DateConverter.stringDateTimeToDate(coupon.expireDate!)}',
                  style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text('*', style: ralewayRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall)),

                  Text(
                    '${'Min purchase'.tr} ',
                    style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    PriceConverter.convertPrice(coupon.minPurchase),
                    style: ralewayMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                  ),

                ]),

              ]),
            ),

          ]),
        ),

      ]),
    );
  }
}
