import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:star_basis/centers/centers_page.dart';
import 'package:star_basis/loans/loan_dashboard.dart';

import '../../customer_groups/customer_groups.dart';
import '../../widgets/big_text_widget.dart';
import '../../widgets/common_card_one.dart';

class FirstTab extends StatefulWidget {
  const FirstTab({Key? key}) : super(key: key);

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {

  // cards clicked
  // loanServicesRequest() async {
  //   // Route route = MaterialPageRoute(builder: (context) => const LoanDashboard());
  //   // Navigator.pushReplacement(context, route);
  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const LoanDashboard()));
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left:20,top: 30,right: 20,bottom: 5),
              child: BigTextWidget(content: 'Loans..',fontSize: 25, fontWeight: FontWeight.w600, colorCode: Colors.grey,),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const LoanDashboard())),
                child: const CommonCardOne(iconName: Icons.touch_app, cardSubHeading: 'View, Create and approve Loans', cardHeading: 'Loan Process',),
            ),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left:20,top: 30,right: 20,bottom: 5),
              child: BigTextWidget(content: 'Other Data..',fontSize: 25, fontWeight: FontWeight.w600, colorCode: Colors.grey,),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CentersPage())),
              child: const CommonCardOne(iconName: Icons.store, cardSubHeading: 'Add, Edit or Delete centers in area', cardHeading: 'Centers',),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CustomerGroups())),
              child: const CommonCardOne(iconName: Icons.group, cardSubHeading: 'Add, Edit or Delete Customer Groups', cardHeading: 'Customer Groups',),
            ),

            CommonCardOne(iconName: Icons.widgets, cardSubHeading: 'Add, Edit or Delete Loan products', cardHeading: 'Loan Products',),
            CommonCardOne(iconName: Icons.trending_up, cardSubHeading: 'Add Loan Rates for future loans', cardHeading: 'Loan Rates',),
          ],
        ),
      ),
    );
  }
}