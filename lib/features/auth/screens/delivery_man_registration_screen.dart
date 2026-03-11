import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liwas_user/common/widgets/custom_ink_well.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/auth/controllers/store_registration_controller.dart';
import 'package:liwas_user/features/auth/domain/models/delivery_man_body.dart';
import 'package:liwas_user/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:liwas_user/features/auth/widgets/condition_check_box_widget.dart';
import 'package:liwas_user/features/auth/widgets/pass_view_widget.dart';
import 'package:liwas_user/helper/custom_validator.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/validate_check.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_dropdown.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';
import 'package:liwas_user/common/widgets/web_page_title_widget.dart';

enum DMRegistrationSteps { stepOne, stepTwo }
class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({super.key});

  @override
  State<DeliveryManRegistrationScreen> createState() => _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String? _countryDialCode;
  GlobalKey<FormState>? _formKeyStep1;
  GlobalKey<FormState>? _formKeyStep2;

  List<String> steps = ['General info'.tr, 'Additional info'.tr];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _formKeyStep1 = GlobalKey<FormState>();
    _formKeyStep2 = GlobalKey<FormState>();
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    if(Get.find<DeliverymanRegistrationController>().showPassView){
      Get.find<DeliverymanRegistrationController>().showHidePass();
    }
    Get.find<DeliverymanRegistrationController>().pickDmImage(false, true);
    Get.find<DeliverymanRegistrationController>().dmStatusChange(DMRegistrationSteps.stepOne, isUpdate: false);
    Get.find<StoreRegistrationController>().validPassCheck('', isUpdate: false);
    Get.find<DeliverymanRegistrationController>().setIdentityTypeIndex(Get.find<DeliverymanRegistrationController>().identityTypeList[0], false);
    Get.find<DeliverymanRegistrationController>().setDMTypeIndex(0, false);
    Get.find<DeliverymanRegistrationController>().getZoneList();
    Get.find<DeliverymanRegistrationController>().getVehicleList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(Get.find<DeliverymanRegistrationController>().dmStatus != DMRegistrationSteps.stepOne && !didPop){
          Get.find<DeliverymanRegistrationController>().dmStatusChange(DMRegistrationSteps.stepOne);
          setState(() {
            _selectedIndex = 0;
          });
        }else{
          if(ResponsiveHelper.isDesktop(context)) {
            return;
          } else {
            Future.delayed(const Duration(milliseconds: 0), () => Get.back());
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CustomAppBar(title: 'Delivery man registration'.tr, onBackPressed: (){
          if(Get.find<DeliverymanRegistrationController>().dmStatus != DMRegistrationSteps.stepOne){
            Get.find<DeliverymanRegistrationController>().dmStatusChange(DMRegistrationSteps.stepOne);
            setState(() {
              _selectedIndex = 0;
            });
          }else{
            Future.delayed(const Duration(milliseconds: 0), () => Get.back());
          }
        },),
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanRegistrationController) {

          List<int> zoneIndexList = [];
          List<DropdownItem<int>> zoneList = [];
          List<DropdownItem<int>> vehicleList = [];
          List<DropdownItem<int>> dmTypeList = [];
          List<DropdownItem<int>> identityTypeList = [];

          for(int index=0; index<deliverymanRegistrationController.dmTypeList.length; index++) {
            dmTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${deliverymanRegistrationController.dmTypeList[index]?.tr}'),
              ),
            )));
          }
          for(int index=0; index<deliverymanRegistrationController.identityTypeList.length; index++) {
            identityTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(deliverymanRegistrationController.identityTypeList[index].tr),
              ),
            )));
          }
          if(deliverymanRegistrationController.zoneList != null) {
            for(int index=0; index<deliverymanRegistrationController.zoneList!.length; index++) {
              zoneIndexList.add(index);
              zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${deliverymanRegistrationController.zoneList![index].name}'),
                ),
              )));
            }
          }
          if(deliverymanRegistrationController.vehicles != null){

            for(int index=0; index<deliverymanRegistrationController.vehicles!.length; index++) {
              vehicleList.add(DropdownItem<int>(value: index, child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${deliverymanRegistrationController.vehicles![index].type}'),
                ),
              )));
            }
          }

          return SafeArea(child: ResponsiveHelper.isDesktop(context) ? webView(deliverymanRegistrationController, zoneList, dmTypeList, vehicleList, identityTypeList) : Column(children: [
            Container(
              height: 50,
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: ListView.builder(
                  itemCount: steps.length, scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  itemBuilder: (context, index) {
                    bool isSelected = index == _selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: CustomInkWell(
                    onTap: () {
                      if(Get.find<DeliverymanRegistrationController>().dmStatus != DMRegistrationSteps.stepOne){
                        setState(() {
                          _selectedIndex = 0;
                        });
                        Get.find<DeliverymanRegistrationController>().dmStatusChange(DMRegistrationSteps.stepOne);
                      } else {
                        _submitData(deliverymanRegistrationController);
                      }
                    },
                    radius: Dimensions.radiusExtraLarge,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        steps[index],
                        style: ralewayMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: isSelected
                              ? Theme.of(context).cardColor
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            Expanded(child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
              physics: const BouncingScrollPhysics(),
              child: FooterView(
                child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                  Column(children: [
                    Visibility(
                      visible: deliverymanRegistrationController.dmStatus == DMRegistrationSteps.stepOne,
                      child: Form(
                        key: _formKeyStep1,
                        child: Column(children: [
                          // const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          sectionCard(
                            title: 'Basic info'.tr,
                            child: Column(children: [
                            CustomTextField(
                              labelText: 'First name'.tr,
                              titleText: 'Ex jhon'.tr,
                              controller: _fNameController,
                              capitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              focusNode: _fNameNode,
                              nextFocus: _lNameNode,
                              // prefixIcon: Icons.person,
                              required: true,
                              labelTextSize: Dimensions.fontSizeSmall,
                              validator: (value) => ValidateCheck.validateEmptyText(value, null),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            CustomTextField(
                              labelText: 'Last name'.tr,
                              titleText: 'Ex doe'.tr,
                              controller: _lNameController,
                              capitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              focusNode: _lNameNode,
                              nextFocus: _phoneNode,
                              // prefixIcon: Icons.person,
                              required: true,
                              labelTextSize: Dimensions.fontSizeSmall,
                              validator: (value) => ValidateCheck.validateEmptyText(value, null),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            CustomTextField(
                              titleText: 'Enter phone number'.tr,
                              labelText: 'Phone'.tr,
                              controller: _phoneController,
                              focusNode: _phoneNode,
                              nextFocus: _emailNode,
                              inputType: TextInputType.phone,
                              isPhone: true,
                              onCountryChanged: (CountryCode countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                  : Get.find<LocalizationController>().locale.countryCode,
                              required: true,
                              validator: (value) => ValidateCheck.validatePhone(value, null),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            CustomTextField(
                              labelText: 'Email'.tr,
                              titleText: 'Enter email'.tr,
                              controller: _emailController,
                              focusNode: _emailNode,
                              nextFocus: _passwordNode,
                              inputType: TextInputType.emailAddress,
                              // prefixIcon: Icons.email,
                              required: true,
                              validator: (value) => ValidateCheck.validateEmptyText(value, null),
                            ),

                          ]),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          sectionCard(
                            title: 'Profile image'.tr,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: Column(children: [

                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Upload image'.tr,
                                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      ),
                                      TextSpan(
                                        text: ' *',
                                        style: ralewayMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Jpg jpeg png less then 1 mb'.tr,
                                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                                      ),
                                      TextSpan(
                                        text: ' ${'Ratio 1 1'.tr}',
                                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                Align(alignment: Alignment.center, child: Stack(clipBehavior: Clip.none, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    child: deliverymanRegistrationController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                                      deliverymanRegistrationController.pickedImage!.path, width: 120, height: 120, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(deliverymanRegistrationController.pickedImage!.path), width: 120, height: 120, fit: BoxFit.cover,
                                    ) : Container(
                                      width: 120, height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                        Image.asset(Images.uploadImage, height: 38),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),

                                        Text(
                                          'Click to add'.tr,
                                          style: ralewayMedium.copyWith(color: Colors.blueAccent, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                        ),
                                      ]),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0, right: 0, top: 0, left: 0,
                                    child: InkWell(
                                      onTap: () => deliverymanRegistrationController.pickDmImage(true, false),
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          color: Theme.of(context).disabledColor,
                                          strokeWidth: 1,
                                          strokeCap: StrokeCap.butt,
                                          dashPattern: const [5, 5],
                                          padding: const EdgeInsets.all(0),
                                          radius: const Radius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: Visibility(
                                          visible: deliverymanRegistrationController.pickedImage != null,
                                          child: Center(
                                            child: Container(
                                              margin: const EdgeInsets.all(25),
                                              decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), shape: BoxShape.circle,),
                                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                              child: const Icon(Icons.camera_alt, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  deliverymanRegistrationController.pickedImage != null ? Positioned(
                                    bottom: -10, right: -10,
                                    child: InkWell(
                                      onTap: () => deliverymanRegistrationController.removeDmImage(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                          shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                                        ),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        child:  Icon(Icons.remove, size: 18, color: Theme.of(context).cardColor,),
                                      ),
                                    ),

                                  ) : const SizedBox(),
                                ])),
                              ]),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          sectionCard(
                            title: 'Account information'.tr,
                            child: Column(children: [
                              CustomTextField(
                                labelText: 'Password'.tr,
                                titleText: '8 character'.tr,
                                controller: _passwordController,
                                focusNode: _passwordNode,
                                nextFocus: _identityNumberNode,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.visiblePassword,
                                isPassword: true,
                                // prefixIcon: Icons.lock,
                                onChanged: (value){
                                  if(value != null && value.isNotEmpty){
                                    if(!deliverymanRegistrationController.showPassView){
                                      deliverymanRegistrationController.showHidePass();
                                    }
                                    deliverymanRegistrationController.validPassCheck(value);
                                  }else{
                                    if(deliverymanRegistrationController.showPassView){
                                      deliverymanRegistrationController.showHidePass();
                                    }
                                  }
                                },
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, null),
                              ),

                              deliverymanRegistrationController.showPassView ? const PassViewWidget(forStoreRegistration: false) : const SizedBox(),
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              CustomTextField(
                                labelText: 'Confirm password'.tr,
                                titleText: '8 character'.tr,
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordNode,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.visiblePassword,
                                // prefixIcon: Icons.lock,
                                isPassword: true,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, null),
                              )
                            ]),
                          ),

                        ]),
                      ),
                    ),

                    Visibility(
                      visible: deliverymanRegistrationController.dmStatus != DMRegistrationSteps.stepOne,
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [

                        sectionCard(
                          title: 'Delivery info'.tr,
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setDMTypeIndex(index, true);
                                },
                                indexZeroNotSelected: true,
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: dmTypeList,
                                child: Text('Select delivery type'.tr),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            deliverymanRegistrationController.zoneList != null ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setZoneIndex(value);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: zoneList,
                                child: Text('${deliverymanRegistrationController.zoneList![0].name}'),
                              ),
                            ) : const Center(child: CircularProgressIndicator()),

                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            deliverymanRegistrationController.vehicleIds != null ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setVehicleIndex(value, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: vehicleList,
                                child: Text('${(deliverymanRegistrationController.vehicles != null && deliverymanRegistrationController.vehicles!.isNotEmpty) ? deliverymanRegistrationController.vehicles![0].type : ''}'),
                              ),
                            ) : const CircularProgressIndicator(),
                          ]),
                        ),


                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        sectionCard(
                          title: 'Identity info'.tr,
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setIdentityTypeIndex(deliverymanRegistrationController.identityTypeList[index], true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: identityTypeList,
                                child: Text(deliverymanRegistrationController.identityTypeList[0].tr),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            Form(
                              key: _formKeyStep2,
                              child: CustomTextField(
                                labelText: 'Identity number'.tr,
                                titleText: deliverymanRegistrationController.identityTypeIndex == 0 ? 'Ex: XXXXX-XXXXXXX-X'
                                    : deliverymanRegistrationController.identityTypeIndex == 1 ? 'L-XXX-XXX-XXX-XXX.' : 'XXX-XXXXX',
                                controller: _identityNumberController,
                                focusNode: _identityNumberNode,
                                inputAction: TextInputAction.done,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, null),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Upload identity images'.tr,
                                        style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      ),
                                      TextSpan(
                                        text: ' *',
                                        style: ralewayMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Text('Jpg jpeg png less then 1 mb'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: deliverymanRegistrationController.pickedIdentities.length+1,
                                  itemBuilder: (context, index) {
                                    XFile? file = index == deliverymanRegistrationController.pickedIdentities.length ? null : deliverymanRegistrationController.pickedIdentities[index];
                                    if(index == deliverymanRegistrationController.pickedIdentities.length) {
                                      return InkWell(
                                        onTap: () => deliverymanRegistrationController.pickDmImage(false, false),
                                        child: DottedBorder(
                                          options: RoundedRectDottedBorderOptions(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(5),
                                            radius: const Radius.circular(Dimensions.radiusDefault),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              color: Theme.of(context).cardColor,
                                            ),
                                            height: 120, width: double.infinity,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              // Icon(Icons.camera_alt, color: Theme.of(context).disabledColor, size: 38),
                                              // Text('Upload identity image'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).disabledColor)),
                                              Image.asset(Images.uploadImage, height: 38),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),

                                              Text(
                                                'Click to add'.tr,
                                                style: ralewayMedium.copyWith(color: Colors.blueAccent, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                              ),
                                            ]),
                                          ),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          color: Theme.of(context).primaryColor,
                                          strokeWidth: 1,
                                          strokeCap: StrokeCap.butt,
                                          dashPattern: const [5, 5],
                                          padding: const EdgeInsets.all(5),
                                          radius: const Radius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: Stack(clipBehavior: Clip.none, children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                            child: GetPlatform.isWeb ? Image.network(
                                              file!.path, width: double.infinity, height: 120, fit: BoxFit.cover,
                                            ) : Image.file(
                                              File(file!.path), width: double.infinity, height: 120, fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            right: -5, top: -5,
                                            child: InkWell(
                                              onTap: () => deliverymanRegistrationController.removeIdentityImage(index),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  border: Border.all(color: Colors.red, width: 2),
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(3),
                                                child: Icon(Icons.clear_rounded, color: Colors.red, size: 16),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                ),
                              ]),
                            )

                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        const ConditionCheckBoxWidget(forDeliveryMan: true, forSignUp: false),

                      ]),
                    ),
                  ]),


                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? buttonView() : const SizedBox() ,

                ])),
              ),
            )),

            (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? const SizedBox() : buttonView(),

          ]));
        }),
      ),
    );
  }

  //

  Widget webView(DeliverymanRegistrationController deliverymanRegistrationController, List<DropdownItem<int>> zoneList, List<DropdownItem<int>> typeList,
      List<DropdownItem<int>> vehicleList, List<DropdownItem<int>> identityTypeList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WebScreenTitleWidget(title: 'Join as delivery man'.tr),
          FooterView(
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Text('Delivery man registration'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        'Complete registration process to serve as delivery man'.tr,
                        style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: deliverymanRegistrationController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                            deliverymanRegistrationController.pickedImage!.path, width: 180, height: 180, fit: BoxFit.cover,
                          ) : Image.file(
                            File(deliverymanRegistrationController.pickedImage!.path), width: 180, height: 180, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: 180, height: 180,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Icon(Icons.camera_alt, size: 38, color: Theme.of(context).disabledColor),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(
                                'Upload deliveryman photo'.tr,
                                style: ralewayMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),

                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => deliverymanRegistrationController.pickDmImage(true, false),
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(0),
                                radius: const Radius.circular(Dimensions.radiusDefault),
                              ),
                              child: Visibility(
                                visible: deliverymanRegistrationController.pickedImage != null,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), shape: BoxShape.circle,),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: const Icon(Icons.camera_alt, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(children: [
                        Expanded(child: CustomTextField(
                          titleText: 'First name'.tr,
                          showLabelText: false,
                          controller: _fNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: _fNameNode,
                          nextFocus: _lNameNode,
                          prefixIcon: Icons.person,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: 'Last name'.tr,
                          showLabelText: false,
                          controller: _lNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: _lNameNode,
                          nextFocus: _phoneNode,
                          prefixIcon: Icons.person,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: CustomTextField(
                            titleText: 'Phone'.tr,
                            showLabelText: false,
                            controller: _phoneController,
                            focusNode: _phoneNode,
                            nextFocus: _emailNode,
                            inputType: TextInputType.phone,
                            isPhone: true,
                            showTitle: ResponsiveHelper.isDesktop(context),
                            onCountryChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                : Get.find<LocalizationController>().locale.countryCode,
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child:CustomTextField(
                          titleText: 'Email'.tr,
                          showLabelText: false,
                          controller: _emailController,
                          focusNode: _emailNode,
                          nextFocus: _passwordNode,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(
                          children: [
                            CustomTextField(
                              titleText: 'Password'.tr,
                              showLabelText: false,
                              controller: _passwordController,
                              focusNode: _passwordNode,
                              nextFocus: _identityNumberNode,
                              inputAction: TextInputAction.done,
                              inputType: TextInputType.visiblePassword,
                              isPassword: true,
                              prefixIcon: Icons.lock,
                              showTitle: true,
                              onChanged: (value){
                                // authController.validPassCheck(value);
                                if(value != null && value.isNotEmpty){
                                  if(!deliverymanRegistrationController.showPassView){
                                    deliverymanRegistrationController.showHidePass();
                                  }
                                  deliverymanRegistrationController.validPassCheck(value);
                                }else{
                                  if(deliverymanRegistrationController.showPassView){
                                    deliverymanRegistrationController.showHidePass();
                                  }
                                }
                              },
                            ),

                            deliverymanRegistrationController.showPassView ? const PassViewWidget(forStoreRegistration: false) : const SizedBox(),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: 'Confirm password'.tr,
                          hintText: '8 character'.tr,
                          showLabelText: false,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          showTitle: true,
                        ))
                      ]),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.person),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text('Delivery man information'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                      ]),
                      const Divider(),
                      const SizedBox(height: Dimensions.paddingSizeLarge),


                      Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery man type'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setDMTypeIndex(index, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: typeList,
                                child: Text('Select delivery type'.tr),
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Zone'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            deliverymanRegistrationController.zoneIds != null ?  Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setZoneIndex(value);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: zoneList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(deliverymanRegistrationController.selectedZoneIndex == -1 ? 'Select zone'.tr : deliverymanRegistrationController.zoneList![deliverymanRegistrationController.selectedZoneIndex!].name.toString()),
                                ),
                              ),
                            ) : Center(child: Text('Service not available in this area'.tr)),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle type'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            deliverymanRegistrationController.vehicleIds != null ?  Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setVehicleIndex(value, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: vehicleList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text('${(deliverymanRegistrationController.vehicles != null && deliverymanRegistrationController.vehicles!.isNotEmpty) ? deliverymanRegistrationController.vehicles![0].type : ''}'),
                                ),
                              ),
                            ) : const Center(child: CircularProgressIndicator()),
                          ]),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Identity type'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setIdentityTypeIndex(deliverymanRegistrationController.identityTypeList[index], true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: identityTypeList,
                                child: Text(deliverymanRegistrationController.identityTypeList[0].tr),
                              ),
                            ),

                          ]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: deliverymanRegistrationController.identityTypeIndex == 0 ? 'Identity number'.tr
                              : deliverymanRegistrationController.identityTypeIndex == 1 ? 'Driving license number'.tr : 'Nid number'.tr,
                          showLabelText: false,
                          controller: _identityNumberController,
                          focusNode: _identityNumberNode,
                          inputAction: TextInputAction.done,
                          showTitle: true,
                        ),),

                        const Expanded(child: SizedBox()),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: deliverymanRegistrationController.pickedIdentities.length+1,
                          itemBuilder: (context, index) {
                            XFile? file = index == deliverymanRegistrationController.pickedIdentities.length ? null : deliverymanRegistrationController.pickedIdentities[index];
                            if(index == deliverymanRegistrationController.pickedIdentities.length) {
                              return InkWell(
                                onTap: () => deliverymanRegistrationController.pickDmImage(false, false),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color: Theme.of(context).primaryColor,
                                    strokeWidth: 1,
                                    strokeCap: StrokeCap.butt,
                                    dashPattern: const [5, 5],
                                    padding: const EdgeInsets.all(5),
                                    radius: const Radius.circular(Dimensions.radiusDefault),
                                  ),
                                  child: Container(
                                    height: 120, width: 150, alignment: Alignment.center,
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      children: [
                                        Icon(Icons.camera_alt, color: Theme.of(context).disabledColor),
                                        Text('Upload identity image'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: GetPlatform.isWeb ? Image.network(
                                    file!.path, width: 150, height: 120, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(file!.path), width: 150, height: 120, fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0, top: 0,
                                  child: InkWell(
                                    onTap: () => deliverymanRegistrationController.removeIdentityImage(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: Icon(Icons.delete_forever, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).hintColor)
                          ),
                          width: 165,
                          child: CustomButton(
                            transparent: true,
                            textColor: Theme.of(context).hintColor,
                            radius: Dimensions.radiusSmall,
                            onPressed: () {
                              _phoneController.text = '';
                              _emailController.text = '';
                              _fNameController.text = '';
                              _lNameController.text = '';
                              _lNameController.text = '';
                              _passwordController.text = '';
                              _confirmPasswordController.text = '';
                              _identityNumberController.text = '';
                              deliverymanRegistrationController.resetDeliveryRegistration();
                            },
                            buttonText: 'Reset'.tr,
                            isBold: false,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),

                        const SizedBox( width: Dimensions.paddingSizeLarge),
                        SizedBox(width: 165, child: buttonView()),
                      ])


                    ]),
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonView(){
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanRegistrationController) {
        return CustomButton(
          isBold: ResponsiveHelper.isDesktop(context) ? false : true,
          radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
          isLoading: deliverymanRegistrationController.isLoading,
          buttonText: deliverymanRegistrationController.dmStatus == DMRegistrationSteps.stepOne ? 'Next'.tr : 'Submit'.tr,
          margin: EdgeInsets.all((ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? 0 : Dimensions.paddingSizeSmall),
          height: 50,
          onPressed: !deliverymanRegistrationController.acceptTerms ? null : () async {
            _submitData(deliverymanRegistrationController);
          },
        );
      });
  }

  Future<void> _submitData(DeliverymanRegistrationController deliverymanRegistrationController) async {
    if(deliverymanRegistrationController.dmStatus == DMRegistrationSteps.stepOne && !ResponsiveHelper.isDesktop(context)){
      String fName = _fNameController.text.trim();
      String lName = _lNameController.text.trim();
      String email = _emailController.text.trim();
      String phone = _phoneController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();
      String numberWithCountryCode = _countryDialCode!+phone;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);

      if(_formKeyStep1!.currentState!.validate()) {
        if(fName.isEmpty) {
          showCustomSnackBar('Enter delivery man first name'.tr);
        }else if(lName.isEmpty) {
          showCustomSnackBar('Enter delivery man last name'.tr);
        }else if(deliverymanRegistrationController.pickedImage == null) {
          showCustomSnackBar('Pick delivery man profile image'.tr);
        }else if(email.isEmpty) {
          showCustomSnackBar('Enter delivery man email address'.tr);
        }else if(!GetUtils.isEmail(email)) {
          showCustomSnackBar('Enter a valid email address'.tr);
        }else if(phone.isEmpty) {
          showCustomSnackBar('Enter delivery man phone number'.tr);
        }else if(!phoneValid.isValid) {
          showCustomSnackBar('Enter a valid phone number'.tr);
        }else if(password.isEmpty) {
          showCustomSnackBar('Enter password for delivery man'.tr);
        }else if(password != confirmPassword) {
          showCustomSnackBar('Confirm password does not matched'.tr);
        }else if(!deliverymanRegistrationController.spatialCheck || !deliverymanRegistrationController.lowercaseCheck || !deliverymanRegistrationController.uppercaseCheck || !deliverymanRegistrationController.numberCheck || !deliverymanRegistrationController.lengthCheck) {
          showCustomSnackBar('Provide valid password'.tr);
        } else {
          deliverymanRegistrationController.dmStatusChange(DMRegistrationSteps.stepTwo);
          setState(() {
            _selectedIndex = 1;
          });
        }
      }
    }else{
      _addDeliveryMan(deliverymanRegistrationController);
    }
  }

  void _addDeliveryMan(DeliverymanRegistrationController deliverymanRegiController) async {
    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();
    String numberWithCountryCode = _countryDialCode!+phone;

    if(!ResponsiveHelper.isDesktop(context)) {
      if (_formKeyStep2!.currentState!.validate()) {
        if (identityNumber.isEmpty) {
          showCustomSnackBar('Enter delivery man identity number'.tr);
        } else if (deliverymanRegiController.pickedImage == null) {
          showCustomSnackBar('Upload delivery man image'.tr);
        } else if (deliverymanRegiController.vehicleIndex! == -1) {
          showCustomSnackBar('Please select vehicle for the deliveryman'.tr);
        } else if (deliverymanRegiController.pickedIdentities.isEmpty) {
          showCustomSnackBar('Please upload identity image'.tr);
        } else if (deliverymanRegiController.dmTypeIndex == 0) {
          showCustomSnackBar('Please select deliveryman type'.tr);
        } else {
          deliverymanRegiController.registerDeliveryMan(DeliveryManBody(
            fName: fName,
            lName: lName,
            password: password,
            phone: numberWithCountryCode,
            email: email,
            identityNumber: identityNumber,
            identityType: deliverymanRegiController.identityTypeList[deliverymanRegiController.identityTypeIndex],
            earning: deliverymanRegiController.dmTypeIndex == 1 ? '1' : '0',
            zoneId: deliverymanRegiController.zoneList![deliverymanRegiController.selectedZoneIndex!].id.toString(),
            vehicleId: deliverymanRegiController.vehicles![deliverymanRegiController.vehicleIndex!].id.toString(),
          ));
        }
      }
    }

    if(ResponsiveHelper.isDesktop(context)) {
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      if(fName.isEmpty) {
        showCustomSnackBar('Enter delivery man first name'.tr);
        return;
      }else if(lName.isEmpty) {
        showCustomSnackBar('Enter delivery man last name'.tr);
        return;
      }else if(deliverymanRegiController.pickedImage == null) {
        showCustomSnackBar('Pick delivery man profile image'.tr);
        return;
      }else if(email.isEmpty) {
        showCustomSnackBar('Enter delivery man email address'.tr);
        return;
      }else if(!GetUtils.isEmail(email)) {
        showCustomSnackBar('Enter a valid email address'.tr);
        return;
      }else if(phone.isEmpty) {
        showCustomSnackBar('Enter delivery man phone number'.tr);
        return;
      }else if(!phoneValid.isValid) {
        showCustomSnackBar('Enter a valid phone number'.tr);
        return;
      }else if(password.isEmpty) {
        showCustomSnackBar('Enter password for delivery man'.tr);
        return;
      }else if(!deliverymanRegiController.spatialCheck || !deliverymanRegiController.lowercaseCheck || !deliverymanRegiController.uppercaseCheck || !deliverymanRegiController.numberCheck || !deliverymanRegiController.lengthCheck) {
        showCustomSnackBar('Provide valid password'.tr);
        return;
      }else if(identityNumber.isEmpty) {
        showCustomSnackBar('Enter delivery man identity number'.tr);
        return;
      }else if(deliverymanRegiController.pickedImage == null) {
        showCustomSnackBar('Upload delivery man image'.tr);
        return;
      }else if(deliverymanRegiController.vehicleIndex! == -1) {
        showCustomSnackBar('Please select vehicle for the deliveryman'.tr);
        return;
      }else if(deliverymanRegiController.pickedIdentities.isEmpty) {
        showCustomSnackBar('Please upload identity image'.tr);
        return;
      }else if(deliverymanRegiController.dmTypeIndex == 0) {
        showCustomSnackBar('Please select deliveryman type'.tr);
        return;
      }else {
        deliverymanRegiController.registerDeliveryMan(DeliveryManBody(
          fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
          identityNumber: identityNumber, identityType: deliverymanRegiController.identityTypeList[deliverymanRegiController.identityTypeIndex],
          earning: deliverymanRegiController.dmTypeIndex == 1 ? '1' : '0', zoneId: deliverymanRegiController.zoneList![deliverymanRegiController.selectedZoneIndex!].id.toString(),
          vehicleId: deliverymanRegiController.vehicles![deliverymanRegiController.vehicleIndex!].id.toString(),
        ));
      }
    }

  }

  Widget sectionCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
      // margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          child,
        ],
      ),
    );
  }
}

