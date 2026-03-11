import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/cart/controllers/cart_controller.dart';
import 'package:liwas_user/features/store/controllers/store_controller.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class ExtraPackagingWidget extends StatelessWidget {
  final CartController cartController;
  const ExtraPackagingWidget({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return storeController.store?.extraPackagingStatus ?? false ? Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 1))],
        ),
        child: Row(children: [

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Need extra packaging'.tr, style: ralewayMedium),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '(${'additional'.tr}', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall)),
                    TextSpan(text: ' ${PriceConverter.convertPrice(storeController.store?.extraPackagingAmount)} ', style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall)),
                    TextSpan(text: '${'Change will be added for extra packaging'.tr})', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            value: cartController.needExtraPackage,
            onChanged: (bool? isChecked) {
              cartController.toggleExtraPackage();
            },
          ),

        ]),
      ) : const SizedBox();
    });
  }
}
