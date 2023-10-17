import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/model/user_model.dart';
import 'package:neep/app/services/firebase_service/user_service.dart';
import 'package:neep/app/services/shared_pref_service.dart';
import 'package:neep/app/ui/onboarding/intro_page.dart';
import 'package:neep/app/utils/utils.dart';

import '../bottom_nav_bar/bottom_nav_bar.dart';
import '../widgets/dataloader.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  final userNameController = TextEditingController();
  var emailController = TextEditingController();

  String usertoken = "";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        usertoken = token!;
        print("token $usertoken");
      });
    });
  }

  @override
  void initState() {
    emailController.text = _auth.currentUser!.email!;
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                        Text("Fill Data",
                            style: GoogleFonts.montserrat(
                                fontSize: 40,
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: firstNameController,
                      // focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "first name",
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.person,
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter first name";
                        }
                        return null;
                      },
                      maxLength: 30,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: lastNameController,
                      // focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "last name",
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.person,
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
                          return "Enter last name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "user_name",
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.person,
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
                          return "Enter user name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      initialValue: emailController.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "email",
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.email,
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
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 25),
              const SizedBox(height: 65),
              SizedBox(
                width: size.width * .4,
                height: size.height * .05,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => BottomNavScreen()));
                    if (_formkey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return WillPopScope(
                                child: const Center(
                                  child: DataLoader(),
                                ),
                                onWillPop: () async {
                                  return false;
                                });
                          }));

                      final user = UserModel(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          userName: userNameController.text,
                          token: usertoken);
                      Map<String, dynamic> newUserData = {
                        _auth.currentUser!.email!: user.toJson()
                      };
                      var isAdminRegInFb =
                          await UserService.creatuser(newUserData);
                      if (isAdminRegInFb) {
                        SharedPrefService.setBool("IS_ADMIN_REG_IN_FB", true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AppIntroPage())));
                      } else {
                        requestFailureSnackbar(
                            "Something went wrong. Please try again");
                        // Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    "Save Data",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
