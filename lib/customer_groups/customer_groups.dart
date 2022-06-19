import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:star_basis/customer_groups/single_group.dart';

import '../screens/login_page.dart';
import '../services/customer_groups.dart';
import '../services/globals.dart';
import '../widgets/app_bar.dart';
import '../widgets/big_text_widget.dart';
import '../widgets/common_card_three.dart';
import 'add_group.dart';

class CustomerGroups extends StatefulWidget {
  const CustomerGroups({Key? key}) : super(key: key);

  @override
  State<CustomerGroups> createState() => _CustomerGroupsState();
}

class _CustomerGroupsState extends State<CustomerGroups> {
  bool isLoading = true;
  late List groupList;
  late List allGroupList;
  late List searchItems;

  getAllCustomerGroups() async {
    http.Response response = await CustomerGroupServices.getAllCustomerGroups();
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        groupList = responseMap['groups'];
        allGroupList = groupList;
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

  centersSearch(String query) {
    searchItems = [];
    if (query.isNotEmpty) {
      for (var item in allGroupList) {
        if (item['group_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          searchItems.add(item);
        }
      }
      setState(() {
        groupList = searchItems;
      });
    } else {
      setState(() {
        groupList = allGroupList;
      });
    }
  }

  // fetch data form user comming to screen
  @override
  void initState() {
    getAllCustomerGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: 'Groups List'),
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
                    hintText: "Search Groups..",
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
                  content: 'Groups',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  colorCode: Colors.black54.withOpacity(0.5),
                ),
              ),
              isLoading == false
                  ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: groupList != null ? groupList.length : 0,
                  itemBuilder: (_, index) {
                    Map<String, dynamic> userdata = groupList[index]['user'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SingleGroup(
                                  centerId: groupList[index]['id'].toString(),
                                  centerName: groupList[index]['group_name']
                                      .toString(),
                                  centerAddress: groupList[index]['group_desc']
                                      .toString(),
                                  centerCreated: groupList[index]['created_at']
                                      .toString(),
                                  centerUser: userdata['name'].toString(),
                                ),
                          ),
                        );
                      },
                      child: CommonCardThree(
                          cardNumber: groupList[index]['id'].toString(),
                          cardHeading:
                          groupList[index]['group_name'].toString(),
                          createdDate: DateFormat.yMMMEd().format(
                              DateTime.parse(
                                  groupList[index]['created_at'])
                                  .toLocal()),
                          createdBy:
                          userdata['name'].toString(),
                          cardSubHeading: groupList[index]
                          ['group_desc']),
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
                      builder: (BuildContext context) => const AddNewGroup()));
            },
          ),
        ));
  }
}
