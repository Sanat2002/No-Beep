// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/services/firebase_service/auth_service.dart';
import 'package:neep/app/ui/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:neep/app/ui/profile/login_page.dart';
import 'package:neep/app/ui/profile/register_page.dart';
import 'package:neep/app/ui/widgets/dataloader.dart';
import 'package:neep/app/utils/utils.dart';

import '../../hive/hive_boxes.dart';
import '../onboarding/intro_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  var obsecureText = true;
  var obsecureText2 = true;
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final userDataBox = HiveBoxes.getUserHiveBox();

  void VailidEmail() {
    final bool isEmail = EmailValidator.validate(emailController.text.trim());
    if (isEmail) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Vailid email")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("invailid email")));
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isUserPresent = userDataBox.get("local_user") != null &&
            userDataBox.get("local_user")!.userMotive.isNotEmpty
        ? true
        : false;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 0, 28),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: size.height * .2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Sign Up",
                            style: GoogleFonts.montserrat(
                                fontSize: 40,
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: size.height * .08,
                      child: TextFormField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.email_rounded,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: const Color.fromARGB(77, 217, 217, 217),
                          counterText: '',
                        ),
                        maxLength: 30,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter eamil address";
                          } else if (!EmailValidator.validate(value)) {
                            return "Enter eamil address";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: size.height * .08,
                      child: TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: obsecureText,
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.key_outlined,
                            color: Colors.white,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obsecureText = !obsecureText;
                              });
                            },
                            child: obsecureText
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: const Color.fromARGB(77, 217, 217, 217),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password length must be greater than 6";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: size.height * .08,
                      child: TextFormField(
                        controller: confirmpasswordController,
                        focusNode: confirmPasswordFocusNode,
                        obscureText: obsecureText2,
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.key_outlined,
                              color: Colors.white),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obsecureText2 = !obsecureText2;
                              });
                            },
                            child: obsecureText2
                                ? const Icon(Icons.visibility_off,
                                    color: Colors.white)
                                : const Icon(Icons.visibility,
                                    color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: const Color.fromARGB(77, 217, 217, 217),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return "Password does not match!!!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: size.width * .4,
                height: size.height * .05,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: ((context) {
                              return WillPopScope(
                                  onWillPop: () async {
                                    return false;
                                  },
                                  child: const Center(
                                    child: DataLoader(),
                                  ));
                            }));
                        var res = await AuthService().signUpWithEmailAndPass(
                            emailController.text, passwordController.text);

                        if (res == "Success") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));

                          // if (isUserPresent) {
                          //   Navigator.pushAndRemoveUntil(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => BottomNavScreen()),
                          //       (route) => false);
                          // } else {
                          //   Navigator.pushAndRemoveUntil(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => AppIntroPage()),
                          //       (route) => false);
                          // }
                        } else {
                          requestFailureSnackbar(res);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var res = await AuthService().signInWithGoogle();

                      if (res) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavScreen()),
                            (route) => false);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppIntroPage()),
                            (route) => false);
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/google.svg",
                      height: 70,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: SvgPicture.asset(
                  //     "assets/instagram.svg",
                  //     height: 70,
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: SvgPicture.asset(
                  //     "assets/facebook.svg",
                  //     height: 70,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
