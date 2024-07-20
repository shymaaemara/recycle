import 'dart:io';
import 'dart:math';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:untitled16/ui/screens/login_screen.dart';
import 'package:uuid/uuid.dart';
class AddNotes extends StatefulWidget {


  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  CollectionReference mealref = FirebaseFirestore.instance.collection("product");

  late Reference ref;

  late File file;

  var name, quantity, imageurl,untildate,description;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  void showdialog(context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.pink,
        title:Text(" added") ,
        content: Text(" added "),
        actions: [MaterialButton(onPressed: (){Get.back();},child: Text("ok"),)
        ],
      );
    });
  }
  addmeal(context) async {
    if (file == null)
      return AwesomeDialog(
          context: context,
          title: "هام",
          body: Text("please choose Image"),
          dialogType: DialogType.ERROR)
        ..show();
    var formdata = formstate.currentState;
    if (formdata!.validate()) {


      formdata.save();
      await ref.putFile(file);
      imageurl = await ref.getDownloadURL();

// Create uuid object
      var uuid = Uuid();

// Generate a v1 (time-based) id

      await mealref.add({
        "ID" : uuid.v1(),
        "name": name,
        "description": description,
        "quantity": int.parse(quantity),
        "date": untildate,
        "imageurl": imageurl,
        "userid": FirebaseAuth.instance.currentUser?.uid
      }).then((value) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "A success message!",
                text: "Show a success message with an icon"
            )
        );
     //   Get.offAll(HomePage());
      }).catchError((e) {
        print("$e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              })
        ],
      ),
      backgroundColor: const Color(0xFFF9E5DE),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange, child: Text('w'),)
                ,
                accountName: Text("user name"),
                accountEmail: Text("emp@gmail.com")),
            ListTile(title: Text('add product'),
              leading: Icon(Icons.add_circle),
              onTap: () {
                Get.offAll(AddNotes());
              },),
            ListTile(title: Text('view '),
              leading: Icon(Icons.add_home_work),
              onTap: () {
              //  Get.offAll(HomePage());
              },),

            ListTile(title: Text('sign out'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              },),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon Logo

                const CircleAvatar(
                  backgroundImage: NetworkImage('https://cdn.dribbble.com/users/458522/screenshots/16171869/media/0c5b235e80c42db71c2567d8a04625ac.png'),
                  radius: 60.0,
                ),

                const SizedBox(height: 5.0,),

                //greeting text

                Text("recycle",

                ),

                const SizedBox(height: 5.0,),

                const Text('we miss you',
                    style: TextStyle(
                      fontSize: 16,
                    )),

                const SizedBox(height: 40.0,),

                //email text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.length > 30) {
                            return "name can't to be larger than 30 letter";
                          }
                          if (val!.length < 2) {
                            return "name can't to be less than 2 letter";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          name = val;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'name',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0,),

                //password text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.length > 30) {
                            return "quantity can't to be larger than 30 letter";
                          }
                          if (val!.length < 2) {
                            return "quantity can't to be less than 2 letter";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          quantity = val;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'quantity',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: DateTimePicker(

                        initialValue: '',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        onChanged: (val) {
                          print(val);
                          untildate = val;
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.length > 300) {
                            return "decripe can't to be larger than 300 letter";
                          }
                          if (val!.length < 30) {
                            return "quantity can't to be less than 30 letter";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          description = val;
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'descripe',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextButton(
                        onPressed: () {
                          showBottomSheet(context);
                        },
                        child: Text("Add Image For Note"),
                      ),
                    ),
                  ),
                ),

                //login button
                const SizedBox(height: 20.0,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFEF6D04),
                    ),
                    child:  Center(
                        child: TextButton(
                          onPressed: () async {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "added...",
                                text: "There is a  ",
                              ),
                            );
                            await addmeal(context);

                          },
                          child: Text(
                            "Add product",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        )
                    ),
                  ),
                ),
                //not a member? register now

                const SizedBox(height: 20.0,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please Choose Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");

                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_outlined,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}
