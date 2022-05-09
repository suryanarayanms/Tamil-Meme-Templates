import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'frames_download.dart';

class Frames extends StatefulWidget {
  final String frameName;
  const Frames({Key? key, required this.frameName}) : super(key: key);

  @override
  _FramesState createState() => _FramesState();
}

class _FramesState extends State<Frames> {
  bool isLoading = true;
  late String frameName = widget.frameName;
  late CollectionReference ref = FirebaseFirestore.instance
      .collection('frame')
      .doc(frameName)
      .collection("frames");

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
    await Future.delayed(const Duration(milliseconds: 1240), () {});
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.pink[400],
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
                              delay: const Duration(milliseconds: 500),
                              slidingBeginOffset: const Offset(0.35, 0),
                              child: Text(
                                widget.frameName,
                                style: GoogleFonts.spartan(
                                    textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                )),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
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
                                  child: LoadingAnimationWidget.prograssiveDots(
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
                    )
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
                              delay: const Duration(milliseconds: 1000),
                              fadeIn: true,
                              slidingBeginOffset: const Offset(0, 0),
                              child: Text(
                                widget.frameName,
                                style: GoogleFonts.spartan(
                                    textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                )),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
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
                                  child: LoadingAnimationWidget.prograssiveDots(
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                );
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
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          String framesdownload =
                                              doc['imageurl'];
                                          String subframeName = doc['name'];

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FrameDownlaod(
                                                          frameDownload:
                                                              framesdownload,
                                                          subFramename:
                                                              subframeName)));
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
                    )
                  ],
                ),
              ),
      );
}
