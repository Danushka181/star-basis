import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../customer_groups/single_group.dart';
import '../screens/login_page.dart';
import '../services/customer_groups.dart';
import '../services/globals.dart';
import '../widgets/common_card_details_row.dart';
import '../widgets/common_card_three.dart';

class SelectMemberGroup extends StatefulWidget {
  final Function onTap;

  const SelectMemberGroup({Key? key, required this.onTap,}) : super(key: key);

  @override
  State<SelectMemberGroup> createState() => _SelectMemberGroupState();
}

class _SelectMemberGroupState extends State<SelectMemberGroup> {

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
    print(allGroupList);
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
            top: 0,
            child: CommonCardUserRow(rowHeading: '', rowValue: 'Select a Group for this member :'),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                isLoading == false
                    ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: groupList != null ? groupList.length : 0,
                    itemBuilder: (_, index) {
                      Map<String, dynamic> userdata = groupList[index]['user'];
                      Map<String, dynamic> centerData = groupList[index]['center'];
                      return GestureDetector(
                        onTap: () {

                        },
                        child: CommonCardThree(
                            cardNumber: groupList[index]['id'].toString(),
                            cardHeading: groupList[index]['group_name'].toString(),
                            createdDate: DateFormat.yMMMEd()
                                .format(DateTime.parse(groupList[index]['created_at']).toLocal()),
                            createdBy: userdata['name'].toString(),
                            cardSubHeading: groupList[index]['group_desc']),
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
              ],
            ),
          ),
        ]
    );
  }

}
