import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:snabbit_task/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snabbit_task/screens/sports_detail_screen.dart';
import 'package:snabbit_task/utils/function_utils.dart';
import 'package:snabbit_task/utils/widget_utils.dart';

class SportsListScreen extends StatefulWidget {
  const SportsListScreen({Key? key}) : super(key: key);

  @override
  State<SportsListScreen> createState() => _SportsListScreenState();
}

class _SportsListScreenState extends State<SportsListScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchText = TextEditingController(text: '');
  CollectionReference users = FirebaseFirestore.instance.collection('sports');
  List searchMap = [];
  List productMap = [];

  @override
  void initState() {
    getSports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromARGB(255, 244, 244, 244),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.keyboard_arrow_left),
                    ),
                    TweenAnimationBuilder(
                        child: Text(
                          'Book Turf',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.deepPurple,
                          ),
                        ),
                        tween: Tween<double>(begin: 0, end: 10),
                        duration: const Duration(seconds: 3),
                        builder: (context, value, child) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(value, 0, 0, 0),
                              child: child);
                        }),
                  ],
                ),
                TweenAnimationBuilder(
                    child: Container(
                      alignment: Alignment.topRight,
                      height: 180,
                      child: Image.asset('assets/images/sports.png'),
                    ),
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    })
              ],
            ),
            UtilsWidgets.textFormField(
              "Search sport",
              "Eg. cricket",
              (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter sport name";
                }
              },
              _searchText,
              prefixIcon: Icon(Icons.search),
              onChanged: (p0) {
                setState(() {
                  if (_searchText.text.isEmpty) {
                    productMap = searchMap;
                    FocusScope.of(context).unfocus();
                  } else {
                    productMap = searchMap
                        .where((element) => element['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchText.text))
                        .toList();
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            productMap.isEmpty
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: productMap.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(SportDetailScreen(
                                sport: productMap[index]['name'],
                                price: productMap[index]['updatedPrice'],
                                img:
                                    'assets/images/${productMap[index]['image']}'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  child: Hero(
                                    tag:
                                        'assets/images/${productMap[index]['image']}',
                                    child: Image.asset(
                                        width: 150,
                                        height: 130,
                                        'assets/images/${productMap[index]['image']}'),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 20,
                                          child: Text(
                                            productMap[index]['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: double.infinity,
                                          height: 32,
                                          child: Row(
                                            children: [
                                              Text(
                                                productMap[index]
                                                    ['updatedPrice'],
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                productMap[index]['price'],
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              const Text(
                                                "₹/hour",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.black38,
                                                        width: 0.5,
                                                      )),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        productMap[index]
                                                                ['isClicked'] =
                                                            !productMap[index]
                                                                ['isClicked'];
                                                      });
                                                    },
                                                    icon: productMap[index]
                                                            ['isClicked']
                                                        ? const Icon(
                                                            Icons.favorite)
                                                        : const Icon(Icons
                                                            .favorite_border),
                                                    color:
                                                        Constants.primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              14,
                                                              206,
                                                              130),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.black38,
                                                        width: 0.5,
                                                      )),
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(Icons
                                                        .currency_rupee_outlined),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  getSports() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('sports');
      QuerySnapshot snapshot = await users.get();

      List<Map<String, dynamic>> fetchedData = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      for (var i = 0; i < fetchedData.length; i++) {
        fetchedData[i]['updatedPrice'] =
            await fetchPrice(fetchedData[i]['name']);
      }
      setState(() {
        searchMap = fetchedData;
        productMap = List.from(searchMap);
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  fetchPrice(String sport) async {
    String api =
        'https://asia-south1-turf-f1980.cloudfunctions.net/turf-function';

    String convertedTime = '12:00';
    String convertedDate = Utils.formatDate(DateTime.now(), 'yyyy-MM-dd');

    Map param = {
      "time": convertedTime,
      'sport': sport,
      'duration': 60,
      'date': convertedDate,
    };
    final response = await http.post(Uri.parse(api),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(param));

    String price = jsonDecode(response.body)['price'].toString() ?? "0";

    return price;
  }
}
