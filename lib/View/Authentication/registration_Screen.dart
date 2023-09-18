import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notely/CommonFiles/common_TextFormField.dart';

import '../../CommonFiles/common_Button.dart';
import '../home_Screen.dart';
import 'login_Screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController moController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();
  bool showPassword = false; // Flag to toggle password visibility

  // Email validation function
  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  // Password validation function
  bool isValidPassword(String password) {
    // Customize your password requirements here
    return password.length >= 6; // Example: At least 6 characters
  }

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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  "Registration",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: height * 0.015),
                const Text(
                  "Create your account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                SizedBox(height: height * 0.04),
                //First Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: false,
                    obSecure: false,
                    controller: firstNameController,
                    hintText: "First Name",
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),
                SizedBox(height: height * 0.035),
                //Second Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: false,
                    controller: secondNameController,
                    obSecure: false,
                    hintText: "Second Name",
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Second Name';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),
                SizedBox(height: height * 0.03),
                //Gender
                Container(
                  height: height * 0.07,
                  width: width * 0.9,
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
                            style: TextStyle(fontSize: 20),
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
                    readOnly: false,
                    controller: moController,
                    obSecure: false,
                    hintText: "Mobile",
                    prefixIcon: const Icon(Icons.call),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Mobile Number';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),
                SizedBox(height: height * 0.035),
                //Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: false,
                    obSecure: false,
                    controller: emailController,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isValidEmail(value)) {
                        return 'Invalid email format';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),
                SizedBox(height: height * 0.035),
                //Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonTextFormField(
                    readOnly: false,
                    controller: passController,
                    obSecure: !showPassword,
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      } else if (!isValidPassword(value)) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null; // Return null if the input is valid
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.1),
                CommonButton(
                    onTap: () async {
                      String firstName = firstNameController.text.trim();
                      String secondsName = secondNameController.text.trim();
                      String email = emailController.text.trim();
                      String mobile = moController.text.trim();
                      String password = passController.text;
                      Gender();
                      // Validate email and password
                      if (!isValidEmail(email)) {
                        // Show error message for invalid email
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid email')));
                      }

                      if (!isValidPassword(password)) {
                        // Show error message for invalid password
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Password must be at least 6 characters')));
                      }

                      // Perform registration if both email and password are valid
                      if (formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          box.write("uId", userCredential.user!.uid);
                          await users.doc(userCredential.user!.uid).set({
                            "email": email,
                            "FirstName": firstName,
                            "SecondName": secondsName,
                            "gender": gender,
                            "mobile": mobile,
                            "uId": userCredential.user!.uid,
                            "date": DateTime.now(),
                          }).then(
                            (value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          );
                        } catch (error) {
                          // Handle registration error
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registration failed')));
                          //print("Registration failed: $error");
                        }
                      }
                    },
                    text: "Submit"),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogInScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
