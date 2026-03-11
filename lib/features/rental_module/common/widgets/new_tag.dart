import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class NewTag extends StatelessWidget {
  final int? isNew;
  const NewTag({super.key, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return isNew == 1 ? Container(
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.radiusDefault)),
        // borderRadius: BorderRadius.horizontal(right: Radius.circular(Dimensions.radiusSmall)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
      child: Text('new'.tr, style: ralewayMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall)),
    ) : const SizedBox();
  }
}
