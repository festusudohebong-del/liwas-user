import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/rental_module/common/models/taxi_coupon_model.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class CouponCard extends StatelessWidget {
  final TaxiCouponModel couponModel;
  final bool? fromCouponScreen;
  final bool? fromBottomSheet;

  const CouponCard({super.key, required this.couponModel, this.fromCouponScreen = false, this.fromBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: fromCouponScreen! ? 0 :Dimensions.paddingSizeDefault, bottom: fromCouponScreen! ? Dimensions.paddingSizeSmall : 0),
      child: Stack(children: [

        Container(
          height: 80, width: fromCouponScreen! ? double.infinity : 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: fromCouponScreen! ? [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), blurRadius: 10)] : null,
          ),
          child: Stack(
            children: [
              Transform.rotate(
                angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
                child: CustomAssetImageWidget(fromCouponScreen! ? Images.taxiCouponSvg2 : Images.taxiCouponSvg, color: Theme.of(context).cardColor, width: double.infinity, fit: BoxFit.fill),
              ),

              InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  if(fromBottomSheet!) {
                    Get.back(result: couponModel.code??'');
                  } else {
                    Clipboard.setData(ClipboardData(text: couponModel.code!));
                    showCustomSnackBar('Coupon code copied'.tr, isError: false, getXSnackBar: fromBottomSheet!);
                  }
                },
                child: Row(children: [

                  Expanded(flex: 8, child: Container(
                    padding: EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeLarge : 0 , right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeLarge),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('${'code'.tr}: ', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        Text(couponModel.code??'', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                        '${couponModel.discount}${couponModel.discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} ${'Off'.tr}',
                        style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  )),
                  Expanded(flex: 3,child: Padding(
                    padding: EdgeInsets.only(left: fromCouponScreen! ? Dimensions.paddingSizeLarge : 0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: couponModel.code!));
                        showCustomSnackBar('Coupon code copied'.tr, isError: false, getXSnackBar: fromBottomSheet!);
                      },
                      child: Image.asset(Images.taxiCopyIcon, height: 25, width: 25),
                    ),
                  )),
                ]),
              ),
            ],
          ),
        ),

      ]),
    );
  }
}
