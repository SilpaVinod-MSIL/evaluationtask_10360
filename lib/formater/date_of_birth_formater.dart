import 'package:flutter/services.dart';
class IntegerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final intRegex = RegExp(r'^[0-9]');
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (!intRegex.hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}