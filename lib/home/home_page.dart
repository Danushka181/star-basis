import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_basis/home/tabs/first_tab.dart';
import 'package:getwidget/getwidget.dart';

import '../services/auth_services.dart';
import '../widgets/big_text_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin   {

  late TabController tabController;
  String userName = "Hello";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _getUsername();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // get user name
  _getUsername() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? _username = storage.getString('name');
    if( _username != null ){
      setState(() {
        userName  = 'Hello '+_username;
      });
    }else{
      userName  = 'Star Basis';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.lightGreen,
        leading:  GFIconButton(
          icon: const Icon(
            Icons.attach_money_outlined,
            color: Colors.white,
          ),
          onPressed: () {},
          type: GFButtonType.transparent,
        ),
        title: Text(userName),
        actions: <Widget>[
          GFIconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {},
            type: GFButtonType.transparent,
          ),
        ],
      ),

      body: GFTabBarView(controller: tabController, children: <Widget>[
        Container(
          color: Colors.white,
          child: Stack(
            children: const [
              FirstTab(),
            ],
          ),
        ),
        Container(color: Colors.green),
        Container(color: Colors.blue)
      ]),
      bottomNavigationBar: GFTabBar(
        length: 3,
        controller: tabController,
        tabBarColor: Colors.lightGreen,
        tabs: const [
          Tab(

            icon: Icon(Icons.home),
            child: BigTextWidget(content: 'Home',fontSize: 16, fontWeight: FontWeight.w500,),
          ),
          Tab(
            icon: Icon(Icons.supervisor_account),
            child: BigTextWidget(content: 'Customers',fontSize: 16, fontWeight: FontWeight.w500,),
          ),
          Tab(
            icon: Icon(Icons.monetization_on),
            child: BigTextWidget(content: 'Collections',fontSize: 16, fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    );
  }
}







