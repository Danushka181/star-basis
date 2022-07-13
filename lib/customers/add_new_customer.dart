import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/custom_page_heading.dart';

class AddNewCustomers extends StatefulWidget {
  const AddNewCustomers({Key? key}) : super(key: key);

  @override
  State<AddNewCustomers> createState() => _AddNewCustomersState();
}

class _AddNewCustomersState extends State<AddNewCustomers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Add New Customer'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomPageHeading(smallHeading: 'ADD NEW', headerLargeText: 'CUSTOMERS'),
            Container(
              child: Column(
                children: const [
                  Text('yesy'),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
