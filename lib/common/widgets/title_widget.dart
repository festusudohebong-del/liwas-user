import 'package:get/get.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function? onTap;
  final String? image;
  const TitleWidget({super.key, required this.title, this.onTap, this.image});

  @override
  Widget build(BuildContext context) {

    final bool ltr = Get.find<LocalizationController>().isLtr;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Text(title, style: ralewayBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeLarge)),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        image != null ? Image.asset(image!, height: 20, width: 20,) : const SizedBox(),
        ],
      ),
      (onTap != null) ? InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: EdgeInsets.fromLTRB(ltr ? 10 : 0, 5, ltr ? 0 : 10, 5),
          child: Text(
            'See all'.tr,
            style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5),
              decoration: TextDecoration.underline, decorationColor: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5), decorationThickness: 1.5,
            ),
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
