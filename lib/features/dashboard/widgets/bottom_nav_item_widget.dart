import 'package:flutter/material.dart';
import 'package:liwas_user/util/styles.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String selectedIcon;
  final String unSelectedIcon;
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  const BottomNavItemWidget(
      {super.key,
      this.onTap,
      this.isSelected = false,
      required this.title,
      required this.selectedIcon,
      required this.unSelectedIcon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final unselectedColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : Colors.black.withValues(alpha: 0.7);
    final selectedColor = theme.primaryColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isSelected ? selectedIcon : unSelectedIcon,
              height: 22,
              width: 22,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: (isSelected ? ralewayBold : ralewayRegular).copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: isSelected ? 14 : 0,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
