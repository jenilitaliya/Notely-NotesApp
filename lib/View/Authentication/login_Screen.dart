import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:notely/CommonFiles/common_Button.dart';
import 'package:notely/CommonFiles/common_TextFormField.dart';
import 'package:notely/View/home_Screen.dart';
import 'package:notely/View/Authentication/registration_Screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final box = GetStorage();
  final formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                Lottie.asset("assets/lottie/login.json", height: 150),
                SizedBox(height: height * 0.02),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            offset: Offset(-5, 8),
                            blurRadius: 3,
                            color: Colors.black26)
                      ],
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: height * 0.02),
                const Text(
                  "Login to your account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                SizedBox(height: height * 0.035),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: CommonTextFormField(
                    readOnly: false,
                    controller: emailController,
                    obSecure: false,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Email';
                      } else if (!isValidEmail(value)) {
                        return 'Invalid Email Number';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),
                SizedBox(height: height * 0.04),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
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
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot password?"),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.08),
                CommonButton(
                    onTap: () async {
                      String email = emailController.text.trim();
                      String password = passController.text.trim();

                      if (formKey.currentState!.validate()) {
                        try {
                          UserCredential credential =
                              await auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          box.write("uId", credential.user!.uid);
                          box.write('LoginStatus', true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "unknown") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter Email and Password")));
                          }
                          if (e.code == "wrong-password") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter correct Password")));
                          }
                        }
                      }
                    },
                    text: "LogIn"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up  ",
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
