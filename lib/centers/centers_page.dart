import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:star_basis/centers/add_centers.dart';
import 'package:star_basis/centers/single_center.dart';

import '../screens/login_page.dart';
import '../services/centers_service.dart';
import '../services/globals.dart';
import '../widgets/app_bar.dart';
import '../widgets/big_text_widget.dart';
import '../widgets/common_card_three.dart';

class CentersPage extends StatefulWidget {
  const CentersPage({Key? key}) : super(key: key);

  @override
  State<CentersPage> createState() => _CentersPageState();
}

class _CentersPageState extends State<CentersPage> {
  bool isLoading = true;
  late List centersList;
  late List allCentersList;
  late List searchItems;

  getAllCenters() async {
    http.Response response = await CentersService.allCenters();
    Map responseMap = jsonDecode(response.body);
    // print(responseMap['centers']);

    if (response.statusCode == 200) {
      setState(() {
        centersList = responseMap['centers'];
        allCentersList = centersList;
        isLoading = false;
      });
    } else {
      if (response.statusCode == 401) {
        Route route =
            MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        errorSnackBar(context, responseMap['error']);
      }
    }
  }

  void centersSearch(String query) {
    searchItems = [];
    if (query.isNotEmpty) {
      for (var item in allCentersList) {
        if (item['center_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          searchItems.add(item);
        }
      }
      setState(() {
        centersList = searchItems;
      });
    } else {
      setState(() {
        centersList = allCentersList;
      });
    }
  }

  @override
  void initState() {
    getAllCenters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: 'Centers List'),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 15, right: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search centers..",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black54.withOpacity(0.5),
                    ),
                    hintStyle: TextStyle(
                        color: Colors.black54.withOpacity(0.5),
                        fontStyle: FontStyle.italic),
                  ),
                  style: TextStyle(
                      color: Colors.black54.withOpacity(0.5),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                  onChanged: (value) {
                    centersSearch(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 30, right: 20, bottom: 5),
                child: BigTextWidget(
                  content: 'Centers',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  colorCode: Colors.black54.withOpacity(0.5),
                ),
              ),
              isLoading == false
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: centersList != null ? centersList.length : 0,
                      itemBuilder: (_, index) {
                        print(centersList[index]['user']);
                        Map<String, dynamic> userData   = centersList[index]['user'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleCenter(
                                    centerId: centersList[index]['id'].toString(),
                                    centerName: centersList[index]['center_name'].toString(),
                                    centerAddress: centersList[index]['center_address'].toString(),
                                    centerCreated: centersList[index]['created_at'].toString(),
                                    centerUser: userData['name'].toString(),
                                ),
                              ),
                            );
                          },
                          child: CommonCardThree(
                              cardNumber: centersList[index]['id'].toString(),
                              cardHeading:
                                  centersList[index]['center_name'].toString(),
                              createdDate: DateFormat.yMMMEd().format(
                                  DateTime.parse(
                                          centersList[index]['created_at'])
                                      .toLocal()),
                              createdBy: userData['name'].toString(),
                              cardSubHeading: centersList[index]
                                  ['center_address']),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.lightGreen,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Loading..',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            child: const Icon(Icons.add), //child widget inside this button
            backgroundColor: Colors.lightGreen,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const AddNewCenter()));
            },
          ),
        ));
  }
}
