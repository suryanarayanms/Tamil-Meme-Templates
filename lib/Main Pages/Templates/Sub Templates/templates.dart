import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmq/Main%20Pages/Templates/Sub%20Templates/template_download.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class Templates extends StatefulWidget {
  final String templateName;

  const Templates({
    Key? key,
    required this.templateName,
  }) : super(key: key);
  @override
  _TemplatesState createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  bool isLoading = true;

  late String templateName = widget.templateName;

  late CollectionReference ref = FirebaseFirestore.instance
      .collection('template')
      .doc(templateName)
      .collection('templates');

  Widget buildEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade200,
        child: GestureDetector(
            child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        )));
  }

  @override
  void initState() {
    super.initState();
    getEffect();
  }

  getEffect() async {
    setState(() {
      isLoading = true;
    });
    // await Future.delayed(const Duration(milliseconds: 1240), () {});
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF7B61FF),
        body: isLoading
            ? SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.keyboard_arrow_left_sharp,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          DelayedDisplay(
                            delay: const Duration(milliseconds: 1000),
                            fadeIn: true,
                            slidingBeginOffset: const Offset(0, 0),
                            child: Text(
                              widget.templateName,
                              style: GoogleFonts.spartan(
                                  textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(22),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: StreamBuilder(
                            stream: ref.snapshots(),
                            builder:
                                (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    if (isLoading) {
                                      return buildEffect();
                                    } else {
                                      return GestureDetector(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22)),
                                          ),
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        onTap: () {},
                                      );
                                    }
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          mainAxisExtent: 150),
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.keyboard_arrow_left_sharp,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          DelayedDisplay(
                            delay: const Duration(milliseconds: 500),
                            slidingBeginOffset: const Offset(0.35, 0),
                            child: Text(
                              widget.templateName,
                              style: GoogleFonts.spartan(
                                  textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(22),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: StreamBuilder(
                            stream: ref.snapshots(),
                            builder:
                                (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center();
                              } else {
                                return GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    dynamic doc =
                                        snapshot.data?.docs[index].data();

                                    if (isLoading) {
                                      return buildEffect();
                                    } else {
                                      return GestureDetector(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22)),
                                          ),
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: doc['imageurl'],
                                              placeholder: (context, url) {
                                                return buildEffect();
                                              },
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) {
                                                FirebaseFirestore.instance
                                                    .collection("template")
                                                    .doc(templateName)
                                                    .collection("templates")
                                                    .doc(doc['name'])
                                                    .delete();
                                                return const Center(
                                                  child: Text(
                                                    'The image is corrupted',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          String templatedownload =
                                              doc['imageurl'];
                                          String subtempName = doc['name'];

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TemplateDownlaod(
                                                        templateDownload:
                                                            templatedownload,
                                                        templateName:
                                                            templateName,
                                                        subTempName:
                                                            subtempName,
                                                      )));
                                        },
                                      );
                                    }
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          mainAxisExtent: 150),
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
      );
}
