import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/features/rental_module/home/controllers/taxi_home_controller.dart';
import 'package:liwas_user/features/rental_module/widgets/coupon_card.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class TaxiCouponScreen extends StatefulWidget {
  const TaxiCouponScreen({super.key});

  @override
  State<TaxiCouponScreen> createState() => _TaxiCouponScreenState();
}

class _TaxiCouponScreenState extends State<TaxiCouponScreen> {
  @override
  void initState() {
    super.initState();

    if (AuthHelper.isLoggedIn()) {
      Get.find<TaxiHomeController>().getTaxiCouponList(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Coupon'.tr),
        backgroundColor: Theme.of(context).colorScheme.surface,
      body: GetBuilder<TaxiHomeController>(
        builder: (taxiHomeController) {
          return taxiHomeController.taxiCouponList != null ? taxiHomeController.taxiCouponList!.isNotEmpty
              ? ListView.builder(
                itemCount: taxiHomeController.taxiCouponList!.length,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                  return CouponCard(couponModel: taxiHomeController.taxiCouponList![index], fromCouponScreen: true);
                },
              ) : Column(children: [
            Image.asset(Images.noCoupon, height: 70),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text('No promo available'.tr, style: ralewayMedium),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ]) : const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
