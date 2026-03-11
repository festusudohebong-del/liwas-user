import 'package:liwas_user/features/auth/controllers/auth_controller.dart';
import 'package:liwas_user/features/location/controllers/location_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/onboard/controllers/onboard_controller.dart';
import 'package:liwas_user/helper/address_helper.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Get.find<OnBoardingController>().getOnBoardingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      body: GetBuilder<OnBoardingController>(
        builder: (onBoardingController) {
          bool isNotLastPage = onBoardingController.selectedIndex <
              onBoardingController.onBoardingList.length - 1;

          return onBoardingController.onBoardingList.isNotEmpty
              ? Column(children: [
                  if (!ResponsiveHelper.isDesktop(context))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraLarge),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isNotLastPage)
                            TextButton(
                              onPressed: _configureToRouteInitialPage,
                              child: Text(
                                'Skip'.tr,
                                style: ralewayMedium.copyWith(
                                    color: Theme.of(context).disabledColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                  Expanded(
                      child: PageView.builder(
                    itemCount: onBoardingController.onBoardingList.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      onBoardingController.changeSelectIndex(index);
                      if (onBoardingController.selectedIndex ==
                          onBoardingController.onBoardingList.length - 1) {
                        _configureToRouteInitialPage();
                      }
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraLarge),
                        child: Column(children: [
                          const Spacer(),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            height: onBoardingController.selectedIndex == index
                                ? context.height * 0.4
                                : context.height * 0.35,
                            child: Image.asset(
                              onBoardingController
                                  .onBoardingList[index].imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Text(
                            onBoardingController.onBoardingList[index].title,
                            style: ralewayBold.copyWith(
                                fontSize: 24,
                                color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Text(
                            onBoardingController
                                .onBoardingList[index].description,
                            style: ralewayRegular.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).disabledColor),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(flex: 2),
                        ]),
                      );
                    },
                  )),
                  if (isNotLastPage)
                    Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraLarge),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmoothPageIndicator(
                            controller: _pageController,
                            count:
                                onBoardingController.onBoardingList.length - 1,
                            effect: ExpandingDotsEffect(
                              activeDotColor: Theme.of(context).primaryColor,
                              dotColor: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.2),
                              dotHeight: 8,
                              dotWidth: 8,
                              expansionFactor: 4,
                              spacing: 8,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (onBoardingController.selectedIndex <
                                  onBoardingController.onBoardingList.length -
                                      2) {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                              } else {
                                _configureToRouteInitialPage();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ])
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _configureToRouteInitialPage() async {
    Get.find<SplashController>().disableIntro();
    await Get.find<AuthController>().guestLogin();
    if (AddressHelper.getUserAddressFromSharedPref() != null) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.find<LocationController>()
          .navigateToLocationScreen(RouteHelper.onBoarding, offNamed: true)
          .then((v) {
        _pageController.jumpToPage(
            Get.find<OnBoardingController>().onBoardingList.length - 2);
      });
    }
  }
}
