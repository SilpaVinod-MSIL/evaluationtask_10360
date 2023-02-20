import 'package:evaluationtask_10360/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formater/date_of_birth_formater.dart';

class PanDetailScreen extends StatefulWidget {
  const PanDetailScreen({Key? key}) : super(key: key);

  @override
  _PanDetailScreenState createState() => _PanDetailScreenState();
}

class _PanDetailScreenState extends State<PanDetailScreen> {
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _dayFocusNodes = FocusNode();
  final _monthFocusNodes = FocusNode();
  final _yearFocusNodes = FocusNode();
  final IntegerInputFormatter integerInputFormatter = IntegerInputFormatter();
  final ValueNotifier<Color> colorNotifier = ValueNotifier(Colors.grey);
  var dayValue;

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _dayFocusNodes.dispose();
    _monthFocusNodes.dispose();
    _yearFocusNodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text(AppConstants.panCardAppBar),
          ),
          body: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
                      child: Text(AppConstants.panDetails),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 8),
                      child: Row(
                        children: [
                          dateOfBirthTextField(_dayController, _dayFocusNodes, 2, AppConstants.dateText, 35),
                          dateOfBirthTextField(_monthController, _monthFocusNodes, 2, AppConstants.monthText, 35),
                          Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: dateOfBirthTextField(_yearController, _yearFocusNodes, 4, AppConstants.yearText, 40)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<Color>(
                              valueListenable: colorNotifier,
                              builder: (context, color, child) {
                                return Divider(thickness: 2, color: color);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  dateOfBirthTextField(TextEditingController controller, FocusNode focusNode,
      int length, String hintText, double widthSize) {
    return SizedBox(
      width: widthSize,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: length,
        inputFormatters: [integerInputFormatter],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          counterText: "",
        ),
        onChanged: (value) {
          colorNotifier.value = Colors.blue;
          if (hintText == AppConstants.dateText) {
            var day = int.tryParse(value);
            dayValue = day;
            if (value.length == AppConstants.twoText &&
                day != null &&
                day > AppConstants.thirtyOneText) {
              colorNotifier.value = Colors.red;
              _dayController.text = value + AppConstants.slash;
              _dayController.selection = TextSelection.fromPosition(
                  TextPosition(offset: value.length));
            } else if (value.length == AppConstants.twoText) {
              if (!value.contains(AppConstants.slash)) {
                _dayController.text = value + AppConstants.slash;
                _monthFocusNodes.requestFocus();
              } else {
                _dayController.text = value.replaceAll("/", "");
                _dayController.selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length - 1));
              }
            }
          } else if (hintText == AppConstants.monthText) {
            final month = int.tryParse(value);
            if ((dayValue == 31 && month == 4) ||
                (dayValue == 31 && month == 6) ||
                (dayValue == 31 && month == 9) ||
                (dayValue == 31 && month == 11)) {
              colorNotifier.value = Colors.red;
            } else if (dayValue > 29 && month == 2) {
              colorNotifier.value = Colors.red;
            }
            if (value.length == AppConstants.twoText &&
                month != null &&
                month > AppConstants.twelveText) {
              colorNotifier.value = Colors.red;
              _monthController.text = value + AppConstants.slash;
              _monthController.selection = TextSelection.fromPosition(
                  TextPosition(offset: value.length));
            } else if (value.length == AppConstants.twoText) {
              if (!value.contains(AppConstants.slash)) {
                _monthController.text = value + AppConstants.slash;
                _yearFocusNodes.requestFocus();
              } else {
                _monthController.text = value.replaceAll("/", "");
                _monthController.selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length - 1));
              }
            }
            if (value.isEmpty) {
              _monthController.clear();
              _dayFocusNodes.requestFocus();
              _dayController.selection = TextSelection.fromPosition(
                  TextPosition(offset: value.length + AppConstants.twoText));
            }
          } else {
            final year = int.tryParse(value);
            if (value.length == AppConstants.fourText &&
                    year != null &&
                    (year > AppConstants.maxYearText) ||
                ((value.length == AppConstants.fourText) &&
                    (year! < AppConstants.minYearText))) {
              colorNotifier.value = Colors.red;
              _yearController.selection = TextSelection.fromPosition(
                  TextPosition(offset: value.length));
            } else if (value.length == AppConstants.fourText) {
              _yearFocusNodes.unfocus();
            }

            if (value.isEmpty) {
              _yearController.clear();
              _monthFocusNodes.requestFocus();
              _monthController.selection = TextSelection.fromPosition(
                  TextPosition(offset: value.length + AppConstants.twoText));
            }
          }
        },
      ),
    );
  }
}
