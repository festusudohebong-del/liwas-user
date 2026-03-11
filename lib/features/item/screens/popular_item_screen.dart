import 'package:flutter/cupertino.dart';
import 'package:liwas_user/common/enums/data_source_enum.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/features/item/controllers/item_controller.dart';
import 'package:liwas_user/features/item/widgets/item_view_all_filter_bottom_sheet.dart';
import 'package:liwas_user/features/item/widgets/item_view_all_sort_bottom_sheet.dart';
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
import 'package:liwas_user/util/styles.dart';

class PopularItemScreen extends StatefulWidget {
  final bool isPopular;
  final bool isSpecial;
  const PopularItemScreen({super.key, required this.isPopular, required this.isSpecial});

  @override
  State<PopularItemScreen> createState() => _PopularItemScreenState();
}

class _PopularItemScreenState extends State<PopularItemScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ItemController itemController = Get.find<ItemController>();
    itemController.setOffset(1);
    itemController.clearFilters(isPopular: widget.isPopular, isSpecial: widget.isSpecial);
    itemController.clearSearch(withUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    bool isShop = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.ecommerce;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.find<ItemController>().resetFilters(isPopular: widget.isPopular, isSpecial: widget.isSpecial);
        Get.find<ItemController>().clearSearch();
      },
      child: GetBuilder<ItemController>(builder: (itemController) {
        return Scaffold(
          appBar: CustomAppBar(
            key: scaffoldKey,
            title: widget.isPopular ? isShop ? 'Most popular products'.tr : 'Most popular items'.tr : widget.isSpecial ? 'Special offer'.tr : 'Best reviewed item'.tr,
            showCart: true,
            type: widget.isPopular ? itemController.popularType : widget.isSpecial ? itemController.discountedType : itemController.reviewType,
            onVegFilterTap: (String type) {
              if(widget.isPopular) {
                itemController.getPopularItemList(notify: true, offset: '1');
              }else if(widget.isSpecial){
                itemController.getDiscountedItemList(notify: true, offset: '1');
              }else {
                itemController.getReviewedItemList(notify: true, offset: '1');
              }
            },
          ),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: SingleChildScrollView(child: FooterView(child: Column(children: [

            ResponsiveHelper.isDesktop(context) ? Container(
            height: 64,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
            alignment: Alignment.center,
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Stack(alignment: Alignment.center, children: [

                  Center(
                    child: Text(
                      widget.isPopular ? isShop ? 'Most popular products'.tr : 'Most popular items'.tr : widget.isSpecial ? 'Special offer'.tr : 'Best reviewed item'.tr,
                      style: ralewayMedium,
                    ),
                  ),

                  Positioned(
                    right: 10,
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Get.dialog(Dialog(
                            child: ItemViewAllSortBottomSheet(
                              isPopular: widget.isPopular,
                              isSpecial: widget.isSpecial,
                              fromDialog: true,
                            ),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).hintColor),
                          ),
                          child: Icon(CupertinoIcons.sort_down, color: Theme.of(context).hintColor, size: 18),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      InkWell(
                        onTap: () {
                          List<double?> prices = [];
                          for (var product in itemController.discountedItemList!) {
                            prices.add(product.price);
                          }
                          prices.sort();
                          double? maxValue = prices.isNotEmpty ? prices.last : 99999999;

                          Get.dialog(Dialog(
                            child: ItemViewAllFilterBottomSheet(
                              maxValue: maxValue,
                              isPopular: widget.isPopular,
                              isSpecial: widget.isSpecial,
                              fromDialog: true,
                            ),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).primaryColor),
                          ),
                          child: Icon(Icons.filter_list, color: Theme.of(context).primaryColor, size: 18),
                        ),
                      ),
                    ]),
                  ),

                ]),
              ),
            ),
          ) : const SizedBox(),

            SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(children: [
                ItemsView(
                  isStore: false, stores: null,
                  items: widget.isPopular ? itemController.popularItemList : widget.isSpecial ? itemController.discountedItemList : itemController.reviewedItemList,
                ),

                if (itemController.hasMoreData(isPopular: widget.isPopular, isSpecial: widget.isSpecial))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: CustomButton(
                    buttonText: 'View more'.tr,
                    width: 180,
                    isLoading: itemController.isLoading,
                    onPressed: () {
                      itemController.setOffset(itemController.offset + 1);

                      itemController.showBottomLoader();

                      if (widget.isPopular) {
                        itemController.getPopularItemList(dataSource: DataSourceEnum.client, offset: itemController.offset.toString());
                      } else if (widget.isSpecial) {
                        itemController.getDiscountedItemList(dataSource: DataSourceEnum.client, offset: itemController.offset.toString());
                      } else {
                        itemController.getReviewedItemList(dataSource: DataSourceEnum.client, offset: itemController.offset.toString());
                      }
                    },
                  ),
                ),
              ]),
            ),

          ]))),
        );
      }),
    );
  }
}
