import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/services/loans.dart';

import '../../screens/login_page.dart';
import '../../services/globals.dart';
import '../../widgets/common_card_two.dart';
import '../../widgets/loading_widget.dart';
import '../single_loan_data.dart';

class IssuedLoans extends StatefulWidget {
  const IssuedLoans({Key? key}) : super(key: key);

  @override
  State<IssuedLoans> createState() => _IssuedLoansState();
}

class _IssuedLoansState extends State<IssuedLoans> {

  late List issuedLoans;
  late List allIssuedLoans;
  bool isLoading = true;
  bool isNoData = false;

  getAllIssuedLoans() async{
    try{
      var response = await LoansService.getIssuedLoansList();
      if (response.statusCode == 200) {
        if(response.data['loans'].length != 0){
          setState(() {
            issuedLoans = response.data['loans'];
            allIssuedLoans = issuedLoans;
            isLoading = false;
          });
        }else{
          if (!mounted) return;
          notifySnackBar(context,'Currently no issued loans, Please approve!');
          setState((){
            issuedLoans = [];
            allIssuedLoans = issuedLoans;
            isLoading = false;
            isNoData = true;
          });
        }
      } else {
        if (response.statusCode == 401) {
          if (!mounted) return;
          Route route = MaterialPageRoute(builder: (context) => const LoginPage());
          Navigator.pushReplacement(context, route);
        } else {
          if (!mounted) return;
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

  @override
  void initState() {
    issuedLoans = [];
    getAllIssuedLoans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
          isLoading == false ?
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: issuedLoans != null ? issuedLoans.length : 0,
              itemBuilder: (_, index) {
                Map<String, dynamic> customerData   = issuedLoans[index]['customer'];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleLoanData(
                            customerName: customerData['c_name'].toString(),
                            loanId: issuedLoans[index]['id'].toString(),
                            phoneNumber: customerData['c_mobile_number'].toString(),
                          ),
                        ),
                      );
                    },
                    child: CommonCardTwo(
                      cardHeading: customerData['c_name'].toString(),
                      cardSubHeading: customerData['c_address'].toString(),
                      loanAmount: issuedLoans[index]['l_amount'].toString(),
                      loanId: issuedLoans[index]['id'].toString(),
                      createdAt: DateFormat.yMMMEd().format( DateTime.parse( issuedLoans[index]['created_at']) .toLocal()),
                    ),
                  );
              }
            )
            :
            const LoadingWidget(),
            isNoData ?
            infoMessage('No issued loans Found! Please approve Loans.',Colors.grey)
            :
            Container(),
          ],
        ),
      ),
    );
  }
}
