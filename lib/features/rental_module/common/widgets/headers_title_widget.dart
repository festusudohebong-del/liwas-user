import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/util/styles.dart';

import '../../../../util/dimensions.dart';

class HeadersTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;

  const HeadersTitleWidget({super.key, required this.title, this.onSeeAllPressed});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Text(title, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

      onSeeAllPressed != null ? TextButton(
        onPressed: onSeeAllPressed, child: Text('See all'.tr, style: TextStyle(color: Theme.of(context).primaryColor)),
      ) : const SizedBox(height: Dimensions.paddingSizeExtraOverLarge,),

    ]);
  }
}
