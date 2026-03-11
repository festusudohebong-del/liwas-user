import 'package:liwas_user/features/store/controllers/store_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/favourite/controllers/favourite_controller.dart';
import 'package:liwas_user/features/address/domain/models/address_model.dart';
import 'package:liwas_user/features/store/domain/models/store_model.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreDescriptionViewWidget extends StatelessWidget {
  final Store? store;
  const StoreDescriptionViewWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = Get.find<StoreController>().isStoreOpenNow(store!.active!, store!.schedules);
    Color? textColor = ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    // Module? moduleData;
    // for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
    //   for(Modules m in zData.modules!) {
    //     if(m.id == Get.find<SplashController>().module!.id) {
    //       moduleData = m as Module?;
    //       break;
    //     }
    //   }
    // }
    return Column(children: [
      ResponsiveHelper.isDesktop(context) ? Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Stack(children: [
            CustomImage(
              image: '${store!.logoFullUrl}',
              height: ResponsiveHelper.isDesktop(context) ? 140 : 60, width: ResponsiveHelper.isDesktop(context) ? 140 : 70, fit: BoxFit.cover,
            ),
            isAvailable ? const SizedBox() : Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                child: Text(
                  'Closed now'.tr, textAlign: TextAlign.center,
                  style: ralewayRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(
              store!.name!, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: textColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            // ResponsiveHelper.isDesktop(context) ? InkWell(
            //   onTap: () => Get.toNamed(RouteHelper.getSearchStoreItemRoute(store!.id)),
            //   child: ResponsiveHelper.isDesktop(context) ? Container(
            //     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).primaryColor),
            //     child: const Center(child: Icon(Icons.search, color: Colors.white)),
            //   ) : Icon(Icons.search, color: Theme.of(context).primaryColor),
            // ) : const SizedBox(),
            // const SizedBox(width: Dimensions.paddingSizeSmall),
            GetBuilder<FavouriteController>(builder: (favouriteController) {
              bool isWished = favouriteController.wishStoreIdList.contains(store!.id);
              return InkWell(
                onTap: () {
                  if(AuthHelper.isLoggedIn()) {
                    isWished ? favouriteController.removeFromFavouriteList(store!.id, true)
                        : favouriteController.addToFavouriteList(null, store?.id, true);
                  }else {
                    showCustomSnackBar('You are not logged in'.tr);
                  }
                },
                child: ResponsiveHelper.isDesktop(context) ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), border : Border.all(color: Colors.white)),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(isWished ? Icons.favorite : Icons.favorite_border, color: Colors.white, size: 14),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('Wish list'.tr, style: ralewayRegular.copyWith(fontWeight: FontWeight.w200, color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
                      ],
                    ),
                  ),
                ) : Icon(
                  isWished ? Icons.favorite : Icons.favorite_border,
                  color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                ),
              );
            }),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(children: [
            Expanded(
              child: Text(
                store!.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ),

            AppConstants.webHostedUrl.isNotEmpty ? InkWell(
              onTap: () {
                Get.find<StoreController>().shareStore();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: const Icon(Icons.share, size: 24, color: Colors.white),
              ),
            ) : const SizedBox(),
          ]),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

          Row(children: [
            Text('Minimum order amount'.tr, style: ralewayRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
            )),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Expanded(child: Text(
              PriceConverter.convertPrice(store!.minimumOrder), textDirection: TextDirection.ltr,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
            )),
          ]),
        ])),

      ]) : const SizedBox(),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? 30 : Dimensions.paddingSizeSmall),

     ResponsiveHelper.isDesktop(context) ?
     IntrinsicHeight(
       child: Row(children: [
         const Expanded(child: SizedBox()),
         InkWell(
           onTap: () => Get.toNamed(RouteHelper.getStoreReviewRoute(store!.id, store!.name, store!)),
           child: Column(children: [
             Row(children: [
               Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
               const SizedBox(width: Dimensions.paddingSizeExtraSmall),
               Text(
                 store!.avgRating!.toStringAsFixed(1),
                 style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
               ),
             ]),
             const SizedBox(height: Dimensions.paddingSizeExtraSmall),
             Text(
               '${store!.ratingCount} + ${'Ratings'.tr}',
               style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
             ),
           ]),
         ),
         const Expanded(child: SizedBox()),

         const VerticalDivider(color: Colors.white, thickness: 1),
         const Expanded(child: SizedBox()),

         InkWell(
           onTap: () => Get.toNamed(RouteHelper.getMapRoute(
               AddressModel(id: store!.id, address: store!.address, latitude: store!.latitude,
                 longitude: store!.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
               ), 'store', Get.find<SplashController>().getModuleConfig(Get.find<SplashController>().module!.moduleType!).newVariation!,
             storeName: store!.name,
           )),
           child: Column(children: [
             // Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
             Image.asset(Images.storeLocationIcon, height: 20, width: 20),
             const SizedBox(height: Dimensions.paddingSizeExtraSmall),
             Text('Location'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
           ]),
         ),
         const Expanded(child: SizedBox()),
         const VerticalDivider(color: Colors.white, thickness: 1),
         const Expanded(child: SizedBox()),

         Column(children: [
           Image.asset(Images.storeDeliveryTimeIcon, height: 20, width: 20),
           const SizedBox(height: Dimensions.paddingSizeExtraSmall),

           Text(store!.deliveryTime!, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
         ]),

         (store!.delivery! && store!.freeDelivery!) ? const Expanded(child: SizedBox()) : const SizedBox(),
         (store!.delivery! && store!.freeDelivery!) ? const VerticalDivider(color: Colors.white, thickness: 1) : const SizedBox(),
         (store!.delivery! && store!.freeDelivery!) ? const Expanded(child: SizedBox()) : const SizedBox(),

         (store!.delivery! && store!.freeDelivery!) ? Column(children: [
           Icon(Icons.money_off, color: Theme.of(context).primaryColor, size: 20),
           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
           Text('Free delivery'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
         ]) : const SizedBox(),
         const Expanded(child: SizedBox()),
       ]),
     ):
     Row(children: [
       const Expanded(child: SizedBox()),
       InkWell(
         onTap: () => Get.toNamed(RouteHelper.getStoreReviewRoute(store!.id, store!.name, store!)),
         child: Column(children: [
           Row(children: [
             Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
             const SizedBox(width: Dimensions.paddingSizeExtraSmall),
             Text(
               store!.avgRating!.toStringAsFixed(1),
               style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
             ),
           ]),
           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
           Text(
             '${store!.ratingCount} + ${'Ratings'.tr}',
             style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
           ),
         ]),
       ),
       const Expanded(child: SizedBox()),


       InkWell(
         onTap: () => Get.toNamed(RouteHelper.getMapRoute(
           AddressModel(id: store!.id, address: store!.address, latitude: store!.latitude,
             longitude: store!.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
           ), 'store', Get.find<SplashController>().getModuleConfig(Get.find<SplashController>().module!.moduleType!).newVariation!,
           storeName: store!.name,
         )),
         child: Column(children: [
           Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
           Text('Location'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
         ]),
       ),
       const Expanded(child: SizedBox()),

       Column(children: [
         Row(children: [
           Icon(Icons.timer, color: Theme.of(context).primaryColor, size: 20),
           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
           Text(
             store!.deliveryTime!,
             style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
           ),
         ]),
         const SizedBox(width: Dimensions.paddingSizeExtraSmall),
         Text('Delivery time'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
       ]),
       (store!.delivery! && store!.freeDelivery!) ? const Expanded(child: SizedBox()) : const SizedBox(),
       (store!.delivery! && store!.freeDelivery!) ? Column(children: [
         Icon(Icons.money_off, color: Theme.of(context).primaryColor, size: 20),
         const SizedBox(width: Dimensions.paddingSizeExtraSmall),
         Text('Free delivery'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
       ]) : const SizedBox(),
       const Expanded(child: SizedBox()),
     ]),


    ]);
  }
}
