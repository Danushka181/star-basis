import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../services/customer_groups.dart';
import '../widgets/app_bar.dart';

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
        appBar: const AppBarWidget(title: 'Customer Groups'),
        body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Text('ss'),
          ],
        ),
      ),
    );

  }
}
