import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../screens/login_page.dart';
import '../services/customer_groups.dart';
import '../services/globals.dart';
import '../widgets/common-card-four.dart';

class SelectMemberGroup extends StatefulWidget {
  final Function onTap;
  final String activeColor;

  const SelectMemberGroup({Key? key, required this.onTap, required this.activeColor,}) : super(key: key);

  @override
  State<SelectMemberGroup> createState() => _SelectMemberGroupState();
}

class _SelectMemberGroupState extends State<SelectMemberGroup> {

  bool isLoading = true;
  late List groupList;
  late List allGroupList;
  late List searchItems;

  getAllCustomerGroups() async {
    Route route = MaterialPageRoute(builder: (context) => const LoginPage());
    try{
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
          Navigator.pushReplacement(context, route);
        } else {
          errorSnackBar(context, responseMap['error']);
        }
      }
    }on SocketException {
      errorSnackBar(context, "No internet connection!");
      Navigator.pushReplacement(context, route);
    } on HttpException {
      errorSnackBar(context, "There is a problem when connecting to server!");
      Navigator.pushReplacement(context, route);
    } on FormatException {
      errorSnackBar(context, "Can't reach the server at the moment");
      Navigator.pushReplacement(context, route);
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

  @override
  void initState() {
    getAllCustomerGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned(
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
            padding: const EdgeInsets.only(top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isLoading == false ?
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: groupList != null ? groupList.length : 0,
                      itemBuilder: (_, index) {
                        List usersArray = groupList[index]['users_set'] as List;
                          if (usersArray.length < 5) {
                            return GestureDetector(
                                onTap: () {
                                  widget.onTap(groupList[index]['id'].toString());
                                },
                                child: CommonCardFour(
                                  usersCount: usersArray.length.toString(),
                                  cardNumber: groupList[index]['id'].toString(),
                                  cardHeading: groupList[index]['group_name'].toString(),
                                  activeColor: groupList[index]['id'].toString() == widget.activeColor ? Colors
                                      .greenAccent.withOpacity(0.2) : Colors.white,
                                )
                              );
                            }
                            return Container();
                          }
                      )
                      :
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 80,),
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
                ],
              ),
            ),
          )
        ]
    );
  }

}
