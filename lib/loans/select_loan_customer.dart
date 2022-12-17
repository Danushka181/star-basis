import 'dart:io';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../customers/add_new_customer.dart';
import '../screens/login_page.dart';
import '../services/customers_services.dart';
import '../services/globals.dart';
import '../widgets/common_card_customer.dart';
import '../widgets/common_card_customer_select.dart';
import '../widgets/loading_widget.dart';

class SelectLoanCustomer extends StatefulWidget {
  final Function onTap;
  final String activeColor;

  const SelectLoanCustomer({Key? key, required this.onTap, required this.activeColor,}) : super(key: key);

  @override
  State<SelectLoanCustomer> createState() => _SelectLoanCustomerState();
}

class _SelectLoanCustomerState extends State<SelectLoanCustomer> {

  bool isLoading = true;
  late List customersList;
  late List allCustomersList;
  late List searchItems;

  getAllCustomersList() async {
    try{
      var response = await CustomersService.allCustomers();
      if (response.statusCode == 200) {
        if( response.data['customers'].length != 0){
          setState(() {
            customersList = response.data['customers'];
            allCustomersList = customersList;
            isLoading = false;
          });
        }else{
          if(!mounted) return;
          Route route =
          MaterialPageRoute(builder: (context) => const AddNewCustomers());
          Navigator.pushReplacement(context, route);
        }
      } else {
        if (response.statusCode == 401) {
          if(!mounted) return;
          Route route =
          MaterialPageRoute(builder: (context) => const LoginPage());
          Navigator.pushReplacement(context, route);
        } else {
          if(!mounted) return;
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
      for( var item in allCustomersList){
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
        customersList = searchItems;
      });
    }else{
      setState(() {
        customersList = allCustomersList;
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
    return Stack(
        children: [
          Positioned(
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
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isLoading == false ?
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: customersList != null ? customersList.length : 0,
                      itemBuilder: (_, index) {
                        Map<String, dynamic> userData   = customersList[index]['user'];
                        return GestureDetector(
                          onTap: () {
                            widget.onTap(customersList[index]['id'].toString());
                          },
                          child: CommonCardCustomerSelect(
                            cardNumber: customersList[index]['id'].toString(),
                            cardHeading:
                            customersList[index]['c_name'].toString(),
                            createdDate: DateFormat.yMMMEd().format(
                                DateTime.parse(
                                    customersList[index]['created_at'])
                                    .toLocal()),
                            createdBy: userData['name'].toString(),
                            cardSubHeading: customersList[index]
                            ['c_address'],
                            idNumber: 'ID NUM : ${customersList[index]['c_id_number']}',
                            activeColor: customersList[index]['id'].toString() == widget.activeColor ? Colors
                                .greenAccent.withOpacity(0.2) : Colors.white,
                          ),
                        );
                      }
                  )
                      :
                  const LoadingWidget()
                ],
              ),
            ),
          )
        ]
    );
  }

}
