import 'package:flutter/material.dart';
import 'package:snabbit_task/constants.dart';

class DecorationWidgets {
  static buildCategoryTag(bool isSelect, String category, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // constraints: BoxConstraints(maxWidth: 240),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: isSelect ? Colors.purple[100] : Colors.white,
            // border: Border.all(
            //   color: Colors.black38,
            //   width: 0.5,
            // ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              isSelect
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.check,
                        color: Colors.deepPurple,
                      ),
                    )
                  : Container(),
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: isSelect ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showProgressDialog() {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                semanticsLabel: 'Please wait',
                strokeWidth: 5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constants.primaryColor),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Please wait',
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ]));
  }
}
