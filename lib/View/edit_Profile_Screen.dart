import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notely/CommonFiles/common_TextFormField.dart';
import '../CommonFiles/common_Button.dart';
import 'home_Screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController moController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();
  // Email validation function
  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  List<Map<String, dynamic>> userData = [];
  Future usersData() async {
    var data = await users.doc("${box.read("uId")}").get();
    userData.add(data.data() as Map<String, dynamic>);

    firstNameController.text = userData[0]["FirstName"];
    secondNameController.text = userData[0]["SecondName"];
    gender = userData[0]["gender"];
    moController.text = userData[0]["mobile"];
    emailController.text = userData[0]["email"];
  }

  bool edit = false;
  int radio = 1;
  String gender = '';
  void Gender() {
    if (radio == 1) {
      gender = "male";
    } else {
      gender = "female";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff435B66),
        title: const Text("Profile"),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          letterSpacing: 2,
          fontWeight: FontWeight.w900,
        ),
        titleSpacing: 2,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                edit = !edit;
              });
            },
            icon: Icon(
              Icons.edit,
              color: edit == true ? Colors.black : Colors.lightBlueAccent,
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: edit,
                    obSecure: false,
                    controller: firstNameController,
                    hintText: "First Name",
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                SizedBox(height: height * 0.035),
                //Second Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: edit,
                    controller: secondNameController,
                    obSecure: false,
                    hintText: "Second Name",
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                SizedBox(height: height * 0.03),
                //Gender
                Container(
                  height: height * 0.07,
                  width: width * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: radio,
                            onChanged: (value) {
                              setState(() {
                                radio = 1;
                              });
                            },
                          ),
                          const Text(
                            'Male',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: radio,
                            onChanged: (value) {
                              setState(() {
                                radio = 2;
                              });
                            },
                          ),
                          const Text(
                            'Female',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                //Mobile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: edit,
                    controller: moController,
                    obSecure: false,
                    hintText: "Mobile",
                    prefixIcon: const Icon(Icons.call),
                  ),
                ),
                SizedBox(height: height * 0.035),
                //Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: edit,
                    obSecure: false,
                    controller: emailController,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                SizedBox(height: height * 0.15),
                edit == true
                    ? const SizedBox()
                    : CommonButton(
                        onTap: () async {
                          String firstName = firstNameController.text.trim();
                          String secondsName = secondNameController.text.trim();
                          String email = emailController.text.trim();
                          String mobile = moController.text.trim();
                          Gender();
                          await users.doc(box.read("uId")).update({
                            "email": email,
                            "FirstName": firstName,
                            "SecondName": secondsName,
                            "gender": gender,
                            "mobile": mobile,
                            "date": DateTime.now(),
                          });
                          Get.off(() => const HomeScreen());
                        },
                        text: "UpDate"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
