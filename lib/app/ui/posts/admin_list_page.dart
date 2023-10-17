import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AdminList extends StatefulWidget {
  const AdminList({Key? key}) : super(key: key);

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              top: size.height * .033,
              left: 0,
              right: 0,
              child: SizedBox(
                height: size.height * .08,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 17, color: Colors.white),
                      fillColor: Colors.deepPurple.shade400,
                      filled: true,
                      hintText: "Search Admin",
                      prefixIcon: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.search_sharp,
                        size: 28,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            Positioned(
              top: size.height * .1,
              left: 0,
              right: 10,
              bottom: 0,
              child: Container(
                // color: Colors.black,
                height: size.height * .6,
                width: size.width,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return adminlist();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget adminlist() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      // tileColor: Colors.deepPurple.shade100,
      // minVerticalPadding: 10,
      leading: CircleAvatar(
        radius: 40,
        child: CachedNetworkImage(
          imageUrl:
              "https://www.botify.com/wp-content/uploads/2020/12/3-url-parameters.jpg",
          imageBuilder: (context, imageProvider) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                height: 56,
                width: 56,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
            );
          },
          placeholder: ((context, url) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
          errorWidget: (context, url, error) {
            return Icon(
              Icons.error,
              color: Colors.red,
              size: 28,
            );
          },
        ),
      ),
      title: Text(
        "John Wick",
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 25,
      ),
    ),
  );
}
