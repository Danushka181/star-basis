import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/customers/add_new_customer.dart';
import 'package:star_basis/customers/single_customer.dart';
import 'package:star_basis/services/customers_services.dart';

import '../../screens/login_page.dart';
import '../../services/globals.dart';
import '../../widgets/big_text_widget.dart';
import '../../widgets/common_card_customer.dart';
import '../../widgets/loading_widget.dart';

class SecondTab extends StatefulWidget {
  const SecondTab({Key? key}) : super(key: key);

  @override
  State<SecondTab> createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {

  late String _customerCount   = '0';
  late List _allCustomers;
  late List _searchCustomers;
  late List _customerList;

  bool isLoading = true;

  getAllCustomersList() async {
    try{
      var response = await CustomersService.allCustomers();
      if (response.statusCode == 200) {
        if( response.data['customers'].length != 0){
          setState(() {
            _customerList = response.data['customers'];
            _allCustomers = _customerList;
            _customerCount= _allCustomers.length.toString();
            isLoading = false;
          });
        }else{
          Route route =
          MaterialPageRoute(builder: (context) => const AddNewCustomers());
          Navigator.pushReplacement(context, route);
        }
      } else {
        if (response.statusCode == 401) {
          Route route =
          MaterialPageRoute(builder: (context) => const LoginPage());
          Navigator.pushReplacement(context, route);
        } else {
          errorSnackBar(context, response['error']);
        }
      }

    }on SocketException {
      errorSnackBar(context, "No internet connection!");
      Navigator.pop(context);
    } on HttpException {
      errorSnackBar(context, "There is a problem when connecting to server!");
      Navigator.pop(context);
    } on FormatException {
      errorSnackBar(context, "Can't reach the server at the moment");
      Navigator.pop(context);
    }
  }

  void searchCustomers(String query) {
    if( query.isNotEmpty){
      var searchItems = [];
      for( var item in _allCustomers){
        if(
        item['id'].toString().contains(query) ||
        item['c_name'].toString().contains(query) ||
        item['c_id_number'].toString().contains(query) ||
        item['c_mobile_number'].toString().contains(query)  ){
          setState(() {
            searchItems.add(item);
          });
        }
      }
      setState(() {
        _customerList = searchItems;
      });
    }else{
      setState(() {
        _customerList = _allCustomers;
      });
    }
  }

  @override
  void initState() {
    getAllCustomersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 15, right: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Customers..",
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
                    searchCustomers(value);
                  },
                ),
              ),
              // Customer list title and count
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 30, right: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        BigTextWidget(
                          content: 'Customers List',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          colorCode: Colors.black54.withOpacity(0.5),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left:10,top: 5,right: 10,bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.black54,
                          ),
                          child: Text(
                              _customerCount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // Progress bar
              isLoading == false ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _customerList != null ? _customerList.length : 0,
                  itemBuilder: (_, index) {
                    Map<String, dynamic> userData   = _customerList[index]['user'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleCustomer(
                              customerName: _customerList[index]['c_name'].toString(),
                              customerId: _customerList[index]['id'].toString(),
                            ),
                          ),
                        );
                      },
                      child: CommonCardCustomer(
                          cardNumber: _customerList[index]['id'].toString(),
                          cardHeading:
                          _customerList[index]['c_name'].toString(),
                          createdDate: DateFormat.yMMMEd().format(
                              DateTime.parse(
                                  _customerList[index]['created_at'])
                                  .toLocal()),
                          createdBy: userData['name'].toString(),
                          cardSubHeading: _customerList[index]
                          ['c_address'],
                        idNumber: 'ID NUM : '+ _customerList[index]['c_id_number'],),
                    );
                  })

              : const LoadingWidget(),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),

        // Add new customer btn
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            child: const Icon(Icons.add), //child widget inside this button
            backgroundColor: Colors.lightGreen,
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const AddNewCustomers()));
            },
          ),
        ));
  }
}
