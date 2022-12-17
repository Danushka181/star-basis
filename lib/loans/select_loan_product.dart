import 'dart:io';
import 'package:flutter/material.dart';

import '../loan_products/loan_products_add.dart';
import 'package:intl/intl.dart';
import '../screens/login_page.dart';
import '../services/globals.dart';
import '../services/loan_product_service.dart';
import '../widgets/common_card_five_select.dart';
import '../widgets/loading_widget.dart';

class SelectLoanProducts extends StatefulWidget {
  final Function onTap;
  final String activeColor;

  const SelectLoanProducts({Key? key, required this.onTap, required this.activeColor,}) : super(key: key);

  @override
  State<SelectLoanProducts> createState() => _SelectLoanProductsState();
}

class _SelectLoanProductsState extends State<SelectLoanProducts> {

  bool isLoading = true;
  late String customerCount   = '0';
  late List productsList;
  late List allProductsList;
  late List searchItems;

  getAllCustomerGroups() async {
    Route loginRoute = MaterialPageRoute(builder: (context) => const LoginPage());
    try{
      var response = await LoanProductsData.getLoanProductsList();
      if (response.statusCode == 200) {
        if(response.data['loan-products'].length != 0){
          setState(() {
            productsList = response.data['loan-products'];
            allProductsList = productsList;
            customerCount = allProductsList.length.toString();
            isLoading = false;
          });
        }else{
          if (!mounted) return;
          Route route =
          MaterialPageRoute(builder: (context) => const LoanProductsAdd());
          Navigator.pushReplacement(context, route);
        }
      } else {
        if (response.statusCode == 401) {
          if(!mounted) return;
          Navigator.pushReplacement(context, loginRoute);
        } else {
          if(!mounted) return;
          errorSnackBar(context, response['error']);
        }
      }

    }on SocketException {
      errorSnackBar(context, "No internet connection!");
      Navigator.pop(context);
      print('dsffdsfsfs');
    } on HttpException {
      errorSnackBar(context, "There is a problem when connecting to server!");
      Navigator.pop(context);
    } on FormatException {
      errorSnackBar(context, "Can't reach the server at the moment");
      Navigator.pop(context);
    }
  }

  loanProductsSearch(String query) {
    searchItems = [];
    if (query.isNotEmpty) {
      for (var item in allProductsList) {
        if (item['loan_product_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          searchItems.add(item);
        }
      }
      setState(() {
        productsList = searchItems;
      });
    } else {
      setState(() {
        productsList = allProductsList;
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
                hintText: "Search Loan Products..",
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
                loanProductsSearch(value);
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
                      itemCount: productsList != null ? productsList.length : 0,
                      itemBuilder: (_, index) {
                          return GestureDetector(
                              onTap: () {
                                widget.onTap(productsList[index]['id'].toString());
                              },
                              child: CommonCardFiveSelect(
                                cardHeading: productsList[index]['loan_product_name'],
                                cardSubHeading: "Document Charge is ${productsList[index]['document_charge']}%",
                                loanAmount: "Max : ${productsList[index]['max_loan_amount']}",
                                cardNumber: productsList[index]['id'].toString(),
                                activeColor: productsList[index]['id'].toString() == widget.activeColor ? Colors
                                    .greenAccent.withOpacity(0.2) : Colors.white,
                                createdAt: DateFormat.yMMMEd().format( DateTime.parse( productsList[index]['created_at']) .toLocal()),
                              ),

                          );
                      }
                  )
                      :
                  const LoadingWidget(),
                ],
              ),
            ),
          )
        ]
    );
  }

}
