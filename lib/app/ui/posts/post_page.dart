import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/controllers/post_controller.dart';
import 'package:neep/app/controllers/post_controller2.dart';
import 'package:neep/app/model/post_model.dart';
import 'package:neep/app/ui/posts/add_post_page.dart';
import 'package:neep/app/ui/posts/imagedetail_page.dart';
import 'package:neep/app/ui/widgets/dataloader.dart';
import 'package:neep/app/ui/widgets/image_circular_loader.dart';
import 'package:neep/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class PostPage extends StatefulWidget {
  const PostPage();

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<ValueNotifier> noti =
      List<ValueNotifier>.generate(100, (index) => ValueNotifier<bool>(false));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final postController = PostController.instance;
    // final postList = postController.postList;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Obx(
          () => postController.isLoading
              ? DataLoader()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                    itemCount: postController.postList.length,
                    itemBuilder: (context, index) {
                      return postItem(
                          size, index, noti, postController.postList[index]);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

Widget postItem(
    Size size, int index, List<ValueNotifier> noti, PostModel post) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    width: size.width * .7,
    constraints: BoxConstraints(
      minHeight: size.height * .4,
    ),
    decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 2)],
        borderRadius: BorderRadius.circular(20),
        color: colorsList[index % colorsList.length]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Spacer(
            //   flex: 1,
            // ),
            // CircleAvatar(
            //   radius: 25,
            //   child: ClipRRect(
            //     child: Container(
            //       alignment: Alignment.center,
            //       clipBehavior: Clip.hardEdge,
            //       decoration: BoxDecoration(
            //           color: Colors.red,
            //           borderRadius: BorderRadius.circular(25),
            //           image: DecorationImage(
            //               image: AssetImage("assets/person_avatar.jpg"),
            //               fit: BoxFit.cover)),
            //     ),
            //   ),
            // ),
            // Spacer(
            //   flex: 1,
            // ),
            // Container(
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //         top: size.height * .02, bottom: size.height * .01),
            //     child: Text(
            //       "User_name",
            //       style: GoogleFonts.montserrat(
            //           fontSize: 18,
            //           color: Colors.white,
            //           letterSpacing: 2,
            //           fontWeight: FontWeight.w500),
            //     ),
            //   ),
            // ),
            // Spacer(
            //   flex: 4,
            // ),
            // GestureDetector(
            //   onTap: () async {
            //     // TODO: fix me---

            //     await Share.share("https://nobee.page.link/63fF");
            //   },
            //   child: CircleAvatar(
            //     radius: 20,
            //     backgroundColor: Colors.black,
            //     child: Icon(
            //       Icons.share,
            //       color: Colors.white,
            //       size: 23,
            //     ),
            //   ),
            // ),
            // Spacer()
          ],
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: Divider(
        //     color: Colors.white,
        //     height: 10,
        //     thickness: 2,
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Text(
            post.caption,
            style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.w500),
          ),
        ),
        CarouselSlider(
          items: post.mediaUrl.map(
            (fileUrl) {
              final random = Random();
              int tag = 1 + random.nextInt(100000 - 1 + 1);
              return CachedNetworkImage(
                imageUrl: fileUrl,
                imageBuilder: (context, imageProvider) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageDetail(imageUrl: fileUrl, tag: tag),
                        ),
                      );
                    },
                    child: Hero(
                      tag: tag,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: size.height * .4,
                        width: size.width,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                  );
                },
                placeholder: ((context, url) {
                  return ImagePlaceHolder();
                }),
                errorWidget: (context, url, error) {
                  return Text(
                    error.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  );
                },
              );
            },
          ).toList(),
          options: CarouselOptions(
            height: 400,
            enableInfiniteScroll: false,
          ),
        ),
        Row(
          children: [
            // ValueListenableBuilder(
            //   valueListenable: noti[index],
            //   builder: (BuildContext context, dynamic value, Widget? child) {
            //     return IconButton(
            //         splashRadius: 1,
            //         onPressed: () {
            //           noti[index].value = !noti[index].value;
            //         },
            //         icon: Icon(
            //           value ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            //           color: Colors.white,
            //           size: 28,
            //         ));
            //   },
            // ),
            // IconButton(
            //   splashRadius: 1,
            //   onPressed: () async {
            //     await Share.share("Helo");
            //   },
            //   icon: Icon(
            //     CupertinoIcons.share,
            //     color: Colors.white,
            //     size: 28,
            //   ),
            // )
          ],
        )
      ],
    ),
  );
}

Widget showImages(Size size, String imgurl, int index) {
  return CachedNetworkImage(
    imageUrl:
        "https://www.botify.com/wp-content/uploads/2020/12/3-url-parameters.jpg",
    imageBuilder: (context, imageProvider) {
      return GestureDetector(
        onTap: () {
          print("le");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageDetail(
                  imageUrl:
                      "https://www.botify.com/wp-content/uploads/2020/12/3-url-parameters.jpg",
                  tag: index),
            ),
          );
        },
        child: Hero(
          tag: index,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: size.height * .4,
            width: size.width,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
          ),
        ),
      );
    },
    placeholder: ((context, url) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }),
    errorWidget: (context, url, error) {
      return Text(
        error.toString(),
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    },
  );
}
