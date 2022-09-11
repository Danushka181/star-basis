import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/widgets/common_card_five.dart';
import '../screens/login_page.dart';
import '../services/globals.dart';
import '../services/loan_product_service.dart';
import '../widgets/app_bar.dart';
import '../widgets/big_text_widget.dart';
import '../widgets/common-card-four.dart';
import '../widgets/loading_widget.dart';

class LoanProducts extends StatefulWidget {
  const LoanProducts({Key? key}) : super(key: key);

  @override
  State<LoanProducts> createState() => _LoanProductsState();
}

class _LoanProductsState extends State<LoanProducts> {
  bool isLoading = true;
  late String _customerCount   = '0';
  late List productsList;
  late List allProductsList;
  late List searchItems;

  getAllProducts() async {
    var response = await LoanProductsData.getLoanProductsList();
    print(response.data['loan-products']);

    if (response.statusCode == 200) {
      if(response.data['loan-products'].length != 0){
        setState(() {
          productsList = response.data['loan-products'];
          allProductsList = productsList;
          _customerCount = allProductsList.length.toString();
          isLoading = false;
        });
      }else{
        // Route route =
        // MaterialPageRoute(builder: (context) => const AddNewCustomers());
        // Navigator.pushReplacement(context, route);
      }
    } else {
      if (response.statusCode == 401) {
        Route route = MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        errorSnackBar(context, response['error']);
      }
    }
  }

  void centersSearch(String query) {
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
    getAllProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Loan Products'),
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
                  hintText: "Search Loan Products..",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54.withOpacity(0.5),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black54.withOpacity(0.5),
                    fontStyle: FontStyle.italic
                  ),
                ),
                style: TextStyle(
                  color: Colors.black54.withOpacity(0.5),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500
                ),
                onChanged: (value) {
                  // searchCustomers(value);
                },
              ),
            ),
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
                        content: 'Loan Products List',
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
            const SizedBox(
              height: 30,
            ),
            isLoading == false ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productsList != null ? productsList.length : 0,
                itemBuilder: (_, index) {
                  Map<String, dynamic> userData   = productsList[index]['user'];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SingleCustomer(
                      //       customerName: _customerList[index]['c_name'].toString(),
                      //       customerId: _customerList[index]['id'].toString(),
                      //     ),
                      //   ),
                      // );
                    },
                    child: CommonCardFive(
                      cardHeading: productsList[index]['loan_product_name'],
                      cardSubHeading: "Document Charge is "+productsList[index]['document_charge']+"%",
                      loanAmount: "Max : "+productsList[index]['max_loan_amount'],
                      cardNumber: productsList[index]['id'].toString(),
                      createdAt: DateFormat.yMMMEd().format( DateTime.parse( productsList[index]['created_at']) .toLocal()),
                    ),
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
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            // Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
