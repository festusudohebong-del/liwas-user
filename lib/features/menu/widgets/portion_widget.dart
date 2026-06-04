import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class PortionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool hideDivider;
  final String route;
  final String? suffix;
  final Function()? onTap;
  const PortionWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.route,
      this.hideDivider = false,
      this.suffix,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => Get.toNamed(route),
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimensions.paddingSizeSmall + 4),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusMedium),
                    ),
                    child: Image.asset(
                      icon,
                      height: 20,
                      width: 20,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(
                    child: Text(
                      title,
                      style: ralewayMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: theme.textTheme.bodyLarge?.color ??
                            (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                  if (suffix != null)
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall,
                        horizontal: Dimensions.paddingSizeSmall,
                      ),
                      child: Text(
                        suffix!,
                        style: ralewayRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.white,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: theme.disabledColor.withOpacity(0.5),
                    ),
                ],
              ),
            ),
            if (!hideDivider) ...[
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: theme.dividerColor.withOpacity(0.4),
              ),
            ],
            const SizedBox(height: Dimensions.paddingSizeSmall + 4),
          ],
        ),
      ),
    );
  }
}
