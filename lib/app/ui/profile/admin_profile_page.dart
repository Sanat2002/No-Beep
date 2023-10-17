import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/dataloader.dart';

// ignore: camel_case_types
class Profile extends StatefulWidget {
  static const routeName = '/profile';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // bool _build = false;
  // UserData? _userData;

  @override
  void initState() {
    getdata();
    super.initState();
  }

  int posts = 11;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: const Color.fromARGB(254, 3, 0, 28),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(254, 3, 0, 28),
              title: const Text(
                'Profile',
                style: TextStyle(color: Color.fromARGB(254, 121, 255, 249)),
              ),
              centerTitle: true,
              leading: Column(children: [
                IconButton(
                    onPressed: () async {
                      // var build = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: ((context) => EditProfile()),
                      //   ),
                      // );
                      // if (build == true) {
                      //   setState(() {
                      //     _userData = Global.presentUser;
                      //   });
                      // }
                    },
                    icon: const Icon(
                      Icons.mode_edit_outlined,
                      color: Colors.white,
                      size: 20,
                    )),
              ]),
              actions: [
                IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return WillPopScope(
                                child: const DataLoader(),
                                onWillPop: () async {
                                  return false;
                                });
                          }));
                      var res = await SignOut();
                      if (res == "Success") {
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LoginScreen()),
                        //     (route) => false);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.add_to_home_screen_rounded,
                      color: Colors.white,
                    )),
                const Padding(padding: EdgeInsetsDirectional.only(end: 10))
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsetsDirectional.only(end: 15)),
                    const Text(
                      "Edit",
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Text("LogOut", style: TextStyle(color: Colors.white)),
                    Padding(padding: EdgeInsetsDirectional.only(end: 10))
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: .5)),
                          height: 230,
                          width: 180,
                          child: CachedNetworkImage(
                            imageUrl: "_userData!.profileImage",
                            imageBuilder: ((context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain)),
                              );
                            }),
                            placeholder: (context, url) {
                              return DataLoader();
                            },
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("_userData!.fullName",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("_userData!.userName",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // _userData!.instaId.isNotEmpty ? InkWell(
                      //   onTap: () {
                      //     launchUrlString("https://www.instagram.com/${_userData!.instaId.toString()}",
                      //         mode: LaunchMode.externalApplication);
                      //   },
                      //   child: Container(
                      //     height: 25,
                      //     width: 25,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //                   image: AssetImage(
                      //                       "assets/images/instagram.png"),
                      //             fit: BoxFit.fill)),
                      //   ),
                      // ):SizedBox(height: 0,width: 0,),
                      const SizedBox(
                        width: 10,
                      ),
                      // _userData!.linkedIn.isNotEmpty ? InkWell(
                      //   onTap: () {
                      //     launchUrlString(_userData!.linkedIn.toString(),
                      //         mode: LaunchMode.externalApplication);
                      //   },
                      //   child: Container(
                      //     height: 25,
                      //     width: 25,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //                   image: AssetImage(
                      //                       "assets/images/linkedin.png"),
                      //             fit: BoxFit.fill)),
                      //   ),
                      // ) : SizedBox(height: 0,width: 0,),
                      const SizedBox(
                        width: 10,
                      ),
                      // _userData!.github.isNotEmpty
                      //     ? InkWell(
                      //         onTap: () {
                      //           launchUrlString(_userData!.github.toString(),
                      //               mode: LaunchMode.externalApplication);
                      //         },
                      //         child: Container(
                      //           height: 25,
                      //           width: 25,
                      //           decoration: BoxDecoration(
                      //               image: DecorationImage(
                      //                   image: AssetImage(
                      //                       "assets/images/github.png"),
                      //                   fit: BoxFit.fill)),
                      //         ),
                      //       )
                      //     : SizedBox(
                      //         height: 0,
                      //         width: 0,
                      //       ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text("_userData!.email.toString()",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 18)),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder(
                      // future: UserFeedServices.getEachUserFeed(
                      //     Global.presentUser!.id),
                      builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: size.height * .3, child: DataLoader());
                    }

                    if (snapshot.hasData) {
                      print(snapshot.data);

                      // List<PostMessage> feed =
                      //     snapshot.data as List<PostMessage>;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "feed.length.toString()",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20)),
                                TextSpan(
                                    text: " Posts",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ]))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 20),
                            child: Gridview(
                                // posts: feed,
                                ),
                          ),
                        ],
                      );
                    }

                    return Center(
                      child: Text(
                        "No Posts added till now !!!",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.dmSans().fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    );
                  }),
                ],
              ),
            )));
  }

  getdata() {
    // _userData = Global.presentUser!;
  }
}

@override
class Gridview extends StatefulWidget {
  // final List<PostMessage> posts;
  // Gridview({
  //   super.key,
  //   // required this.posts,
  // });
  @override
  State<Gridview> createState() => _GridviewState();
}

class _GridviewState extends State<Gridview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 35,
            mainAxisSpacing: 25,
            mainAxisExtent: 200),
        // itemCount: widget.posts.length,
        itemCount: 10,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => FeedPostDetailPage(
              //               postData: widget.posts[index],
              //               presentUser: Global.presentUser!,
              //             )));
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: .5),
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(254, 3, 0, 28),
              ),
              // child:
              //     ? Container(
              //         clipBehavior: Clip.hardEdge,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(20)),
              //         // child: FlickVideo(
              //         //     url: widget.posts[index].photo,
              //         //     videofile: null,
              //         //     volume: 0.0,
              //         //     settime: false,
              //         //     issplash: false,
              //         //     isfile: false,
              //         //     v: () {}),
              //       )
              //     : CachedNetworkImage(
              //         imageUrl: widget.posts[index].photo,
              //         imageBuilder: ((context, imageProvider) {
              //           return Container(
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 image: DecorationImage(
              //                     image: imageProvider, fit: BoxFit.contain)),
              //           );
              //         }),
              //         placeholder: (context, url) {
              //           return DataLoader();
              //         },
              //       )
            ),
          );
        });
  }
}

Future SignOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    return "Success";
  } on FirebaseAuthException catch (e) {
    print(e);
    return "Failed";
  }
}
