// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:liwas_user/common/widgets/login_suggestion_bottomsheet.dart';
import 'package:liwas_user/features/rental_module/common/widgets/taxi_cart_widget.dart';
import 'package:liwas_user/features/dashboard/widgets/store_registration_success_bottom_sheet.dart';
import 'package:liwas_user/features/home/controllers/home_controller.dart';
import 'package:liwas_user/features/location/controllers/location_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/order/controllers/order_controller.dart';
import 'package:liwas_user/features/order/domain/models/order_model.dart';
import 'package:liwas_user/features/address/screens/address_screen.dart';
import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:liwas_user/features/parcel/controllers/parcel_controller.dart';
import 'package:liwas_user/features/store/controllers/store_controller.dart';
import 'package:liwas_user/features/rental_module/rental_cart_screen/taxi_cart_screen.dart';
import 'package:liwas_user/features/rental_module/rental_favourite/screens/vehicle_favourite_screen.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/helper/taxi_helper.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/common/widgets/cart_widget.dart';
import 'package:liwas_user/common/widgets/custom_dialog.dart';
import 'package:liwas_user/features/checkout/widgets/congratulation_dialogue.dart';
import 'package:liwas_user/features/dashboard/widgets/address_bottom_sheet_widget.dart';
import 'package:liwas_user/features/dashboard/widgets/parcel_bottom_sheet_widget.dart';
import 'package:liwas_user/features/favourite/screens/favourite_screen.dart';
import 'package:liwas_user/features/home/screens/home_screen.dart';
import 'package:liwas_user/features/menu/screens/menu_screen.dart';
import 'package:liwas_user/features/order/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen(
      {super.key, required this.pageIndex, this.fromSplash = false});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = AuthHelper.isLoggedIn();

    _showRegistrationSuccessBottomSheet();
    if (!_isLogin &&
        Get.find<SplashController>().showLoginSuggestion() &&
        (GetPlatform.isAndroid || GetPlatform.isIOS)) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.bottomSheet(LoginSuggestionBottomSheet(), isScrollControlled: true)
            .then((v) {
          Get.find<SplashController>().disableLoginSuggestion();
        });
      });
    }

    if (_isLogin) {
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<AuthController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(
            const Duration(seconds: 1),
            () => showAnimatedDialog(
                Get.context!, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1, fromDashboard: true);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      const SizedBox(),
      const OrderScreen(),
      const MenuScreen()
    ];
  }

  void _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet =
        Get.find<HomeController>().getRegistrationSuccessfulSharedPref();
    if (canShowBottomSheet) {
      Future.delayed(const Duration(seconds: 1), () {
        ResponsiveHelper.isDesktop(Get.context)
            ? Get.dialog(
                    const Dialog(child: StoreRegistrationSuccessBottomSheet()))
                .then((value) {
                Get.find<HomeController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<HomeController>()
                    .saveIsStoreRegistrationSharedPref(false);
                setState(() {});
              })
            : showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => const StoreRegistrationSuccessBottomSheet(),
              ).then((value) {
                Get.find<HomeController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<HomeController>()
                    .saveIsStoreRegistrationSharedPref(false);
                setState(() {});
              });
      });
    }
  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<LocationController>().checkLocationActive();
    if (widget.fromSplash &&
        Get.find<LocationController>().showLocationSuggestion &&
        active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheetWidget(),
        ).then((value) {
          Get.find<LocationController>().showSuggestedLocation(false);
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return GetBuilder<SplashController>(builder: (splashController) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (_pageIndex != 0) {
            _setPage(0);
          } else {
            if (!ResponsiveHelper.isDesktop(context) &&
                Get.find<SplashController>().module != null &&
                Get.find<SplashController>().configModel!.module == null) {
              Get.find<SplashController>().setModule(null);
              Get.find<StoreController>().resetStoreData();
            } else {
              if (_canExit) {
                if (GetPlatform.isAndroid) {
                  SystemNavigator.pop();
                } else if (GetPlatform.isIOS) {
                  exit(0);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Back press again to exit'.tr,
                      style: const TextStyle(color: Colors.white)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                ));
                _canExit = true;
                Timer(const Duration(seconds: 2), () {
                  _canExit = false;
                });
              }
            }
          }
        },
        child: GetBuilder<OrderController>(builder: (orderController) {
          List<OrderModel> runningOrder =
              orderController.runningOrderModel != null
                  ? orderController.runningOrderModel!.orders!
                  : [];

          List<OrderModel> reversOrder = List.from(runningOrder.reversed);

          return SafeArea(
            top: false,
            bottom: GetPlatform.isAndroid,
            child: Scaffold(
              key: _scaffoldKey,
              body: ExpandableBottomSheet(
                background: Stack(children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _screens.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _screens[index];
                    },
                  ),
                  ResponsiveHelper.isDesktop(context) || keyboardVisible
                      ? const SizedBox()
                      : Positioned(
                          bottom: 20,
                          left: 15,
                          right: 15,
                          child: GetBuilder<SplashController>(
                              builder: (splashController) {
                            bool isParcel = splashController.module != null &&
                                splashController.configModel!.moduleConfig!
                                    .module!.isParcel!;
                            bool isTaxiWithCache = ((splashController.module !=
                                            null &&
                                        splashController.module!.moduleType
                                                .toString() ==
                                            AppConstants.taxi) ||
                                    (splashController.cacheModule != null &&
                                        splashController.cacheModule!.moduleType
                                                .toString() ==
                                            AppConstants.taxi)) &&
                                TaxiHelper.haveTaxiModule();
                            bool isTaxi = (splashController.module != null &&
                                splashController.module!.moduleType
                                        .toString() ==
                                    AppConstants.taxi);
                            isParcel = isParcel && !isTaxiWithCache;

                            _screens = [
                              const HomeScreen(),
                              isParcel
                                  ? const AddressScreen(fromDashboard: true)
                                  : isTaxi
                                      ? const VehicleFavouriteScreen()
                                      : const FavouriteScreen(),
                              const SizedBox(),
                              OrderScreen(index: isTaxi ? 1 : 0),
                              const MenuScreen()
                            ];
                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;

                            const navBarHeight = 70.0;
                            const navBarBorderRadius =
                                35.0; // Perfect pill shape

                            return SizedBox(
                              height:
                                  100, // Enough height to accommodate the FAB floating
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.bottomCenter,
                                children: [
                                  // Floating glassmorphic nav bar
                                  Positioned(
                                    bottom: 10,
                                    left: 15,
                                    right: 15,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            navBarBorderRadius),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.08),
                                            blurRadius: 20,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                navBarBorderRadius),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 20, sigmaY: 20),
                                              child: Container(
                                                width: double.infinity,
                                                height: navBarHeight,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: navBarHeight,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      navBarBorderRadius),
                                              color: (isDark
                                                      ? Colors.black
                                                      : Colors.white)
                                                  .withValues(alpha: 0.85),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withValues(alpha: 0.3),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                BottomNavItemWidget(
                                                  title: 'Home'.tr,
                                                  selectedIcon: Images.homeIcon,
                                                  unSelectedIcon:
                                                      Images.homeIcon,
                                                  isSelected: _pageIndex == 0,
                                                  onTap: () => _setPage(0),
                                                ),
                                                BottomNavItemWidget(
                                                  title: isParcel
                                                      ? 'Address'.tr
                                                      : isTaxi
                                                          ? 'Wishlist'.tr
                                                          : 'Favourite'.tr,
                                                  selectedIcon: isParcel
                                                      ? Images.addressIcon
                                                      : Images
                                                          .favouriteUnselect,
                                                  unSelectedIcon: isParcel
                                                      ? Images.addressIcon
                                                      : Images
                                                          .favouriteUnselect,
                                                  isSelected: _pageIndex == 1,
                                                  onTap: () => _setPage(1),
                                                ),
                                                const SizedBox(width: 58),
                                                BottomNavItemWidget(
                                                  title: isTaxi
                                                      ? 'Trips'.tr
                                                      : 'Orders'.tr,
                                                  selectedIcon: Images.orders,
                                                  unSelectedIcon: Images.orders,
                                                  isSelected: _pageIndex == 3,
                                                  onTap: () => _setPage(3),
                                                ),
                                                BottomNavItemWidget(
                                                  title: 'Menu'.tr,
                                                  selectedIcon: Images.menu,
                                                  unSelectedIcon: Images.menu,
                                                  isSelected: _pageIndex == 4,
                                                  onTap: () => _setPage(4),
                                                ),
                                              ], // close Row children
                                            ), // close Row
                                          ), // close Container (layer 2)
                                        ], // close Stack children
                                      ), // close Stack
                                    ), // close Container (with shadow)
                                  ), // close Positioned
                                  // Floating Cart Button
                                  Positioned(
                                    bottom:
                                        15, // Center perfectly over the 70px bar (10 bottom + 35 center = 45. FAB is 60 -> 45 - 30 = 15)
                                    child: (ResponsiveHelper.isDesktop(
                                                context) ||
                                            (widget.fromSplash &&
                                                Get.find<LocationController>()
                                                    .showLocationSuggestion &&
                                                active) ||
                                            (orderController.showBottomSheet &&
                                                orderController
                                                        .runningOrderModel !=
                                                    null &&
                                                orderController
                                                    .runningOrderModel!
                                                    .orders!
                                                    .isNotEmpty &&
                                                _isLogin))
                                        ? const SizedBox()
                                        : Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 15,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: FloatingActionButton(
                                              backgroundColor:
                                                  Colors.transparent,
                                              onPressed: () {
                                                if (isParcel) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (con) =>
                                                        ParcelBottomSheetWidget(
                                                      parcelCategoryList: Get.find<
                                                              ParcelController>()
                                                          .parcelCategoryList,
                                                    ),
                                                  );
                                                } else if (isTaxiWithCache) {
                                                  Get.to(() =>
                                                      const TaxiCartScreen());
                                                } else {
                                                  Get.toNamed(RouteHelper
                                                      .getCartRoute());
                                                }
                                              },
                                              elevation: 0,
                                              shape: const CircleBorder(),
                                              child: isTaxiWithCache
                                                  ? TaxiCartWidget(
                                                      color: Colors.white,
                                                      size: 28)
                                                  : isParcel
                                                      ? const Icon(
                                                          CupertinoIcons.add,
                                                          size: 28,
                                                          color: Colors.white)
                                                      : CartWidget(
                                                          color: Colors.white,
                                                          size: 28),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                ]),
                persistentContentHeight: (widget.fromSplash &&
                        Get.find<LocationController>().showLocationSuggestion &&
                        active)
                    ? 0
                    : GetPlatform.isIOS
                        ? 110
                        : 100,
                onIsContractedCallback: () {
                  if (!orderController.showOneOrder) {
                    orderController.showOrders();
                  }
                },
                onIsExtendedCallback: () {
                  if (orderController.showOneOrder) {
                    orderController.showOrders();
                  }
                },
                enableToggle: true,
                expandableContent: (widget.fromSplash &&
                        Get.find<LocationController>().showLocationSuggestion &&
                        active &&
                        !ResponsiveHelper.isDesktop(context))
                    ? const SizedBox()
                    : (ResponsiveHelper.isDesktop(context) ||
                            !_isLogin ||
                            orderController.runningOrderModel == null ||
                            orderController
                                .runningOrderModel!.orders!.isEmpty ||
                            !orderController.showBottomSheet)
                        ? const SizedBox()
                        : Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              if (orderController.showBottomSheet) {
                                orderController.showRunningOrders();
                              }
                            },
                            child: RunningOrderViewWidget(
                                reversOrder: reversOrder,
                                onOrderTap: () {
                                  _setPage(3);
                                  if (orderController.showBottomSheet) {
                                    orderController.showRunningOrders();
                                  }
                                }),
                          ),
              ),
            ),
          );
        }),
      );
    });
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}
