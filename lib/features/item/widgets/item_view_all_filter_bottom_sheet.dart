import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/features/item/controllers/item_controller.dart';
import 'package:liwas_user/features/search/widgets/custom_check_box_widget.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class ItemViewAllFilterBottomSheet extends StatelessWidget {
  final double? maxValue;
  final bool isPopular;
  final bool isSpecial;
  final bool fromDialog;
  const ItemViewAllFilterBottomSheet({super.key, this.maxValue, required this.isPopular, required this.isSpecial, this.fromDialog = false});

  @override
  Widget build(BuildContext context) {

    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    return GetBuilder<ItemController>(builder: (itemController) {

      double lowerValue = itemController.selectedMinPrice.clamp(0, maxValue!);
      double upperValue = itemController.selectedMaxPrice.clamp(0, maxValue!);

      return Container(
        height: fromDialog ? 600 : null,
        width: fromDialog ? 475 : context.width > 700 ? 700 : context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(Dimensions.radiusExtraLarge),
            topRight: const Radius.circular(Dimensions.radiusExtraLarge),
            bottomLeft: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
            bottomRight: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: fromDialog ? 0 : Dimensions.paddingSizeLarge),

          ResponsiveHelper.isDesktop(context) ? Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.clear),
            ),
          ) : Align(
            alignment: Alignment.center,
            child: Container(
              height: 5, width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Align(
            alignment: Alignment.center,
            child: Text('Filter data'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,  mainAxisSize: MainAxisSize.min, children: [

                  Text('Price'.tr, style: ralewayBold),

                  RangeSlider(
                    values: RangeValues(lowerValue, upperValue),
                    min: 0,
                    max: maxValue!.toDouble(),
                    divisions: maxValue!.toInt(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    labels: RangeLabels(lowerValue.toString(), upperValue.toString()),
                    onChanged: (RangeValues values) {
                      itemController.setMinAndMaxPrice(values.start, values.end);
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('Status'.tr, style: ralewayBold),

                  SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [

                        if (isFood) ...[
                          CustomCheckBoxWidget(
                            title: 'Available'.tr,
                            value: itemController.isAvailableItems,
                            onClick: () {
                              itemController.toggleAvailableItems();
                            },
                          ),
                          const SizedBox(width: Dimensions.paddingSizeLarge),

                          CustomCheckBoxWidget(
                            title: 'unavailable'.tr,
                            value: itemController.isUnAvailableItems,
                            onClick: () {
                              itemController.toggleUnavailableItems();
                            },
                          ),
                          const SizedBox(width: Dimensions.paddingSizeLarge),
                        ],

                        CustomCheckBoxWidget(
                          title: 'Top rated'.tr,
                          value: itemController.isTopRated,
                          onClick: () {
                            itemController.toggleTopRated();
                          },
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomCheckBoxWidget(
                          title: 'Most loved'.tr,
                          value: itemController.isMostLoved,
                          onClick: () {
                            itemController.toggleMostLoved();
                          },
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomCheckBoxWidget(
                          title: 'Popular'.tr,
                          value: itemController.isPopular,
                          onClick: () {
                            itemController.togglePopular();
                          },
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomCheckBoxWidget(
                          title: 'latest'.tr,
                          value: itemController.isLatest,
                          onClick: () {
                            itemController.toggleLatest();
                          },
                        ),

                      ]),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('Ratings'.tr, style: ralewayBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ...List.generate(5, (index) {
                    int rating = 5 - index;
                    return InkWell(
                      onTap: () => itemController.setSelectedRating(rating),
                      child: Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall + 2, bottom: Dimensions.paddingSizeSmall + 2, right: Dimensions.paddingSizeExtraSmall),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text(
                            '${rating == 5 ? '5' : '$rating +'} ${'Rating'.tr}',
                            style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: itemController.rating == rating ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor),
                          ),

                          Icon(
                            itemController.rating == rating ? Icons.check_circle : Icons.circle_outlined,
                            size: 22, color: itemController.rating == rating ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
                          ),

                        ]),
                      ),
                    );

                  }),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('Categories'.tr, style: ralewayBold),
                  if (itemController.categoryList == null)
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                  else if (itemController.categoryList!.isEmpty)
                    Center(child: Text('No category found'.tr))
                  else
                  ...itemController.categoryList!.map((cat) {
                    return CheckboxListTile(
                      title: Text(cat.name ?? '', style: ralewayRegular),
                      contentPadding: EdgeInsets.zero,
                      side: BorderSide(
                        color: itemController.selectedCategoryIds.contains(cat.id) ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
                      ),
                      value: itemController.selectedCategoryIds.contains(cat.id),
                      onChanged: (_) => itemController.toggleCategory(cat.id),
                    );
                  }),

                ]),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeDefault,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
                bottomRight: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'Reset'.tr,
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      itemController.resetFilters(isPopular: isPopular, isSpecial: isSpecial);
                      Navigator.pop(context);
                    }
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: CustomButton(
                    buttonText: 'Filter'.tr,
                    onPressed: () {
                      itemController.applyFilters(isPopular: isPopular, isSpecial: isSpecial);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }
}

