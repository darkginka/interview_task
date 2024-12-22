import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snabbit_task/constants.dart';

class UtilsWidgets {
  static buildAppBar(BuildContext context, String title,
      {List<Widget>? Widgets, bool backBtn = true}) {
    return AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 60,
        title: Text(
          title,
          maxLines: 3,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.048,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: Widgets,
        automaticallyImplyLeading: backBtn,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Constants.primaryColor),
        ));
  }

  static textFormField(String? labelText, String hintText,
      String? Function(String?)? validator, TextEditingController? controller,
      {bool isReadOnly = false,
      TextInputType textInputType = TextInputType.text,
      bool obscure = false,
      int maxLine = 1,
      Widget? icon,
      Widget? suffixIcon,
      Widget? prefixIcon,
      Key? key,
      String? Function(String)? onChanged,
      List<TextInputFormatter>? inputFormatter,
      TextInputAction textInputAction = TextInputAction.next}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Container(
        child: TextFormField(
          onChanged: onChanged,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 1),
          key: key,
          textInputAction: textInputAction,
          autofocus: false,
          keyboardType: textInputType,
          inputFormatters: inputFormatter,
          controller: controller,
          validator: validator,
          obscureText: obscure,
          maxLines: maxLine,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.black, width: 0.0),
            ),
            // contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            icon: icon,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            labelText: labelText,
          ),
        ),
      ),
    );
  }

  static buildSqureBtn(
      String? btnName, Function()? onpress, Color? txtcolor, Color? bgcolor,
      {Color bordercolor = const Color.fromARGB(255, 17, 11, 68)}) {
    return Center(
      child: ElevatedButton(
        onPressed: onpress,
        child: Text(
          '$btnName',
          textAlign: TextAlign.center,
          style: TextStyle(color: txtcolor),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 10,
          backgroundColor: bgcolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: bordercolor,
              )),
        ),
      ),
    );
  }

  static buildRoundBtn(String? btnsend, Function()? onPressed) {
    return SizedBox(
      height: 50,
      width: 190,
      child: ElevatedButton(
          child: Text(
            "$btnsend",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Constants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Constants.primaryColor),
            ),
          ),
          // TODO: Add the style for the ElevatedButton
          onPressed: onPressed),
/******  20f6dc42-03ba-43c3-a920-e6accfdca9a3  *******/
    );
  }

  static buildDatePicker(
    String dateLabelText,
    String hintText,
    TextEditingController editingController,
    Function(String)? onChanged, {
    DateTime? firstDate,
    DateTime? lastDate,
    DateTimePickerType date = DateTimePickerType.date,
    String dateMask = 'd MMM, yyyy',
    IconData icon = Icons.calendar_today,
    bool Function(DateTime)? selectableDayPredicate,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: DateTimePicker(
        selectableDayPredicate: selectableDayPredicate,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(width: 2.0),
            ),
            // icon: Icon(icon),
            hintText: hintText,
            labelText: dateLabelText,
            labelStyle: TextStyle(color: Colors.grey)),
        type: date,
        dateMask: dateMask,
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
        // icon: const Icon(Icons.event),
        controller: editingController,
        onChanged: onChanged,
        validator: (val) {
          if (val!.isEmpty) {
            return "Please Choose Date";
          }
          return null;
        },
      ),
    );
  }

  static showDialogBox(
      BuildContext context,
      String btn1Name,
      String btn2Name,
      Function()? btn1Pressed,
      Function()? btn2Pressed,
      String? title,
      List<Widget> WidgetList) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          "$title",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: WidgetList,
        ),
      ),
      actions: [
        TextButton(
          child: Text('$btn1Name'),
          onPressed: btn1Pressed,
        ),
        TextButton(
          child: Text('$btn2Name'),
          onPressed: btn2Pressed,
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showToastFunc(message) {
    return Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Constants.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
