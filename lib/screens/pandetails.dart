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
  final ValueNotifier<Color> colorSlashDate = ValueNotifier(Colors.grey);
  final ValueNotifier<Color> colorSlashMonth = ValueNotifier(Colors.grey);


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
                         padding: const EdgeInsets.only(top: 12,left: 8),
                         child: Row(
                            children: [
                              dateOfBirthTextField(_dayController, _dayFocusNodes, AppConstants.twoText, AppConstants.dateText, AppConstants.sizeTwentyFive),
                              ValueListenableBuilder<Color>(
                                  valueListenable: colorSlashDate,
                                  builder: (context, color, child) {
                                    return Text(AppConstants.slash,style:TextStyle(color:color,fontWeight: FontWeight.bold,fontSize: AppConstants.fontSize));
                                  }),
                              dateOfBirthTextField(_monthController, _monthFocusNodes, AppConstants.twoText, AppConstants.monthText, AppConstants.sizeThirty),
                              ValueListenableBuilder<Color>(
                                  valueListenable: colorSlashMonth,
                                  builder: (context, color, child) {
                                    return Text(AppConstants.slash,style:TextStyle(color:color,fontWeight: FontWeight.bold,fontSize: AppConstants.fontSize));
                                  }),
                              dateOfBirthTextField(_yearController, _yearFocusNodes, AppConstants.fourText, AppConstants.yearText,  AppConstants.sizeFortyFive),
                            ],
                          ),
                       ),
                      Row(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder<Color>(
                                valueListenable: colorNotifier,
                                builder: (context, color, child) {
                                  return Divider(thickness: AppConstants.sizeTwo, color: color);
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
          hintText: hintText,hintStyle:  TextStyle(color: Colors.grey,fontSize: AppConstants.fontSize),
          counterText: "",
        ),
        onChanged: (value) {
          colorNotifier.value = Colors.blue;

          if (hintText == AppConstants.dateText) {
            DateOfBirthFormatter.dateFormatter(_dayController, _monthFocusNodes, hintText, value, colorNotifier);
            (value.length==AppConstants.twoText)?colorSlashDate.value=Colors.black:colorSlashDate.value=Colors.grey;

          } else if (hintText == AppConstants.monthText) {
            DateOfBirthFormatter.monthFormatter(_monthController, _dayController, _yearFocusNodes, _dayFocusNodes, hintText, value, colorNotifier);
            (value.length==AppConstants.twoText)?colorSlashMonth.value=Colors.black:colorSlashMonth.value=Colors.grey;

          } else {
            DateOfBirthFormatter.yearFormatter(_yearController, _monthController, _yearFocusNodes, _monthFocusNodes, value, colorNotifier);
          }
        },
      ),
    );
  }
}
