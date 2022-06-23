import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/common_card_one.dart';
import '../widgets/common_card_two.dart';

class LoanDashboard extends StatefulWidget {
  const LoanDashboard({Key? key}) : super(key: key);

  @override
  State<LoanDashboard> createState() => _LoanDashboardState();
}

class _LoanDashboardState extends State<LoanDashboard> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black54, //change your color here
        ),
        elevation: 4,
        title: const Text(
          "Loan Service..",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily:'Inter',
              color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: TabBar(
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              labelColor: Colors.lightGreen,
              indicatorColor: Colors.lightGreen,
              indicatorPadding: const EdgeInsets.only(left: 5,right: 5),
              tabs: const [
                Tab(
                  text: 'All',
                  height: 60,
                ),
                Tab(
                  text: 'Pending',
                  height: 60,
                ),
                Tab(
                  text: 'Completed',
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
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CommonCardTwo( cardHeading: 'A K G Kalu Manika A K G Kalu ManikaA K G Kalu Manika', cardSubHeading: '163-c, Kotarupe, Raddolugama', loanAmount: '5000',),
                        CommonCardTwo( cardHeading: 'A K G Kalu Manika A K G Kalu ManikaA K G Kalu Manika', cardSubHeading: '163-c, Kotarupe, Raddolugama', loanAmount: '43500',),
                      ],
                    ),
                  ),
                ),
                Text('Person'),
                Text('test'),
                Text('test 4'),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
