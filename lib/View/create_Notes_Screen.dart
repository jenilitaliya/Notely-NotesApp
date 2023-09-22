import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notely/View/home_Screen.dart';

import 'package:notely/main.dart';

class CreateNotesScreen extends StatefulWidget {
  const CreateNotesScreen({
    Key? key,
    this.docId,
  }) : super(key: key);

  final docId;
  @override
  State<CreateNotesScreen> createState() => _CreateNotesScreenState();
}

class _CreateNotesScreenState extends State<CreateNotesScreen> {
  CollectionReference users = FirebaseFirestore.instance
      .collection("Users")
      .doc(box.read("uId"))
      .collection("Notes");
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteData();
  }

  Future noteData() async {
    var data = await users.doc(widget.docId).get();
    userList.add(data.data() as Map<String, dynamic>);

    titleController.text = userList[0]["Title"];
    descriptionController.text = userList[0]["Description"];
  }

  bool read = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: read == true
          ? const SizedBox()
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xff435B66),
              onPressed: () async {
                String title = titleController.text;
                String description = descriptionController.text;

                if (titleController.text != "" ||
                    descriptionController.text != "") {
                  if (widget.docId == "") {
                    await users.doc().set({
                      "Title": title,
                      "Description": description,
                      "Time": DateTime.now()
                    });
                    Get.off(() => const HomeScreen());
                  } else {
                    await users.doc(widget.docId).set({
                      "Title": title,
                      "Description": description,
                      "Time": DateTime.now()
                    });
                    Get.off(() => const HomeScreen());
                  }
                } else {
                  Get.off(() => const HomeScreen());
                }
              },
              label: Row(
                children: const [
                  Icon(Icons.save),
                  Text(
                    "Save",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
      appBar: AppBar(
        backgroundColor: const Color(0xff435B66),
        title:
            // Text(titleController.text == "" ? "Notes" : titleController.text),
            TextField(
          readOnly: read,
          controller: titleController,
          style: const TextStyle(fontSize: 22, color: Colors.white),
          expands: false,
          decoration: const InputDecoration(
              hintText: "Title",
              hintStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38),
              border: InputBorder.none),
        ),
        titleSpacing: 2,
        titleTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(blurRadius: 2)]),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  read = !read;
                });
              },
              icon: Image(
                image: read == true
                    ? const AssetImage("assets/images/open-book.png")
                    : const AssetImage("assets/images/book.png"),
                color: Colors.black,
              )),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.04),
              TextField(
                readOnly: read,
                controller: descriptionController,
                maxLines: 34,
                style: const TextStyle(fontSize: 22),
                expands: false,
                decoration: const InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    hintText: "Description",
                    hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
