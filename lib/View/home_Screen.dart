import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notely/CommonFiles/drawer.dart';
import 'package:notely/View/create_Notes_Screen.dart';
import 'package:notely/View/save_Note_Screen.dart';
import 'package:notely/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference users = FirebaseFirestore.instance
      .collection("Users")
      .doc(box.read("uId"))
      .collection("Notes");
  FirebaseAuth auth = FirebaseAuth.instance;
  List popupItem = ["Profile", "Log Out"];

  formatDate(Timestamp date) {
    final DateTime showDate = date.toDate();
    final String d2 = DateFormat.yMMMEd().format(showDate);
    return d2;
  }

  formatTime(Timestamp time) {
    final DateTime showTime = time.toDate();
    final String t = DateFormat.jm().format(showTime);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffeff5fe),
      key: _scaffoldKey,
      drawer: const DrawerScreen(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff435B66),
        tooltip: "Add New Notes",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateNotesScreen(),
              ));
        },
        label: Row(
          children: const [
            Icon(Icons.add),
            Text(
              "Add",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff435B66),
        title: const Text("Notes"),
        titleSpacing: 2,
        titleTextStyle: const TextStyle(
            fontSize: 28,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(offset: Offset(3, 2), blurRadius: 2)]),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Image(
            image: AssetImage("assets/images/drawer.png"),
            height: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const SaveNoteScreen());
              },
              icon: const Icon(Icons.bookmark_rounded))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<QuerySnapshot>(
            future: users.orderBy("Time", descending: true).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 280),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return InkResponse(
                        onTap: () {
                          String docId = snapshot.data!.docs[index].id;
                          Get.to(() => CreateNotesScreen(docId: docId));
                        },
                        child: Column(
                          children: [
                            Container(
                              height: height * 0.25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: Border.all(
                                      color: Colors.black12, width: 4),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 6,
                                        color: Colors.black12)
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      maxLines: 1,
                                      "${data["Title"]}",
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      "${data["Description"]}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(height: height * 0.01),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(formatTime(data["Time"]),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                            Text(formatDate(data["Time"]),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                    child: Text(
                  "No Data Found",
                  style: TextStyle(fontSize: 41),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
