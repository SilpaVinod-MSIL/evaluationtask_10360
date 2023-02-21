import 'package:evaluationtask_10360/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formatter/date_of_birth_formatter.dart';

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
  final ValueNotifier<Color> colorNotifier = ValueNotifier(Colors.grey);

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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(AppConstants.panCardAppBar),
          ),
          body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
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
                            dateOfBirthTextField(_dayController, _dayFocusNodes,
                                2, AppConstants.dateText, 35),
                            dateOfBirthTextField(_monthController,
                                _monthFocusNodes, 2, AppConstants.monthText, 35),
                            Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: dateOfBirthTextField(
                                    _yearController,
                                    _yearFocusNodes,
                                    4,
                                    AppConstants.yearText,
                                    40)),
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
                ),
          )
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          counterText: "",
        ),
        onChanged: (value) {
          colorNotifier.value = Colors.blue;
          if (hintText == AppConstants.dateText) {
            DateOfBirthFormatter.dateFormatter(_dayController, _monthFocusNodes,
                hintText, value, colorNotifier);
          } else if (hintText == AppConstants.monthText) {
            DateOfBirthFormatter.monthFormatter(
                _monthController,
                _dayController,
                _yearFocusNodes,
                _dayFocusNodes,
                hintText,
                value,
                colorNotifier);
          } else {
            DateOfBirthFormatter.yearFormatter(
                _yearController,
                _monthController,
                _yearFocusNodes,
                _monthFocusNodes,
                value,
                colorNotifier);
          }
        },
      ),
    );
  }
}
