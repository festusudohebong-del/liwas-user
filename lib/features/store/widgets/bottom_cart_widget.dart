import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/cart/controllers/cart_controller.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';

class BottomCartWidget extends StatelessWidget {
  const BottomCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
        return Container(
          height: GetPlatform.isIOS ? 100 : 70, width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge,/* vertical: Dimensions.PADDING_SIZE_SMALL*/),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: const Color(0xFF2A2A2A).withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${'Item'.tr}: ${cartController.cartList.length}', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [
                Text(
                  '${'Total'.tr}: ',
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                ),

                Text(
                  PriceConverter.convertPrice(cartController.calculationCart()),
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                ),
              ]),
            ]),

            CustomButton(buttonText: 'View cart'.tr,width: 130,height: 45, onPressed: () => Get.toNamed(RouteHelper.getCartRoute()))
          ]),
        );
      });
  }
}
