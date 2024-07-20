import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled16/admin/viewcenters.dart';
import 'package:untitled16/ui/screens/login_screen.dart';

class services extends StatefulWidget {
  const services({super.key});

  @override
  State<services> createState() => _servicesState();
}

class _servicesState extends State<services> {
  CollectionReference newser = FirebaseFirestore.instance.collection("servicies");

  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    print(user?.email);
  }

  var fbm = FirebaseMessaging.instance;

  initalMessage() async {

    var message =   await FirebaseMessaging.instance.getInitialMessage() ;

    if (message != null){

      // Get.offAll(AddNotes());
    }

  }

  requestPermssion() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

  }

  @override
  void initState() {
    requestPermssion() ;
    initalMessage() ;
    fbm.getToken().then((token) {
      print("=================== Token ==================");
      print(token);
      print("====================================");
    });




    FirebaseMessaging.onMessage.listen((event) {
      print("===================== data Notification ==============================") ;

      //  AwesomeDialog(context: context , title: "title" , body: Text("${event.notification.body}"))..show() ;


    }) ;


    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange, child: Text('w'),)
                ,
                accountName: Text("user name"),
                accountEmail: Text("emp@gmail.com")),
            ListTile(title: Text('admin'),
              leading: Icon(Icons.add_circle),
              onTap: () {
                // Get.offAll(acc_dat());
              },),
            ListTile(title: Text('client'),
              leading: Icon(Icons.add_home_work),
              onTap: () {

              },),
            ListTile(title: Text('new seller'),
              leading: Icon(Icons.co_present_rounded),
              onTap: () async {

                //  Get.offAll(accepted());
              },),
            ListTile(title: Text('accepted '),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {

                //   Get.offAll(dars());
              },),
            ListTile(title: Text('ordders'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {

                //   Get.offAll(dars());
              },),
            ListTile(title: Text('sign out'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                //   Get.offAll(login());
              },),

          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('admin dash'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              })
        ],
      ),

      body: Container(
        child: FutureBuilder(
            future: newser
                .where("case",
                isEqualTo: false).where("rool", isEqualTo: "seller")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, i) {
                      return Dismissible(
                          onDismissed: (diretion) async {
                            await newser
                                .doc(snapshot.data?.docs[i].id)
                                .delete();
                            await FirebaseStorage.instance
                                .refFromURL(snapshot.data?.docs[i]['email'])
                                .delete()
                                .then((value) {
                              print("=================================");
                              Get.offAll(viewcenters());
                            });
                          },
                          key: UniqueKey(),
                          child: ListNotes(
                            notes: snapshot.data?.docs[i],
                            docid: snapshot.data?.docs[i].id,
                          ));
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

