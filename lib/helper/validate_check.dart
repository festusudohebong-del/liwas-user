import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ValidateCheck{

  static String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final kEmailValid = RegExp(pattern);
    bool isValid = kEmailValid.hasMatch(value.toString());
    if (value!.isEmpty) {
      return '\u26A0 ${'Email field is required'.tr}';
    } else if (isValid == false) {
      return '\u26A0 ${"Enter valid email address".tr}';
    }
    return null;
  }

  static String? validateEmptyText(String? value, String? message) {
    if (value == null || value.isEmpty) {
      return message?.tr ?? 'This field is required'.tr;
    }
    return null;
  }

  static String? validatePhone(String? value, String? message) {
    if (value == null || value.isEmpty) {
      return message?.tr ?? 'This field is required'.tr;
    }
    return null;
  }

  static String? validatePassword(String? value, String? message) {
    if (value == null || value.isEmpty) {
      return message?.tr ?? 'This field is required'.tr;
    }else if(value.length < 8){
      return 'Minimum password is 8 character'.tr;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password field is required'.tr;
    }else if(value != password){
      return 'Confirm password does not matched'.tr;
    }
    return null;
  }

  static String? loyaltyCheck(String? value, int? minimumExchangePoint, int? point) {
    int amount = 0;
    if(value != null && value.isNotEmpty) {
      amount = int.parse(value);
    }
    if (value == null || value.isEmpty) {
      return 'This field is required'.tr;
    }else if(amount < minimumExchangePoint!){
      return '${'Please exchange more then'.tr} $minimumExchangePoint ${'Points'.tr}';
    }else if(point! < amount){
      return 'You do not have enough point to exchange'.tr;
    }
    return null;
  }

  static String getValidPhone(String number, {bool withCountryCode = false}) {
    bool isValid = false;
    String phone = "";

    try{
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      if(isValid){
        phone = withCountryCode ? "+${phoneNumber.countryCode}${phoneNumber.nsn}" : phoneNumber.nsn.toString();
        if (kDebugMode) {
          print("Phone Number : $phone");
        }
      }
    }catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return phone;
  }

}
