import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snabbit_task/constants.dart';
import 'package:snabbit_task/screens/sports_list_screen.dart';
import 'package:snabbit_task/utils/function_utils.dart';
import 'package:snabbit_task/utils/widget_utils.dart';

class SportDetailScreen extends StatefulWidget {
  final String sport;
  final String price;
  final String img;
  const SportDetailScreen(
      {Key? key, required this.sport, required this.price, required this.img})
      : super(key: key);

  @override
  State<SportDetailScreen> createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends State<SportDetailScreen> {
  final TextEditingController _startDateText =
      TextEditingController(text: DateTime.now().toString());
  String inTime = 'Choose In Time';
  String outTime = 'Choose Out Time';
  TimeOfDay initialTime = TimeOfDay.now();
  int selectedDuration = 60;
  String? price;

  @override
  Widget build(BuildContext context) {
    final double halfHeight = MediaQuery.of(context).size.height / 2.5;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Hero(
            tag: widget.img,
            child: Container(
              height: halfHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(widget.img),
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 40),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            alignment: AlignmentDirectional.topStart,
            child: IconButton(
                onPressed: () {
                  Get.to(const SportsListScreen());
                },
                icon: const Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.black,
                  size: 50,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.sport,
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  widget.price,
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  " ₹/hour",
                                  style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Date:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              UtilsWidgets.buildDatePicker(
                                'Choose a date',
                                'Choose a date',
                                _startDateText,
                                (val) {},
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 30)),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Select Duration:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    UtilsWidgets.buildSqureBtn(
                                      inTime,
                                      () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: initialTime,
                                        );
                                        setState(() {
                                          inTime = Utils.formatTimeOfDay(
                                              pickedTime!);
                                        });
                                      },
                                      Constants.primaryColor,
                                      Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    DropdownButton<int>(
                                      value: selectedDuration,
                                      items: [
                                        DropdownMenuItem(
                                            value: 60, child: Text("1 hour")),
                                        DropdownMenuItem(
                                            value: 90,
                                            child: Text("1.5 hours")),
                                        DropdownMenuItem(
                                            value: 120, child: Text("2 hours")),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDuration = value!;
                                        });
                                      },
                                    ),
                                    // UtilsWidgets.buildSqureBtn(
                                    //   outTime,
                                    //   () async {
                                    //     TimeOfDay? pickedTime =
                                    //         await showTimePicker(
                                    //       barrierDismissible: false,
                                    //       context: context,
                                    //       initialTime: initialTime,
                                    //     );
                                    //     setState(() {
                                    //       outTime = Utils.formatTimeOfDay(
                                    //           pickedTime!);
                                    //     });
                                    //   },
                                    //   Constants.primaryColor,
                                    //   Colors.white,
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              if (price != null)
                                Text(
                                  "Price: $price",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          Container(
                            width: 270,
                            height: 60,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 14, 206, 130),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton.icon(
                              onPressed: () {
                                fetchPrice();
                              },
                              icon: const Icon(
                                Icons.currency_rupee_sharp,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'GET PRICE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchPrice() async {
    String api =
        'https://asia-south1-turf-f1980.cloudfunctions.net/turf-function';

    String convertedTime = Utils.convertTo24HourFormat(inTime);
    String convertedDate =
        Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd');

    Map param = {
      "time": convertedTime,
      'sport': widget.sport,
      'duration': selectedDuration,
      'date': convertedDate,
    };
    final response = await http.post(Uri.parse(api),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(param));

    if (response.statusCode == 200) {
      setState(() {
        price = jsonDecode(response.body)['price'].toString();
      });
    } else {
      setState(() {
        price = 'Error fetching price';
      });
    }
  }
}
