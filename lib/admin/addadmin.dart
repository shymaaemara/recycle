import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled16/admin/viewadmin.dart';

import 'package:untitled16/custombuttonauth.dart';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled16/ui/screens/login_screen.dart';

class addadmin extends StatefulWidget {


  @override
  State<addadmin> createState() => _addadminState();
}

class _addadminState extends State<addadmin> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool obstract = true;
  var email, password,name , address,phone ;
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata?.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.back();
        } else if (e.code == 'email-already-in-use') {
          Get.back();
        }
      } catch (e) {
        print(e);
      }
    } else {

    }
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
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key:formstate ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(

                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),

                      hintText: 'name',
                      labelText: 'Name *',
                    ),
                    onSaved: (val) {
                      name = val;
                    },
                    validator: (val) {
                      if (val == "") {
                        return "Can't To be Empty";
                      }
                    }),
                Container(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                TextFormField(

                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),

                      hintText: 'email',
                      labelText: 'email ',
                    ),
                    onSaved: (val) {
                      email = val;
                    },
                    validator: (val) {
                      if (val == "") {
                        return "Can't To be Empty";
                      }
                    }),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                TextFormField(

                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),

                      hintText: 'passwprd',
                      labelText: 'password ',
                    ),
                    onSaved: (val) {
                      password = val;
                    },
                    obscureText: obstract,
                    validator: (val) {
                      if (val == "") {
                        return "Can't To be Empty";
                      }
                    }),
                const Text(
                  "phone",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                TextFormField(
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),

                      hintText: 'phone',
                      labelText: 'phone ',
                    ),
                    onSaved: (val) {
                      phone = val;
                    },

                    validator: (val) {
                      if (val == "") {
                        return "Can't To be Empty";
                      }
                    }),
              ],
            ),
          ),
          CustomButtonAuth(
              title: "SignUp",
              onPressed:  () async {
                UserCredential response = await signUp();
                if (response != null) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .add({
                    "username": name,
                    "rool": "admin",
                    "case": true,
                    "email": email,
                    "password": password,
                    "phone": phone
                  });
                  Get.offAll(LoginScreen());
                } else {
                  print("Sign Up Faild");
                }
              } ),
          Container(height: 20),

          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)

        ]),
      ),
    );


  }
}
