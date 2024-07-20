import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled16/common/colors.dart';
import 'package:untitled16/common/menu_icon.dart';
import 'package:untitled16/home/product_tile.dart';
import '../product_details/product_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange, child: Text('w'),)
                ,
                accountName: Text("user name"),
                accountEmail: Text("emp@gmail.com")),
            ListTile(title: Text('dars'),
              leading: Icon(Icons.add_circle),
              onTap: () {
                Get.offAll(());
              },),
            ListTile(title: Text('hotels'),
              leading: Icon(Icons.add_home_work),
              onTap: () {
                Get.offAll(());
              },),
            ListTile(title: Text('accepted hotels'),
              leading: Icon(Icons.co_present_rounded),
              onTap: () async {

                Get.offAll(());
              },),
            ListTile(title: Text('accepted dars'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {

                Get.offAll(());
              },),
            ListTile(title: Text('sign out'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(());
              },),

          ],
        ),
      ),
      body: Column(
        children: [
          // Top Space for Notifications in iPhone
          const SizedBox(height: 70),
          // Menu Row
          Container(

            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MenuIcon(width: 30, height: 20),
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                  color: Colors.white,
                ),

              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 450,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 50,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            child: Image.asset(
                              'assets/images/home.jpg',
                              height: 400,
                              width: screenWidth * 0.75,
                              // color: Colors.red,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 30,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ProductDetails(),
                                ),
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: GlassesColors.lightYellow,
                              ),
                              child: const Icon(
                                Icons.shopping_bag_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 80,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'order for seller',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    inherit: false,
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'our orders',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    inherit: false,
                                    fontSize: 52,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ProductTile(
                          index: index,
                          assetPath: 'assets/images/first.png',
                        //  assetPath: 'assets/glasses/glasses${index + 1}.png',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


