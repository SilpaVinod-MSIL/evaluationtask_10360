import 'package:flutter/material.dart';
import '../constants/constants.dart';

class DateOfBirthFormatter {
  static var dayValue;
  static var monthValue;

  static void dateFormatter(
      TextEditingController dayController,
      FocusNode monthFocusNodes,
      String hintText,
      String value,
      ValueNotifier colorNotifier) {
    var day = int.tryParse(value);
    dayValue = day;
    if (value.length == AppConstants.twoText &&
        day != null &&
        day > AppConstants.thirtyOneText) {
      colorNotifier.value = Colors.red;
      dayController.text = value + AppConstants.slash;
      dayController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    } else if (value.length == AppConstants.twoText) {
      if (!value.contains(AppConstants.slash)) {
        dayController.text = value + AppConstants.slash;
        monthFocusNodes.requestFocus();
      } else {
        dayController.text = value.replaceAll("/", "");
        dayController.selection = TextSelection.fromPosition(
            TextPosition(offset: value.length - AppConstants.oneText));
      }
    }
    if (value.length == AppConstants.twoText &&
        dayValue == AppConstants.zeroText) {
      colorNotifier.value = Colors.red;
      monthFocusNodes.unfocus();
    }
  }

  static void monthFormatter(
      TextEditingController monthController,
      TextEditingController dayController,
      FocusNode yearFocusNodes,
      FocusNode dayFocusNodes,
      String hintText,
      String value,
      ValueNotifier colorNotifier) {
    final month = int.tryParse(value);
    monthValue = month;
    if ((dayValue == AppConstants.thirtyOneText &&
            month == AppConstants.fourText) ||
        (dayValue == AppConstants.thirtyOneText &&
            month == AppConstants.sixText) ||
        (dayValue == AppConstants.thirtyOneText &&
            month == AppConstants.nineText) ||
        (dayValue == AppConstants.thirtyOneText &&
            month == AppConstants.elevenText)) {
      colorNotifier.value = Colors.red;
      monthController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    } else if ((monthValue == AppConstants.twoText) &&
        (dayValue >= AppConstants.thirtyText)) {
      colorNotifier.value = Colors.red;
      yearFocusNodes.unfocus();
    } else if (value.length == AppConstants.twoText &&
        monthValue == AppConstants.zeroText) {
      colorNotifier.value = Colors.red;
      yearFocusNodes.unfocus();
    }
    if (value.length == AppConstants.twoText &&
        month != null &&
        month > AppConstants.twelveText) {
      colorNotifier.value = Colors.red;
      monthController.text = value + AppConstants.slash;
      monthController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    } else if (value.length == AppConstants.twoText) {
      if (!value.contains(AppConstants.slash)) {
        monthController.text = value + AppConstants.slash;
        yearFocusNodes.requestFocus();
      } else {
        monthController.text = value.replaceAll("/", "");
        monthController.selection = TextSelection.fromPosition(
            TextPosition(offset: value.length - AppConstants.oneText));
      }
    }
    if (value.isEmpty) {
      monthController.clear();
      dayFocusNodes.requestFocus();
      dayController.selection = TextSelection.fromPosition(
          TextPosition(offset: value.length + AppConstants.twoText));
    }
  }

  static void yearFormatter(
      TextEditingController yearController,
      TextEditingController monthController,
      FocusNode yearFocusNodes,
      FocusNode monthFocusNodes,
      String value,
      ValueNotifier colorNotifier) {
    final year = int.tryParse(value);
    if (value.length == AppConstants.fourText &&
            year != null &&
            (year > AppConstants.maxYearText) ||
        ((value.length == AppConstants.fourText) &&
            (year! < AppConstants.minYearText))) {
      colorNotifier.value = Colors.red;
      yearController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    } else if (value.length == AppConstants.fourText) {
      yearFocusNodes.unfocus();
    }

    if (value.isEmpty) {
      yearController.clear();
      monthFocusNodes.requestFocus();
      monthController.selection = TextSelection.fromPosition(
          TextPosition(offset: value.length + AppConstants.twoText));
    }
    int leapYear = year! % AppConstants.fourText;
    if (year.toString().length == AppConstants.fourText) {
      if ((monthValue == AppConstants.twoText) &&
          (leapYear == AppConstants.zeroText) &&
          (dayValue > AppConstants.twentyNineText)) {
        colorNotifier.value = Colors.red;
      } else if ((monthValue == AppConstants.twoText) &&
          (leapYear != AppConstants.zeroText) &&
          (dayValue > AppConstants.twentyEightText)) {
        colorNotifier.value = Colors.red;
      }
    }
  }
}
