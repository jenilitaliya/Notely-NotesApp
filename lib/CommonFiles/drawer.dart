import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notely/View/Authentication/login_Screen.dart';
import 'package:notely/View/edit_Profile_Screen.dart';

import '../main.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

bool theme = false;

class _DrawerScreenState extends State<DrawerScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  List name = [
    "Edit Profile",
    "Save Notes",
    "All Notes",
  ];
  List icon = [
    const Icon(
      Icons.person,
      size: 30,
      color: Colors.black,
    ),
    const Icon(
      Icons.bookmark_rounded,
      color: Colors.black,
    ),
    const Icon(
      Icons.note_alt_outlined,
      color: Colors.black,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Drawer(
      width: width * 0.7,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
      child: SafeArea(
        child: Column(children: [
          Container(
            height: height * 0.15,
            width: double.infinity,
            color: Colors.blueGrey.shade800,
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc('${box.read('uId')}').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: width * 0.03),
                      const CircleAvatar(
                        backgroundColor: Colors.black26,
                        maxRadius: 30,
                        child: Icon(Icons.person, size: 40),
                      ),
                      SizedBox(width: width * 0.025),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data["FirstName"]} ${data["SecondName"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${data["email"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: height * 0.01),
                    ListTile(
                      onTap: () {
                        index == 0
                            ? Get.to(() => const EditProfileScreen())
                            : index == 1
                                ? Get.back()
                                : Get.back();
                      },
                      trailing: const Icon(Icons.navigate_next),
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: icon[index]),
                      title: Text(
                        "${name[index]}",
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    )
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          const Divider(thickness: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkResponse(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.28,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.home_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                      Text(
                        "Home ",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkResponse(
                onTap: () {
                  box.erase();
                  Get.off(() => const LogInScreen());
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02)
        ]),
      ),
    );
  }
}
