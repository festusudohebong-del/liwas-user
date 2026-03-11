import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/home/widgets/filter_view.dart';
import 'package:liwas_user/features/home/widgets/store_filter_button_widget.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/store/controllers/store_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class AllStoreFilterWidget extends StatelessWidget {
  const AllStoreFilterWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(
      builder: (storeController) {
        return Center(
          child: Container(
            width: Dimensions.webMaxWidth,
            transform: Matrix4.translationValues(0, -2, 0),
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
            child: ResponsiveHelper.isDesktop(context) ? Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'Restaurants'.tr : 'Stores'.tr,
                    style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  Text(
                    '${storeController.storeModel?.totalSize ?? 0} ${Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'Restaurants near you'.tr : 'Stores near you'.tr}',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  ),

                ]),
              ),

              const SizedBox(width: Dimensions.paddingSizeSmall),

              filter(context, storeController),
            ]) : Column(children: [

              Padding(
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                  Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'Restaurants'.tr : 'Stores'.tr,
                    style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                  Flexible(
                    child: Text(
                      '${storeController.storeModel?.totalSize ?? 0} ${Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'Restaurants near you'.tr : 'Stores near you'.tr}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              filter(context, storeController),
            ]),
          ),
        );
      }
    );
  }

  Widget filter(BuildContext context, StoreController storeController) {
    return SizedBox(
      height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: EdgeInsets.zero,

          children: [
            ResponsiveHelper.isDesktop(context) ? const SizedBox() : FilterView(storeController: storeController),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            StoreFilterButtonWidget(
              buttonText: 'All'.tr,
              onTap: () => storeController.setStoreType('all'),
              isSelected: storeController.storeType == 'all',
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            StoreFilterButtonWidget(
              buttonText: 'Newly joined'.tr,
              onTap: () => storeController.setStoreType('newly_joined'),
              isSelected: storeController.storeType == 'newly_joined',
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            StoreFilterButtonWidget(
              buttonText: 'Popular'.tr,
              onTap: () => storeController.setStoreType('popular'),
              isSelected: storeController.storeType == 'popular',
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            StoreFilterButtonWidget(
              buttonText: 'Top rated'.tr,
              onTap: () => storeController.setStoreType('top_rated'),
              isSelected: storeController.storeType == 'top_rated',
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),


            ResponsiveHelper.isDesktop(context) ? FilterView(storeController: storeController) : const SizedBox(),

          ],
        ),
      ),
    );
  }
}
