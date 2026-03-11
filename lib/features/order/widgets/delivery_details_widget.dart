import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
class DeliveryDetailsWidget extends StatelessWidget {
  final bool from;
  final String? address;
  const DeliveryDetailsWidget({super.key, this.from = true, this.address});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Icon(from ? Icons.store : Icons.location_on, size: 28, color: from ? Colors.blue : Theme.of(context).primaryColor),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(from ? 'From store'.tr : 'To'.tr, style: ralewayMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
          style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor),
        )
      ])),
    ]);
  }
}
