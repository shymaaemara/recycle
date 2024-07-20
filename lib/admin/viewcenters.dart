import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled16/admin/addadmin.dart';
import 'package:untitled16/admin/viewadmin.dart';

class viewcenters extends StatefulWidget {


  @override
  State<viewcenters> createState() => _viewcentersState();
}

class _viewcentersState extends State<viewcenters> {
  CollectionReference newcenters = FirebaseFirestore.instance.collection("users");

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
                accountName: Text("welcome admin"),
                accountEmail: Text("admin@gmail.com.com")),
            ListTile(title: Text('admin'),
              leading: Icon(Icons.add_circle),
              onTap: () {
                Get.offAll(addadmin());
              },),
            ListTile(title: Text('add admin'),
              leading: Icon(Icons.add_home_work),
              onTap: () {
                //  Get.offAll(acc_hotel());
              },),
            ListTile(title: Text('new sellers'),
              leading: Icon(Icons.co_present_rounded),
              onTap: () async {
                Get.offAll(viewcenters());
              },),
            ListTile(title: Text('view admins'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {
                Get.offAll(viewaddmin());
              },),
            ListTile(title: Text('orders'),
              leading: Icon(Icons.shop),
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
        title: Text('view centers'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              //  Get.offAll(login());
              })
        ],
      ),

      body: Container(
        child: FutureBuilder(
            future: newcenters
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
                            await newcenters
                                .doc(snapshot.data?.docs[i].id)
                                .delete();
                            await FirebaseStorage.instance
                                .refFromURL(snapshot.data?.docs[i]['email'])
                                .delete()
                                .then((value) {
                              print("=================================");
                              print("Delete");
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
class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  CollectionReference mealsorder =
  FirebaseFirestore.instance.collection("users");

  ListNotes({this.notes, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{

        await mealsorder.where("rool",isEqualTo: 1);
        //  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //    return ViewNote(notes: notes);
        //  }));
      },
      child: Card(
        child: Row(
          children: [

            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['email']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "phone: ${notes['phone']}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "name: ${notes['username']}",
                    ),
                    Text(
                      "email: ${notes['email']}",
                    ),
                    Text(
                      "case: ${notes['case']}",
                    ),
                  ],
                ),

                trailing: IconButton(
                  onPressed: () async {

                    await mealsorder.doc(docid).update({
                      "case": true ,

                    });
                    ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.success,
                        title: "added...",
                        text: "success  ",
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_circle_right_sharp),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/*
class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  CollectionReference not =
  FirebaseFirestore.instance.collection("users");

  ListNotes({this.notes, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{


        //  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //    return ViewNote(notes: notes);
        //  }));
      },
      child: Card(
        child: Row(
          children: [

            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['email']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "phone: ${notes['phone']}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "name: ${notes['username']}",
                    ),
                    Text(
                      "email: ${notes['email']}",
                    ),
                    Text(
                      "case: ${notes['case']}",
                    ),
                  ],
                ),

                trailing: Row(
                  children: [
                    IconButton(
                      onPressed: () async {

                        await not.doc(docid).update({
                          "case": true,

                        });
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.success,
                            title: "added...",
                            text: "  ",
                          ),
                        );
                      },
                      icon: Icon(Icons.keyboard_double_arrow_right_outlined),
                    ),
                    IconButton(
                      onPressed: () async {

                        await not.doc(docid).update({
                          "case": false,

                        });
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.success,
                            title: "refused",
                            text: "  ",
                          ),
                        );
                      },
                      icon: Icon(Icons.keyboard_double_arrow_right_outlined),
                    ),
                  ],

                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
*/
