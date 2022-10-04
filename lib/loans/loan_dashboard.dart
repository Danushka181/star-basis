import 'package:flutter/material.dart';
import 'package:star_basis/loan_products/loan_products_add.dart';

import '../widgets/app_bar.dart';
import 'loan_tabs/issued_loans.dart';
import 'loan_tabs/pending_loans.dart';
import 'loan_tabs/rejected_loans.dart';

class LoanDashboard extends StatefulWidget {
  int activeTab;
  LoanDashboard({Key? key, required this.activeTab}) : super(key: key);

  @override
  State<LoanDashboard> createState() => _LoanDashboardState();
}

class _LoanDashboardState extends State<LoanDashboard> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this,initialIndex:widget.activeTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Loan Center'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            unselectedLabelColor: Colors.black.withOpacity(0.5),
            labelColor: Colors.lightGreen,
            indicatorColor: Colors.lightGreen,
            indicatorPadding: const EdgeInsets.only(left: 5,right: 5),
            tabs: const [
              Tab(
                text: 'Issued Loans',
                height: 60,
              ),
              Tab(
                text: 'Pending',
                height: 60,
              ),
              Tab(
                text: 'Rejected',
                height: 60,
              )
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: const [
                // issued loans
                IssuedLoans(),
                PendingLoansList(),
                RejectedLoansList()
              ],
            ),
          ),
        ],
      ),
      // Add new customer btn
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const LoanProductsAdd()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
