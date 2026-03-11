import 'package:liwas_user/features/store/controllers/store_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';
import 'package:liwas_user/util/styles.dart';

class AllStoreScreen extends StatefulWidget {
  final bool isPopular;
  final bool isFeatured;
  final bool isNearbyStore;
  final bool isTopOfferStore;
  final bool isRecommendedStore;
  const AllStoreScreen({super.key, required this.isPopular, required this.isFeatured, required this.isNearbyStore, required this.isTopOfferStore, required this.isRecommendedStore});

  @override
  State<AllStoreScreen> createState() => _AllStoreScreenState();
}

class _AllStoreScreenState extends State<AllStoreScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if(widget.isFeatured) {
      Get.find<StoreController>().getFeaturedStoreList();
    }else if(widget.isPopular) {
      Get.find<StoreController>().getPopularStoreList(false, 'all', false);
    }else if(widget.isTopOfferStore) {
      Get.find<StoreController>().getTopOfferStoreList(false, false);
    }else if(widget.isRecommendedStore){
      Get.find<StoreController>().getRecommendedStoreList();
    }else {
      Get.find<StoreController>().getLatestStoreList(false, 'all', false);
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    return GetBuilder<StoreController>(builder: (storeController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.isFeatured ? 'Featured stores'.tr :  widget.isPopular
            ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
            ? widget.isNearbyStore ? 'Best store nearby'.tr : 'Popular restaurants'.tr : widget.isNearbyStore ? 'Best store nearby'.tr : 'Popular stores'.tr
              : widget.isTopOfferStore ? 'Top offers near me'.tr : widget.isRecommendedStore ? 'Recommended store'.tr : '${'New on'.tr} ${AppConstants.appName}',
          type: widget.isFeatured ? null : storeController.type,
          onVegFilterTap: widget.isRecommendedStore ? null : (String type) {
            if(widget.isPopular) {
              Get.find<StoreController>().getPopularStoreList(true, type, true);
            }else {
              Get.find<StoreController>().getLatestStoreList(true, type, true);
            }
          },
        ),
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        body: RefreshIndicator(
          onRefresh: () async {
            if(widget.isFeatured) {
              await Get.find<StoreController>().getFeaturedStoreList();
            }else if(widget.isPopular) {
              await Get.find<StoreController>().getPopularStoreList(
                true, Get.find<StoreController>().type, false,
              );
            }else if(widget.isRecommendedStore){
              await Get.find<StoreController>().getRecommendedStoreList();
            }else {
              await Get.find<StoreController>().getLatestStoreList(
                true, Get.find<StoreController>().type, false,
              );
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
              child: FooterView(
                child: Column(children: [

                  widget.isTopOfferStore && ResponsiveHelper.isDesktop(context) ? Container(
                    height: 64,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                      SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Row(children: [
                          const Spacer(),

                          Text('Top offers near me'.tr, style: ralewayMedium),
                          const Spacer(),

                          PopupMenuButton(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 'asc',
                                  child: Text('Sort by a to z'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                ),
                                PopupMenuItem(
                                  value: 'desc',
                                  child: Text('Sort by z to a'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                ),
                              ];
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            child: const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(Icons.sync_alt, size: 20),
                            ),
                            onSelected: (dynamic value) => storeController.setTopOfferSort(value),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeLarge),

                          isFood ? PopupMenuButton(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: '1',
                                  child: Text('Only halal'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                ),
                                PopupMenuItem(
                                  value: 'veg',
                                  child: Text('Only veg'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                ),
                                PopupMenuItem(
                                  value: 'non_veg',
                                  child: Text('Only non veg'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                ),
                              ];
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            child: const Icon(Icons.tune, size: 20),
                            onSelected: (dynamic value) => storeController.setTopOfferFilter(value),
                          ) : const SizedBox(),
                          SizedBox(width: isFood ? Dimensions.paddingSizeDefault : 0),

                        ]),
                      ),

                    ]),
                  ) : WebScreenTitleWidget(title: widget.isFeatured ? 'Featured stores'.tr :
                   widget.isPopular ? widget.isNearbyStore ? 'Best store nearby'.tr : Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'Popular restaurants'.tr :
                   'Popular stores'.tr : widget.isTopOfferStore ? 'Top offers near me'.tr : widget.isNearbyStore ? 'Best store nearby'.tr : '${'New on'.tr} ${AppConstants.appName}',
                  ),

                  SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: GetBuilder<StoreController>(builder: (storeController) {
                      return ItemsView(
                        isStore: true, items: null, isFeatured: widget.isFeatured,
                        noDataText: widget.isFeatured ? 'No store available'.tr : Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'No restaurant available'.tr : 'No store available'.tr,
                        stores: widget.isFeatured ? storeController.featuredStoreList : widget.isPopular ? storeController.popularStoreList : widget.isTopOfferStore ? storeController.topOfferStoreList :
                        widget.isRecommendedStore ? storeController.recommendedStoreList : storeController.latestStoreList,
                      );
                    }),
                  ),

                ]),
              ),
          ),
        ),
      );
    });
  }
}
