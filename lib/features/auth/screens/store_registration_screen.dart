import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:liwas_user/common/widgets/confirmation_dialog.dart';
import 'package:liwas_user/common/widgets/custom_asset_image_widget.dart';
import 'package:liwas_user/common/widgets/custom_tool_tip_widget.dart';
import 'package:liwas_user/features/auth/widgets/business/base_card_widget.dart';
import 'package:liwas_user/features/auth/widgets/business/web_business_plan_widget.dart';
import 'package:liwas_user/features/auth/widgets/module_view_widget.dart';
import 'package:liwas_user/features/auth/widgets/web_registration_stepper_widget.dart';
import 'package:liwas_user/features/business/widgets/package_card_widget.dart';
import 'package:liwas_user/features/dashboard/screens/dashboard_screen.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/auth/domain/models/store_body_model.dart';
import 'package:liwas_user/common/models/translation.dart';
import 'package:liwas_user/common/models/config_model.dart';
import 'package:liwas_user/features/auth/controllers/store_registration_controller.dart';
import 'package:liwas_user/features/auth/widgets/custom_time_picker_widget.dart';
import 'package:liwas_user/features/auth/widgets/pass_view_widget.dart';
import 'package:liwas_user/features/auth/widgets/select_location_view_widget.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/validate_check.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';

class StoreRegistrationScreen extends StatefulWidget {
  const StoreRegistrationScreen({super.key});

  @override
  State<StoreRegistrationScreen> createState() =>
      _StoreRegistrationScreenState();
}

class _StoreRegistrationScreenState extends State<StoreRegistrationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _nameController = [];
  final List<TextEditingController> _addressController = [];
  final TextEditingController _tinNumberController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final List<FocusNode> _nameFocus = [];
  final List<FocusNode> _addressFocus = [];
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final List<Language>? _languageList =
      Get.find<SplashController>().configModel!.language;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _storeInfoScrollKey = GlobalKey();
  final GlobalKey _storePrefScrollKey = GlobalKey();
  final GlobalKey _locationInfoScrollKey = GlobalKey();

  String? _countryDialCode;
  bool firstTime = true;
  TabController? _tabController;
  final List<Tab> _tabs = [];

  GlobalKey<FormState>? _formKeyFirst;
  GlobalKey<FormState>? _formKeySecond;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: _languageList!.length, initialIndex: 0, vsync: this);
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _nameFocus.add(FocusNode());
      _addressFocus.add(FocusNode());
    }
    Get.find<StoreRegistrationController>().resetData();
    Get.find<StoreRegistrationController>()
        .storeStatusChange(0.1, isUpdate: false);
    Get.find<StoreRegistrationController>().getZoneList();
    Get.find<StoreRegistrationController>()
        .selectModuleIndex(-1, canUpdate: false);
    if (Get.find<StoreRegistrationController>().showPassView) {
      Get.find<StoreRegistrationController>().showHidePass(isUpdate: false);
    }
    Get.find<StoreRegistrationController>().resetBusiness();
    Get.find<StoreRegistrationController>().clearPickupZone();

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }
    _formKeyFirst = GlobalKey<FormState>();
    _formKeySecond = GlobalKey<FormState>();
  }

  Future<void> _showBackPressedDialogue(String title) async {
    Get.dialog(
        ConfirmationDialog(
          icon: Images.support,
          title: title,
          description: 'Are you sure to go back'.tr,
          isLogOut: true,
          onYesPressed: () {
            if (Get.isDialogOpen!) {
              Get.back();
            }
            if (ResponsiveHelper.isDesktop(Get.context)) {
              Get.back();
            } else {
              Get.off(() => const DashboardScreen(pageIndex: 4));
            }
          },
        ),
        useSafeArea: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (Get.find<StoreRegistrationController>().storeStatus == 0.6 &&
            firstTime) {
          Get.find<StoreRegistrationController>().storeStatusChange(0.1);
          firstTime = false;
        } else if (Get.find<StoreRegistrationController>().storeStatus == 0.9) {
          Get.find<StoreRegistrationController>().storeStatusChange(0.6);
          // firstTime = false;
        } else {
          await _showBackPressedDialogue('Your registration not setup yet'.tr);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Vendor registration'.tr,
            onBackPressed: () async {
              if (Get.find<StoreRegistrationController>().storeStatus != 0.1 &&
                  firstTime) {
                Get.find<StoreRegistrationController>().storeStatusChange(0.1);
                firstTime = false;
              } else {
                await _showBackPressedDialogue(
                    'Your registration not setup yet'.tr);
              }
            }),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(child: GetBuilder<StoreRegistrationController>(
            builder: (storeRegController) {
          if (storeRegController.storeAddress != null &&
              _languageList!.isNotEmpty) {
            _addressController[0].text =
                storeRegController.storeAddress.toString();
          }

          return Column(children: [
            WebScreenTitleWidget(title: 'Join as vendor'.tr),
            ResponsiveHelper.isDesktop(context)
                ? Center(
                    child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 35),
                      child: RegistrationStepperWidget(
                          status: storeRegController.storeStatus == 0.9
                              ? 'business'
                              : ''),
                    ),
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeSmall),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storeRegController.storeStatus == 0.1
                                ? 'Provide vendor information to proceed next'
                                    .tr
                                : storeRegController.storeStatus == 0.6
                                    ? 'Provide owner information to confirm'.tr
                                    : 'You are one step away choose your business plan'
                                        .tr,
                            style: ralewayRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          LinearProgressIndicator(
                            backgroundColor: Theme.of(context).disabledColor,
                            minHeight: 2,
                            value: storeRegController.storeStatus,
                          ),
                        ]),
                  ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: ResponsiveHelper.isDesktop(context)
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall,
                        horizontal: Dimensions.paddingSizeDefault),
                child: FooterView(
                  child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: ResponsiveHelper.isDesktop(context)
                          ? webView(storeRegController)
                          : Column(children: [
                              Visibility(
                                visible: storeRegController.storeStatus == 0.1,
                                child: Form(
                                  key: _formKeyFirst,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Vendor info'.tr,
                                            style: ralewayBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 5,
                                                  spreadRadius: 1)
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: Column(children: [
                                            SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: TabBar(
                                                  tabAlignment:
                                                      TabAlignment.start,
                                                  controller: _tabController,
                                                  indicatorColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  indicatorWeight: 3,
                                                  labelColor: Theme.of(context)
                                                      .primaryColor,
                                                  unselectedLabelColor:
                                                      Theme.of(context)
                                                          .disabledColor,
                                                  unselectedLabelStyle:
                                                      ralewayRegular.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                  labelStyle:
                                                      ralewayBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                  labelPadding:
                                                      const EdgeInsets.only(
                                                          right: Dimensions
                                                              .radiusDefault),
                                                  isScrollable: true,
                                                  indicatorSize:
                                                      TabBarIndicatorSize.tab,
                                                  tabs: _tabs,
                                                  onTap: (int? value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: Dimensions
                                                      .paddingSizeLarge),
                                              child: Divider(height: 0),
                                            ),
                                            CustomTextField(
                                              key: _storeInfoScrollKey,
                                              titleText: 'Write vendor name'.tr,
                                              labelText: 'Vendor name'.tr,
                                              controller: _nameController[
                                                  _tabController!.index],
                                              focusNode: _nameFocus[
                                                  _tabController!.index],
                                              nextFocus: _tabController!
                                                          .index !=
                                                      _languageList!.length - 1
                                                  ? _addressFocus[
                                                      _tabController!.index]
                                                  : _addressFocus[0],
                                              inputType: TextInputType.name,
                                              prefixImage: Images.shopIcon,
                                              capitalization:
                                                  TextCapitalization.words,
                                              required: true,
                                              validator: (value) => ValidateCheck
                                                  .validateEmptyText(
                                                      value,
                                                      "Vendor name field is required"
                                                          .tr),
                                            ),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtremeLarge),
                                            Row(children: [
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(children: [
                                                        Text('Vendor logo'.tr,
                                                            style: ralewayRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color
                                                                    ?.withValues(
                                                                        alpha:
                                                                            0.7))),
                                                        Text(' (${'1:1'})',
                                                            style: ralewayRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall)),
                                                      ]),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeDefault),
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimensions.radiusSmall),
                                                                    child: storeRegController.pickedLogo !=
                                                                            null
                                                                        ? GetPlatform.isWeb
                                                                            ? Image.network(
                                                                                storeRegController.pickedLogo!.path,
                                                                                width: 150,
                                                                                height: 120,
                                                                                fit: BoxFit.cover,
                                                                              )
                                                                            : Image.file(
                                                                                File(storeRegController.pickedLogo!.path),
                                                                                width: 150,
                                                                                height: 120,
                                                                                fit: BoxFit.cover,
                                                                              )
                                                                        : SizedBox(
                                                                            width:
                                                                                150,
                                                                            height:
                                                                                120,
                                                                            child:
                                                                                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                              Icon(CupertinoIcons.photo_camera_solid, size: 30, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                                                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                                                child: Text(
                                                                                  'Upload vendor logo'.tr,
                                                                                  style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  left: 0,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () =>
                                                                        storeRegController.pickImage(
                                                                            true,
                                                                            false),
                                                                    child:
                                                                        DottedBorder(
                                                                      options:
                                                                          RoundedRectDottedBorderOptions(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        strokeWidth:
                                                                            1,
                                                                        strokeCap:
                                                                            StrokeCap.butt,
                                                                        dashPattern: const [
                                                                          5,
                                                                          5
                                                                        ],
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        radius: const Radius
                                                                            .circular(
                                                                            Dimensions.radiusDefault),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Visibility(
                                                                          visible:
                                                                              storeRegController.pickedLogo != null,
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(25),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(width: 2, color: Colors.white),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ])),
                                                    ]),
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeDefault),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(children: [
                                                        Text('Vendor cover'.tr,
                                                            style: ralewayRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color
                                                                    ?.withValues(
                                                                        alpha:
                                                                            0.7))),
                                                        Text(' (${'3:1'})',
                                                            style: ralewayRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall)),
                                                      ]),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeDefault),
                                                      Stack(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusSmall),
                                                            child: storeRegController
                                                                        .pickedCover !=
                                                                    null
                                                                ? GetPlatform
                                                                        .isWeb
                                                                    ? Image
                                                                        .network(
                                                                        storeRegController
                                                                            .pickedCover!
                                                                            .path,
                                                                        width: context
                                                                            .width,
                                                                        height:
                                                                            120,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : Image
                                                                        .file(
                                                                        File(storeRegController
                                                                            .pickedCover!
                                                                            .path),
                                                                        width: context
                                                                            .width,
                                                                        height:
                                                                            120,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                : SizedBox(
                                                                    width: context
                                                                        .width,
                                                                    height: 120,
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                              CupertinoIcons.photo_camera_solid,
                                                                              size: 30,
                                                                              color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                                                                          Text(
                                                                            'Upload vendor cover'.tr,
                                                                            style:
                                                                                ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                                            child:
                                                                                Text(
                                                                              'Upload jpg png gif maximum 2 mb'.tr,
                                                                              style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          top: 0,
                                                          left: 0,
                                                          child: InkWell(
                                                            onTap: () =>
                                                                storeRegController
                                                                    .pickImage(
                                                                        false,
                                                                        false),
                                                            child: DottedBorder(
                                                              options:
                                                                  RoundedRectDottedBorderOptions(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                strokeWidth: 1,
                                                                strokeCap:
                                                                    StrokeCap
                                                                        .butt,
                                                                dashPattern: const [
                                                                  5,
                                                                  5
                                                                ],
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                radius: const Radius
                                                                    .circular(
                                                                    Dimensions
                                                                        .radiusDefault),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Visibility(
                                                                  visible:
                                                                      storeRegController
                                                                              .pickedCover !=
                                                                          null,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            25),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              3,
                                                                          color:
                                                                              Colors.white),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: const Icon(
                                                                        CupertinoIcons
                                                                            .photo_camera_solid,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            50),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ]),
                                              ),
                                            ]),
                                          ]),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Text('Location info'.tr,
                                            style: ralewayBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        storeRegController.zoneList != null
                                            ? SelectLocationViewWidget(
                                                key: _locationInfoScrollKey,
                                                fromView: true,
                                                addressController:
                                                    _addressController[0],
                                                addressFocus: _addressFocus[0],
                                              )
                                            : Container(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withValues(
                                                                alpha: 0.1),
                                                        spreadRadius: 1,
                                                        blurRadius: 10,
                                                        offset:
                                                            const Offset(0, 1))
                                                  ],
                                                ),
                                                child: Column(children: [
                                                  Shimmer(
                                                    child: Container(
                                                      height: 45,
                                                      width: context.width,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .shadowColor,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                  Shimmer(
                                                    child: Container(
                                                      height: 220,
                                                      width: context.width,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .shadowColor,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                  Shimmer(
                                                    child: Container(
                                                      height: 100,
                                                      width: context.width,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .shadowColor,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                        Text('Vendor preference'.tr,
                                            style: ralewayBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 1))
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.dialog(
                                                        const CustomTimePickerWidget());
                                                  },
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                              width: 0.5),
                                                        ),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeLarge),
                                                        child: Row(children: [
                                                          Expanded(
                                                              child: Text(
                                                            '${storeRegController.storeMinTime} : ${storeRegController.storeMaxTime} ${storeRegController.storeTimeUnit}',
                                                            style:
                                                                ralewayMedium,
                                                          )),
                                                          Icon(
                                                            Icons
                                                                .access_time_filled,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          )
                                                        ]),
                                                      ),
                                                      Positioned(
                                                        left: 10,
                                                        top: -15,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                              'Select estimated delivery time'
                                                                  .tr,
                                                              style: ralewayRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                        Text('Business tin'.tr,
                                            style: ralewayBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 1))
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextField(
                                                  hintText:
                                                      'Taxpayer identification number tin'
                                                          .tr,
                                                  labelText: 'Tin number'.tr,
                                                  controller:
                                                      _tinNumberController,
                                                  inputAction:
                                                      TextInputAction.done,
                                                  inputType:
                                                      TextInputType.number,
                                                  onChanged: (value) {},
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtremeLarge),
                                                InkWell(
                                                  onTap: () async {
                                                    final DateTime? pickedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      firstDate: DateTime.now(),
                                                      initialDate:
                                                          DateTime.now(),
                                                      lastDate: DateTime(2100),
                                                    );

                                                    if (pickedDate != null) {
                                                      storeRegController
                                                          .setTinExpireDate(
                                                              pickedDate);
                                                    }
                                                  },
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                              width: 0.5),
                                                        ),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeLarge),
                                                        child: Row(children: [
                                                          Expanded(
                                                              child: Text(
                                                            storeRegController
                                                                    .tinExpireDate ??
                                                                'Select date'
                                                                    .tr,
                                                            style:
                                                                ralewayMedium,
                                                          )),
                                                          Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ]),
                                                      ),
                                                      Positioned(
                                                        left: 10,
                                                        top: -15,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                              'Expire date'.tr,
                                                              style: ralewayRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),
                                                Text('Tin certificate'.tr,
                                                    style:
                                                        ralewayRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge)),
                                                Text('Vehicle doc format'.tr,
                                                    style:
                                                        ralewayRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),
                                                storeRegController
                                                        .tinFiles!.isEmpty
                                                    ? InkWell(
                                                        onTap: () {
                                                          storeRegController
                                                              .pickFiles();
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeExtraLarge),
                                                          child: DottedBorder(
                                                            options:
                                                                RoundedRectDottedBorderOptions(
                                                              radius: const Radius
                                                                  .circular(
                                                                  Dimensions
                                                                      .radiusDefault),
                                                              dashPattern: const [
                                                                8,
                                                                4
                                                              ],
                                                              strokeWidth: 1,
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                      .withValues(
                                                                          alpha:
                                                                              0.2)
                                                                  : const Color(
                                                                      0xFFE5E5E5),
                                                            ),
                                                            child: Container(
                                                              height: 120,
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                        .withValues(
                                                                            alpha:
                                                                                0.05)
                                                                    : const Color(
                                                                        0xFFFAFAFA),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: Dimensions
                                                                          .paddingSizeSmall),
                                                                  CustomAssetImageWidget(
                                                                      Images
                                                                          .uploadIcon,
                                                                      height:
                                                                          40,
                                                                      width: 40,
                                                                      color: Get
                                                                              .isDarkMode
                                                                          ? Colors
                                                                              .grey
                                                                          : null),
                                                                  const SizedBox(
                                                                      width: Dimensions
                                                                          .paddingSizeSmall),
                                                                  RichText(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              'Click to upload'.tr,
                                                                          style: ralewayBold.copyWith(
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: Colors.blue),
                                                                        ),
                                                                        // const TextSpan(text: '\n'),
                                                                        // TextSpan(
                                                                        //   text: 'Or drag and drop'.tr,
                                                                        //   style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeExtraLarge),
                                                        child: DottedBorder(
                                                          options:
                                                              RoundedRectDottedBorderOptions(
                                                            radius: const Radius
                                                                .circular(
                                                                Dimensions
                                                                    .radiusDefault),
                                                            dashPattern: const [
                                                              8,
                                                              4
                                                            ],
                                                            strokeWidth: 1,
                                                            color: const Color(
                                                                0xFFE5E5E5),
                                                          ),
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left: Dimensions
                                                                          .paddingSizeDefault),
                                                                  height: 120,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xFFFAFAFA),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimensions.radiusDefault),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Builder(
                                                                              builder: (context) {
                                                                                final filePath = storeRegController.tinFiles![0].paths[0];
                                                                                final fileName = filePath!.split('/').last.toLowerCase();

                                                                                if (fileName.endsWith('.pdf')) {
                                                                                  // Show PDF preview
                                                                                  return Row(
                                                                                    children: [
                                                                                      const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                                                                                      const SizedBox(width: 10),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          fileName,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 35),
                                                                                    ],
                                                                                  );
                                                                                } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
                                                                                  // Show Word document preview
                                                                                  return Row(
                                                                                    children: [
                                                                                      const Icon(Icons.description, size: 40, color: Colors.blue),
                                                                                      const SizedBox(width: 10),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          fileName,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 35),
                                                                                    ],
                                                                                  );
                                                                                } else {
                                                                                  // Show generic file preview
                                                                                  return Row(
                                                                                    children: [
                                                                                      const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                                                                                      const SizedBox(width: 10),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          fileName,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 35),
                                                                                    ],
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 0,
                                                                  top: 0,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      storeRegController
                                                                          .removeFile(
                                                                              0);
                                                                    },
                                                                    child:
                                                                        const Padding(
                                                                      padding: EdgeInsets.all(
                                                                          Dimensions
                                                                              .paddingSizeSmall),
                                                                      child: Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ]),
                                        ),
                                      ]),
                                ),
                              ),
                              Visibility(
                                visible: storeRegController.storeStatus == 0.6,
                                child: Form(
                                  key: _formKeySecond,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text('Owner info'.tr,
                                              style: ralewayBold.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall),
                                          CustomToolTip(
                                            message:
                                                'This info will need for vendor app and panel login'
                                                    .tr,
                                            preferredDirection:
                                                AxisDirection.down,
                                            iconColor: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color
                                                ?.withValues(alpha: 0.7),
                                          ),
                                        ]),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 1))
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextField(
                                                  titleText:
                                                      'Write first name'.tr,
                                                  controller: _fNameController,
                                                  focusNode: _fNameFocus,
                                                  nextFocus: _lNameFocus,
                                                  inputType: TextInputType.name,
                                                  capitalization:
                                                      TextCapitalization.words,
                                                  prefixIcon: CupertinoIcons
                                                      .person_crop_circle_fill,
                                                  iconSize: 25,
                                                  required: true,
                                                  labelText: 'First name'.tr,
                                                  validator: (value) =>
                                                      ValidateCheck
                                                          .validateEmptyText(
                                                              value,
                                                              "First name field is required"
                                                                  .tr),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtremeLarge),

                                                CustomTextField(
                                                  titleText:
                                                      'Write last name'.tr,
                                                  controller: _lNameController,
                                                  focusNode: _lNameFocus,
                                                  nextFocus: _phoneFocus,
                                                  prefixIcon: CupertinoIcons
                                                      .person_crop_circle_fill,
                                                  iconSize: 25,
                                                  inputType: TextInputType.name,
                                                  capitalization:
                                                      TextCapitalization.words,
                                                  required: true,
                                                  labelText: 'Last name'.tr,
                                                  validator: (value) =>
                                                      ValidateCheck
                                                          .validateEmptyText(
                                                              value,
                                                              "Last name field is required"
                                                                  .tr),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtremeLarge),

                                                CustomTextField(
                                                  titleText:
                                                      'Enter phone number'.tr,
                                                  controller: _phoneController,
                                                  focusNode: _phoneFocus,
                                                  nextFocus: _emailFocus,
                                                  inputType:
                                                      TextInputType.phone,
                                                  isPhone: true,
                                                  showTitle: ResponsiveHelper
                                                      .isDesktop(context),
                                                  onCountryChanged: (CountryCode
                                                      countryCode) {
                                                    _countryDialCode =
                                                        countryCode.dialCode;
                                                  },
                                                  countryDialCode: _countryDialCode != null
                                                      ? CountryCode.fromCountryCode(
                                                              Get.find<
                                                                      SplashController>()
                                                                  .configModel!
                                                                  .country!)
                                                          .code
                                                      : Get.find<
                                                              LocalizationController>()
                                                          .locale
                                                          .countryCode,
                                                  required: true,
                                                  labelText: 'Phone'.tr,
                                                  validator: (value) =>
                                                      ValidateCheck
                                                          .validateEmptyText(
                                                              value, null),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtremeLarge),

                                                CustomTextField(
                                                  titleText: 'Write email'.tr,
                                                  controller: _emailController,
                                                  focusNode: _emailFocus,
                                                  nextFocus: _passwordFocus,
                                                  inputType: TextInputType
                                                      .emailAddress,
                                                  prefixIcon: Icons.email,
                                                  iconSize: 25,
                                                  required: true,
                                                  labelText: 'Email'.tr,
                                                  validator: (value) =>
                                                      ValidateCheck
                                                          .validateEmail(value),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtremeLarge),

                                                GetBuilder<
                                                        StoreRegistrationController>(
                                                    builder:
                                                        (storeRegController) {
                                                  return Column(children: [
                                                    CustomTextField(
                                                      titleText:
                                                          '8+characters'.tr,
                                                      controller:
                                                          _passwordController,
                                                      focusNode: _passwordFocus,
                                                      nextFocus:
                                                          _confirmPasswordFocus,
                                                      inputType: TextInputType
                                                          .visiblePassword,
                                                      prefixIcon: Icons.lock,
                                                      iconSize: 25,
                                                      isPassword: true,
                                                      onChanged: (value) {
                                                        if (value != null &&
                                                            value.isNotEmpty) {
                                                          if (!storeRegController
                                                              .showPassView) {
                                                            storeRegController
                                                                .showHidePass();
                                                          }
                                                          storeRegController
                                                              .validPassCheck(
                                                                  value);
                                                        } else {
                                                          if (storeRegController
                                                              .showPassView) {
                                                            storeRegController
                                                                .showHidePass();
                                                          }
                                                        }
                                                      },
                                                      required: true,
                                                      labelText: 'Password'.tr,
                                                      validator: (value) =>
                                                          ValidateCheck
                                                              .validateEmptyText(
                                                                  value,
                                                                  "Password field is required"
                                                                      .tr),
                                                    ),
                                                    storeRegController
                                                            .showPassView
                                                        ? const PassViewWidget()
                                                        : const SizedBox(),
                                                  ]);
                                                }),

                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtremeLarge),

                                                CustomTextField(
                                                  titleText: '8+characters'.tr,
                                                  controller:
                                                      _confirmPasswordController,
                                                  focusNode:
                                                      _confirmPasswordFocus,
                                                  inputType: TextInputType
                                                      .visiblePassword,
                                                  inputAction:
                                                      TextInputAction.done,
                                                  prefixIcon: Icons.lock,
                                                  iconSize: 25,
                                                  isPassword: true,
                                                  required: true,
                                                  labelText:
                                                      'Confirm password'.tr,
                                                  validator: (value) =>
                                                      ValidateCheck
                                                          .validateEmptyText(
                                                              value,
                                                              "Password field is required"
                                                                  .tr),
                                                ),
                                                // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                              ]),
                                        ),
                                      ]),
                                ),
                              ),
                              Visibility(
                                visible: storeRegController.storeStatus == 0.9,
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeLarge,
                                        bottom:
                                            Dimensions.paddingSizeExtremeLarge),
                                    child: Center(
                                        child: Text(
                                            'Choose your business plan'.tr,
                                            style: ralewayBold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeLarge),
                                    child: Row(children: [
                                      Get.find<SplashController>()
                                                  .configModel!
                                                  .commissionBusinessModel !=
                                              0
                                          ? Expanded(
                                              child: BaseCardWidget(
                                                storeRegistrationController:
                                                    storeRegController,
                                                title: 'Commission base'.tr,
                                                index: 0,
                                                onTap: () => storeRegController
                                                    .setBusiness(0),
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                          width: Get.find<SplashController>()
                                                      .configModel!
                                                      .commissionBusinessModel !=
                                                  0
                                              ? Dimensions.paddingSizeDefault
                                              : 0),
                                      Get.find<SplashController>()
                                                  .configModel!
                                                  .subscriptionBusinessModel !=
                                              0
                                          ? Expanded(
                                              child: BaseCardWidget(
                                                storeRegistrationController:
                                                    storeRegController,
                                                title: 'Subscription base'.tr,
                                                index: 1,
                                                onTap: () => storeRegController
                                                    .setBusiness(1),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ]),
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeExtraLarge),
                                  storeRegController.businessIndex == 0
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge),
                                          child: Text(
                                            "${'Vendor will pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'Commission to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'From each order you will get access of all'.tr}",
                                            style: ralewayRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color
                                                    ?.withValues(alpha: 0.7)),
                                            textAlign: TextAlign.justify,
                                            textScaler:
                                                const TextScaler.linear(1.1),
                                          ),
                                        )
                                      : Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeLarge),
                                            child: Text(
                                              'Run vendor by purchasing subscription packages'
                                                  .tr,
                                              style: ralewayRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color
                                                      ?.withValues(alpha: 0.7)),
                                              textAlign: TextAlign.justify,
                                              textScaler:
                                                  const TextScaler.linear(1.1),
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge),
                                          storeRegController.packageModel !=
                                                  null
                                              ? SizedBox(
                                                  height: 420,
                                                  child: storeRegController
                                                          .packageModel!
                                                          .packages!
                                                          .isNotEmpty
                                                      ? Swiper(
                                                          itemCount:
                                                              storeRegController
                                                                  .packageModel!
                                                                  .packages!
                                                                  .length,
                                                          viewportFraction:
                                                              0.60,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return PackageCardWidget(
                                                              canSelect:
                                                                  storeRegController
                                                                          .activeSubscriptionIndex ==
                                                                      index,
                                                              packages: storeRegController
                                                                  .packageModel!
                                                                  .packages![index],
                                                            );
                                                          },
                                                          onIndexChanged:
                                                              (index) {
                                                            storeRegController
                                                                .selectSubscriptionCard(
                                                                    index);
                                                          },
                                                        )
                                                      : Center(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    Images
                                                                        .emptyBox,
                                                                    height:
                                                                        150),
                                                                const SizedBox(
                                                                    height: Dimensions
                                                                        .paddingSizeLarge),
                                                                Text(
                                                                    'No package available'
                                                                        .tr,
                                                                    style:
                                                                        ralewayMedium),
                                                              ]),
                                                        ),
                                                )
                                              : const CircularProgressIndicator(),
                                        ]),
                                ]),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                            ])),
                ),
              ),
            ),
            (ResponsiveHelper.isDesktop(context))
                ? const SizedBox()
                : buttonView(),
          ]);
        })),
      ),
    );
  }

  Widget webView(StoreRegistrationController storeRegController) {
    return Column(children: [
      storeRegController.storeStatus != 0.9
          ? Column(children: [
              Row(children: [
                CustomAssetImageWidget(Images.shopIcon,
                    height: 20,
                    width: 20,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('Vendor information'.tr,
                    style: ralewayMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault)),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          height: 40,
                          width: 500,
                          color: Colors.transparent,
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _tabController,
                            indicatorColor: Theme.of(context).primaryColor,
                            indicatorWeight: 3,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor:
                                Theme.of(context).disabledColor,
                            unselectedLabelStyle: ralewayRegular.copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeSmall),
                            labelStyle: ralewayBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).primaryColor),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.radiusDefault,
                                vertical: 0),
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: _tabs,
                            onTap: (int? value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(children: [
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                CustomTextField(
                                  titleText: 'Write vendor name'.tr,
                                  labelText: 'Vendor name'.tr,
                                  controller:
                                      _nameController[_tabController!.index],
                                  focusNode: _nameFocus[_tabController!.index],
                                  nextFocus: _tabController!.index !=
                                          _languageList!.length - 1
                                      ? _addressFocus[_tabController!.index]
                                      : _addressFocus[0],
                                  inputType: TextInputType.name,
                                  prefixImage: Images.shopIcon,
                                  capitalization: TextCapitalization.words,
                                  required: true,
                                  validator: (value) =>
                                      ValidateCheck.validateEmptyText(value,
                                          "Vendor name field is required".tr),
                                ),
                                const SizedBox(
                                    height:
                                        Dimensions.paddingSizeExtraOverLarge),
                                const ModuleViewWidget(),
                                const SizedBox(
                                    height:
                                        Dimensions.paddingSizeExtraOverLarge),
                                CustomTextField(
                                  titleText: 'Write vendor address'.tr,
                                  labelText: 'Address'.tr,
                                  controller: _addressController[0],
                                  focusNode: _addressFocus[0],
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.sentences,
                                  maxLines: 3,
                                  required: true,
                                  validator: (value) =>
                                      ValidateCheck.validateEmptyText(
                                          value,
                                          "Vendor address field is required"
                                              .tr),
                                ),
                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: Column(children: [
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                storeRegController.zoneList != null
                                    ? const SelectLocationViewWidget(
                                        fromView: true, mapView: true)
                                    : const Center(
                                        child: CircularProgressIndicator()),
                              ]),
                            ),
                          ]),
                    ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(children: [
                const Icon(Icons.person),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('General information'.tr,
                    style: ralewayMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault))
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          InkWell(
                            onTap: () {
                              Get.dialog(const CustomTimePickerWidget());
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    border: Border.all(
                                        color: Theme.of(context).disabledColor,
                                        width: 0.5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge),
                                  child: Row(children: [
                                    Expanded(
                                        child: Text(
                                      '${storeRegController.storeMinTime} : ${storeRegController.storeMaxTime} ${storeRegController.storeTimeUnit}',
                                      style: ralewayMedium,
                                    )),
                                    Icon(
                                      Icons.access_time_filled,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ]),
                                ),
                                Positioned(
                                  left: 10,
                                  top: -15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Text('Select time'.tr,
                                        style: ralewayRegular.copyWith(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])),
                    Expanded(
                        child: Row(children: [
                      Expanded(
                        flex: 4,
                        child: Align(
                            alignment: Alignment.center,
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  child: storeRegController.pickedLogo != null
                                      ? GetPlatform.isWeb
                                          ? Image.network(
                                              storeRegController
                                                  .pickedLogo!.path,
                                              width: 150,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(storeRegController
                                                  .pickedLogo!.path),
                                              width: 150,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                      : SizedBox(
                                          width: 150,
                                          height: 120,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    CupertinoIcons
                                                        .photo_camera_solid,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withValues(
                                                            alpha: 0.6)),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                                  child: Text(
                                                    '${'Upload vendor logo'.tr} (${'1:1'})',
                                                    style: ralewayRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color
                                                            ?.withValues(
                                                                alpha: 0.7)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                                  child: Text(
                                                    'Upload jpg png gif maximum 2 mb'
                                                        .tr,
                                                    style: ralewayRegular.copyWith(
                                                        color: Theme.of(context)
                                                            .disabledColor
                                                            .withValues(
                                                                alpha: 0.6),
                                                        fontSize: Dimensions
                                                            .fontSizeOverSmall),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                top: 0,
                                left: 0,
                                child: InkWell(
                                  onTap: () =>
                                      storeRegController.pickImage(true, false),
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      color: Theme.of(context).primaryColor,
                                      strokeWidth: 1,
                                      strokeCap: StrokeCap.butt,
                                      dashPattern: const [5, 5],
                                      padding: const EdgeInsets.all(0),
                                      radius: const Radius.circular(
                                          Dimensions.radiusDefault),
                                    ),
                                    child: Center(
                                      child: Visibility(
                                        visible:
                                            storeRegController.pickedLogo !=
                                                null,
                                        child: Container(
                                          padding: const EdgeInsets.all(25),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                              CupertinoIcons.photo_camera_solid,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                      ),
                      //const SizedBox(width: Dimensions.paddingSizeDefault),

                      Expanded(
                        flex: 6,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              child: storeRegController.pickedCover != null
                                  ? GetPlatform.isWeb
                                      ? Image.network(
                                          storeRegController.pickedCover!.path,
                                          width: context.width,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(storeRegController
                                              .pickedCover!.path),
                                          width: context.width,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                  : SizedBox(
                                      width: context.width,
                                      height: 120,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                                CupertinoIcons
                                                    .photo_camera_solid,
                                                size: 30,
                                                color: Theme.of(context)
                                                    .disabledColor
                                                    .withValues(alpha: 0.6)),
                                            Text(
                                              '${'Upload vendor cover'.tr} (${'3:1'})',
                                              style: ralewayRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color
                                                      ?.withValues(alpha: 0.7),
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                              child: Text(
                                                'Upload jpg png gif maximum 2 mb'
                                                    .tr,
                                                style: ralewayRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withValues(alpha: 0.6),
                                                    fontSize: Dimensions
                                                        .fontSizeOverSmall),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ]),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () =>
                                  storeRegController.pickImage(false, false),
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(0),
                                  radius: const Radius.circular(
                                      Dimensions.radiusDefault),
                                ),
                                child: Center(
                                  child: Visibility(
                                    visible:
                                        storeRegController.pickedCover != null,
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          CupertinoIcons.photo_camera_solid,
                                          color: Colors.white,
                                          size: 50),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ])),
                  ]),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(children: [
                const Icon(Icons.business),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('Business tin'.tr,
                    style: ralewayMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault))
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 1))
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeDefault),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextField(
                                hintText:
                                    'Taxpayer identification number tin'.tr,
                                labelText: 'tin'.tr,
                                controller: _tinNumberController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.number,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtremeLarge),
                              InkWell(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    storeRegController
                                        .setTinExpireDate(pickedDate);
                                  }
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        border: Border.all(
                                            color:
                                                Theme.of(context).disabledColor,
                                            width: 0.5),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeLarge),
                                      child: Row(children: [
                                        Expanded(
                                            child: Text(
                                          storeRegController.tinExpireDate ??
                                              'Select date'.tr,
                                          style: ralewayMedium,
                                        )),
                                        Icon(Icons.calendar_month,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ]),
                                    ),
                                    Positioned(
                                      left: 10,
                                      top: -15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Text('Expire date'.tr,
                                            style: ralewayRegular.copyWith(
                                                color: Theme.of(context)
                                                    .disabledColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text('Tin certificate'.tr,
                                    style: ralewayRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                                Text('(${'Vehicle doc format'.tr})',
                                    style: ralewayRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color:
                                            Theme.of(context).disabledColor)),
                              ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              storeRegController.tinFiles!.isEmpty
                                  ? InkWell(
                                      onTap: () {
                                        storeRegController.pickFiles();
                                      },
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          radius: const Radius.circular(
                                              Dimensions.radiusDefault),
                                          dashPattern: const [8, 4],
                                          strokeWidth: 1,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                                  .withValues(alpha: 0.2)
                                              : const Color(0xFFE5E5E5),
                                        ),
                                        child: Container(
                                          height: 120,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                    .withValues(alpha: 0.05)
                                                : const Color(0xFFFAFAFA),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                              CustomAssetImageWidget(
                                                  Images.uploadIcon,
                                                  height: 40,
                                                  width: 40,
                                                  color: Get.isDarkMode
                                                      ? Colors.grey
                                                      : null),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Click to upload'.tr,
                                                      style: ralewayBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: const Radius.circular(
                                            Dimensions.radiusDefault),
                                        dashPattern: const [8, 4],
                                        strokeWidth: 1,
                                        color: const Color(0xFFE5E5E5),
                                      ),
                                      child: SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: Dimensions
                                                      .paddingSizeDefault),
                                              height: 120,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFAFAFA),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .radiusDefault),
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: SizedBox(
                                                      height: 120,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Builder(
                                                            builder: (context) {
                                                              final file =
                                                                  storeRegController
                                                                      .tinFiles![
                                                                          0]
                                                                      .files[0];
                                                              final fileName = file
                                                                  .name
                                                                  .toLowerCase();

                                                              if (fileName
                                                                  .endsWith(
                                                                      '.pdf')) {
                                                                // Show PDF preview
                                                                return Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .picture_as_pdf,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .red),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        fileName,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            35),
                                                                  ],
                                                                );
                                                              } else if (fileName
                                                                      .endsWith(
                                                                          '.doc') ||
                                                                  fileName.endsWith(
                                                                      '.docx')) {
                                                                // Show Word document preview
                                                                return Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .description,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .blue),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        fileName,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            35),
                                                                  ],
                                                                );
                                                              } else {
                                                                // Show generic file preview
                                                                return Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .insert_drive_file,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .grey),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        fileName,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            35),
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  storeRegController
                                                      .removeFile(0);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeSmall),
                                                  child: Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ]),
                      ),
                    ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Form(
                key: _formKeySecond,
                child: Row(children: [
                  const Icon(Icons.person),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('Owner information'.tr,
                      style: ralewayMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault))
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: CustomTextField(
                      titleText: 'Write first name'.tr,
                      controller: _fNameController,
                      focusNode: _fNameFocus,
                      nextFocus: _lNameFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                      iconSize: 25,
                      required: true,
                      labelText: 'First name'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(
                          value, "First name field is required".tr),
                    )),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Expanded(
                        child: CustomTextField(
                      titleText: 'Write last name'.tr,
                      controller: _lNameController,
                      focusNode: _lNameFocus,
                      nextFocus: _phoneFocus,
                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                      iconSize: 25,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      required: true,
                      labelText: 'Last name'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(
                          value, "Last name field is required".tr),
                    )),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Expanded(
                      child: CustomTextField(
                        titleText: 'Enter phone number'.tr,
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.phone,
                        isPhone: true,
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: _countryDialCode != null
                            ? CountryCode.fromCountryCode(
                                    Get.find<SplashController>()
                                        .configModel!
                                        .country!)
                                .code
                            : Get.find<LocalizationController>()
                                .locale
                                .countryCode,
                        required: true,
                        labelText: 'Phone'.tr,
                        validator: (value) =>
                            ValidateCheck.validateEmptyText(value, null),
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(children: [
                const Icon(Icons.lock),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('Login info'.tr,
                    style: ralewayMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault))
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: CustomTextField(
                        titleText: 'Write email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        iconSize: 25,
                        required: true,
                        labelText: 'Email'.tr,
                        validator: (value) =>
                            ValidateCheck.validateEmail(value),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Expanded(
                      child: Column(children: [
                        CustomTextField(
                          titleText: '8+characters'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          iconSize: 25,
                          isPassword: true,
                          onChanged: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!storeRegController.showPassView) {
                                storeRegController.showHidePass();
                              }
                              storeRegController.validPassCheck(value);
                            } else {
                              if (storeRegController.showPassView) {
                                storeRegController.showHidePass();
                              }
                            }
                          },
                          required: true,
                          labelText: 'Password'.tr,
                          validator: (value) => ValidateCheck.validateEmptyText(
                              value, "Password field is required".tr),
                        ),
                        storeRegController.showPassView
                            ? const PassViewWidget()
                            : const SizedBox(),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Expanded(
                        child: CustomTextField(
                      titleText: '8+characters'.tr,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                      prefixIcon: Icons.lock,
                      iconSize: 25,
                      isPassword: true,
                      required: true,
                      labelText: 'Confirm password'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(
                          value, "Password field is required".tr),
                    )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ),
            ])
          : const SizedBox(),
      storeRegController.storeStatus == 0.9
          ? const WebBusinessPlanWidget()
          : const SizedBox(),
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
          ),
          width: 165,
          child: CustomButton(
            transparent: true,
            textColor: Theme.of(context).disabledColor,
            radius: Dimensions.radiusSmall,
            onPressed: () {
              _phoneController.text = '';
              _emailController.text = '';
              _fNameController.text = '';
              _lNameController.text = '';
              _lNameController.text = '';
              _tinNumberController.text = '';
              _passwordController.text = '';
              _confirmPasswordController.text = '';
              for (int i = 0; i < _nameController.length; i++) {
                _nameController[i].text = '';
              }
              for (int i = 0; i < _addressController.length; i++) {
                _addressController[i].text = '';
              }
              storeRegController.resetStoreRegistration();
            },
            buttonText: 'Reset'.tr,
            isBold: false,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeLarge),
        SizedBox(width: 165, child: buttonView()),
      ]),
      const SizedBox(height: 30),
    ]);
  }

  Widget buttonView() {
    return GetBuilder<StoreRegistrationController>(
        builder: (storeRegController) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isDesktop(context)
                ? 0
                : Dimensions.paddingSizeDefault),
        decoration: ResponsiveHelper.isDesktop(context)
            ? null
            : BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                ],
              ),
        child: CustomButton(
          fontSize: ResponsiveHelper.isDesktop(context)
              ? Dimensions.fontSizeSmall
              : Dimensions.fontSizeDefault,
          isBold: ResponsiveHelper.isDesktop(context) ? false : true,
          radius: ResponsiveHelper.isDesktop(context)
              ? Dimensions.radiusSmall
              : Dimensions.radiusDefault,
          isLoading: storeRegController.isLoading,
          margin: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
              ? 0
              : Dimensions.paddingSizeSmall),
          buttonText: storeRegController.storeStatus == 0.1 &&
                  !ResponsiveHelper.isDesktop(context)
              ? 'Next'.tr
              : 'Submit'.tr,
          color: Theme.of(context).primaryColor,
          onPressed: (storeRegController.storeStatus == 0.1 &&
                      !ResponsiveHelper.isDesktop(context) &&
                      !storeRegController.inZone) ||
                  (ResponsiveHelper.isDesktop(context) &&
                      !storeRegController.inZone)
              ? null
              : () {
                  bool defaultDataNull = false;
                  for (int index = 0; index < _languageList!.length; index++) {
                    if (_languageList[index].key == 'en') {
                      if (_nameController[index].text.trim().isEmpty ||
                          _addressController[index].text.trim().isEmpty) {
                        defaultDataNull = true;
                      }
                      break;
                    }
                  }
                  String tin = _tinNumberController.text.trim();
                  String minTime = storeRegController.storeMinTime;
                  String maxTime = storeRegController.storeMaxTime;
                  String fName = _fNameController.text.trim();
                  String lName = _lNameController.text.trim();
                  String phone = _phoneController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String confirmPassword =
                      _confirmPasswordController.text.trim();
                  bool valid = false;
                  try {
                    double.parse(maxTime);
                    double.parse(minTime);
                    valid = true;
                  } on FormatException {
                    valid = false;
                  }

                  if (storeRegController.storeStatus == 0.1 ||
                      storeRegController.storeStatus == 0.6) {
                    if (storeRegController.storeStatus == 0.1 &&
                        !ResponsiveHelper.isDesktop(context)) {
                      if (defaultDataNull) {
                        _scrollToKey(_storeInfoScrollKey);
                      }
                      if (_formKeyFirst!.currentState!.validate()) {
                        if (defaultDataNull) {
                          showCustomSnackBar('Enter vendor name'.tr);
                        } else if (storeRegController.pickedLogo == null) {
                          _scrollToKey(_storeInfoScrollKey);
                          showCustomSnackBar('Select vendor logo'.tr);
                        } else if (storeRegController.pickedCover == null) {
                          _scrollToKey(_storeInfoScrollKey);
                          showCustomSnackBar('Select vendor cover photo'.tr);
                        } else if (storeRegController.selectedZoneIndex == -1) {
                          _scrollToKey(_locationInfoScrollKey);
                          showCustomSnackBar('Please select zone'.tr);
                        } else if (storeRegController.selectedModuleIndex ==
                            -1) {
                          _scrollToKey(_locationInfoScrollKey);
                          showCustomSnackBar('Please select module first'.tr);
                        } else if (storeRegController.restaurantLocation ==
                            null) {
                          showCustomSnackBar('Set vendor location'.tr);
                          _scrollToKey(_locationInfoScrollKey);
                        } else if (minTime.isEmpty) {
                          showCustomSnackBar('Enter minimum delivery time'.tr);
                        } else if (maxTime.isEmpty) {
                          showCustomSnackBar('Enter maximum delivery time'.tr);
                        } else if (!valid) {
                          _scrollToKey(_storePrefScrollKey);
                          showCustomSnackBar(
                              'Please enter the max min delivery time'.tr);
                        } else if (valid &&
                            double.parse(minTime) > double.parse(maxTime)) {
                          showCustomSnackBar(
                              'Maximum delivery time can not be smaller then minimum delivery time'
                                  .tr);
                        } else {
                          _scrollController.jumpTo(
                              _scrollController.position.minScrollExtent);
                          storeRegController.storeStatusChange(0.6);
                          firstTime = true;
                        }
                      }
                    } else {
                      if (ResponsiveHelper.isDesktop(context)) {
                        if (defaultDataNull) {
                          showCustomSnackBar('Enter vendor name'.tr);
                        } else if (storeRegController.restaurantLocation ==
                            null) {
                          showCustomSnackBar('Set vendor location'.tr);
                        } else if (storeRegController.selectedZoneIndex == -1) {
                          showCustomSnackBar('Please select zone'.tr);
                        } else if (storeRegController.selectedModuleIndex ==
                            -1) {
                          showCustomSnackBar('Please select module first'.tr);
                        } else if (minTime.isEmpty) {
                          showCustomSnackBar('Enter minimum delivery time'.tr);
                        } else if (maxTime.isEmpty) {
                          showCustomSnackBar('Enter maximum delivery time'.tr);
                        } else if (!valid) {
                          showCustomSnackBar(
                              'Please enter the max min delivery time'.tr);
                        } else if (valid &&
                            double.parse(minTime) > double.parse(maxTime)) {
                          showCustomSnackBar(
                              'Maximum delivery time can not be smaller then minimum delivery time'
                                  .tr);
                        } else if (storeRegController.pickedLogo == null) {
                          showCustomSnackBar('Select vendor logo'.tr);
                        } else if (storeRegController.pickedCover == null) {
                          showCustomSnackBar('Select vendor cover photo'.tr);
                        }
                      }
                      if ((storeRegController.storeStatus == 0.6 &&
                              _formKeySecond!.currentState!.validate()) ||
                          ResponsiveHelper.isDesktop(context)) {
                        if (fName.isEmpty) {
                          showCustomSnackBar('Enter your first name'.tr);
                        } else if (lName.isEmpty) {
                          showCustomSnackBar('Enter your last name'.tr);
                        } else if (phone.isEmpty) {
                          showCustomSnackBar('Enter phone number'.tr);
                        } else if (email.isEmpty) {
                          showCustomSnackBar('Enter email address'.tr);
                        } else if (!GetUtils.isEmail(email)) {
                          showCustomSnackBar('Enter a valid email address'.tr);
                        } else if (password.isEmpty) {
                          showCustomSnackBar('Enter password'.tr);
                        } else if (password.length < 8) {
                          showCustomSnackBar('Password should be'.tr);
                        } else if (password != confirmPassword) {
                          showCustomSnackBar(
                              'Confirm password does not matched'.tr);
                        } else if (!storeRegController.spatialCheck ||
                            !storeRegController.lowercaseCheck ||
                            !storeRegController.uppercaseCheck ||
                            !storeRegController.numberCheck ||
                            !storeRegController.lengthCheck) {
                          showCustomSnackBar('Provide valid password'.tr);
                        } else {
                          storeRegController.storeStatusChange(0.9);
                        }
                      }
                    }
                  } else {
                    List<Translation> translation = [];
                    for (int index = 0; index < _languageList.length; index++) {
                      translation.add(Translation(
                        locale: _languageList[index].key,
                        key: 'name',
                        value: _nameController[index].text.trim().isNotEmpty
                            ? _nameController[index].text.trim()
                            : _nameController[0].text.trim(),
                      ));
                      translation.add(Translation(
                        locale: _languageList[index].key,
                        key: 'address',
                        value: _addressController[index].text.trim().isNotEmpty
                            ? _addressController[index].text.trim()
                            : _addressController[0].text.trim(),
                      ));
                    }

                    storeRegController.registerStore(StoreBodyModel(
                      translation: jsonEncode(translation),
                      minDeliveryTime: minTime,
                      maxDeliveryTime: maxTime,
                      lat: storeRegController.restaurantLocation!.latitude
                          .toString(),
                      email: email,
                      lng: storeRegController.restaurantLocation!.longitude
                          .toString(),
                      fName: fName,
                      lName: lName,
                      phone: _countryDialCode! + phone,
                      password: password,
                      zoneId: storeRegController
                          .zoneList![storeRegController.selectedZoneIndex!].id
                          .toString(),
                      moduleId: storeRegController
                          .moduleList![storeRegController.selectedModuleIndex!]
                          .id
                          .toString(),
                      deliveryTimeType: storeRegController.storeTimeUnit,
                      businessPlan: storeRegController.businessIndex == 0
                          ? 'commission'
                          : 'subscription',
                      packageId: storeRegController.businessIndex == 0
                          ? ''
                          : storeRegController
                              .packageModel!
                              .packages![
                                  storeRegController.activeSubscriptionIndex]
                              .id!
                              .toString(),
                      pickUpZoneIds: storeRegController.pickupZoneIdList
                          .map((e) => e.toString())
                          .toList(),
                      tin: tin,
                      tinExpireDate: storeRegController.tinExpireDate,
                    ));
                  }
                },
        ),
      );
    });
  }

  void _scrollToKey(GlobalKey scrollKey) {
    final context = scrollKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}
