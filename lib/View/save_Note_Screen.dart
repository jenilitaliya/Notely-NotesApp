import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'create_Notes_Screen.dart';
import 'home_Screen.dart';

class SaveNoteScreen extends StatefulWidget {
  const SaveNoteScreen({Key? key}) : super(key: key);

  @override
  State<SaveNoteScreen> createState() => _SaveNoteScreenState();
}

class _SaveNoteScreenState extends State<SaveNoteScreen> {
  CollectionReference users = FirebaseFirestore.instance
      .collection("Users")
      .doc(box.read("uId"))
      .collection("Notes");
  FirebaseAuth auth = FirebaseAuth.instance;

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
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff435B66),
          title: const Text("Save Notes"),
          titleSpacing: 2,
          titleTextStyle: const TextStyle(
            fontSize: 24,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<QuerySnapshot>(
              future: users.where("save", arrayContains: box.read("uId")).get(),
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
                        String docId = snapshot.data!.docs[index].id;

                        return Dismissible(
                          onDismissed: (direction) {
                            setState(() {});
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(box.read("uId"))
                                .collection("Notes")
                                .doc(docId)
                                .delete();
                          },
                          key: UniqueKey(),
                          child: InkResponse(
                            onTap: () {
                              // String docId = snapshot.data!.docs[index].id;
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
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: height * 0.01),
                                            SizedBox(
                                              width: width * 0.34,
                                              child: Text(
                                                maxLines: 1,
                                                "${data["Title"]}",
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Text(
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                              "${data["Description"]}",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: height * 0.01)
                                          ],
                                        ),
                                        Positioned(
                                          height: height * 0.04,
                                          width: width * 0.73,
                                          // child: IconButton(
                                          //   onPressed: () {},
                                          //   icon: const Icon(
                                          //     Icons.bookmark_border,
                                          //     color: Colors.black54,
                                          //   ),
                                          // ),
                                          child: SaveBtn(
                                              userID: box.read("uId"),
                                              sData: data,
                                              saveId: docId,
                                              saveData: data["save"]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
