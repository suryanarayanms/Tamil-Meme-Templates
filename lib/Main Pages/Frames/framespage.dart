import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'package:tmq/widgets/navigation_drawer_widget.dart';

import 'Sub Frames/frames.dart';
import 'Sub Frames/trending_frames_download.dart';

class FramesPage extends StatefulWidget {
  const FramesPage({
    Key? key,
  }) : super(key: key);

  @override
  _FramesPageState createState() => _FramesPageState();
}

class _FramesPageState extends State<FramesPage> {
  bool isLoading = true;
  CollectionReference ref = FirebaseFirestore.instance.collection('frame');
  CollectionReference slide =
      FirebaseFirestore.instance.collection('trending_frames');
  DateTime timeBackPressed = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  final bool _floating = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[400],
        key: _scaffoldKey,
        drawer: const NavigationDrawerWidget(),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 125,
        endDrawerEnableOpenDragGesture: true,
        body: WillPopScope(
          onWillPop: () async {
            final difference = DateTime.now().difference(timeBackPressed);
            final isExitWarning = difference >= const Duration(seconds: 3);
            timeBackPressed = DateTime.now();
            if (isExitWarning) {
              const message = 'Press back again to exit';
              Fluttertoast.showToast(msg: message, fontSize: 18);
              return false;
            } else {
              await DefaultCacheManager().emptyCache();
              Fluttertoast.cancel();
              return true;
            }
          },
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.inkDrop(
                    size: 30,
                    color: Colors.white,
                  ),
                )
              : DelayedDisplay(
                  delay: const Duration(milliseconds: 1000),
                  fadeIn: true,
                  slidingBeginOffset: const Offset(0, 0),
                  child: CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                              child: const SizedBox(
                                child: Image(
                                  image: AssetImage(
                                    'assets/nav_icon_white.png',
                                  ),
                                ),
                                height: 30,
                              ),
                            ),
                            const SizedBox(width: 40),
                            DelayedDisplay(
                              delay: const Duration(milliseconds: 1000),
                              fadeIn: true,
                              slidingBeginOffset: const Offset(0, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  'Frames',
                                  style: GoogleFonts.spartan(
                                      textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27,
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                      floating: _floating,
                      expandedHeight: 80,
                      flexibleSpace: const FlexibleSpaceBar(
                        title: Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 4),
                        ),
                      ),
                      backgroundColor: Colors.pink[400],
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                        child: Column(children: [
                          StreamBuilder(
                            stream: slide.snapshots(),
                            builder:
                                (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return CarouselSlider.builder(
                                  itemBuilder: (context, index, realIndex) {
                                    dynamic doc =
                                        snapshot.data?.docs[index].data();
                                    return GestureDetector(
                                      onTap: () {
                                        String trendingframe = doc['imageurl'];
                                        String trendingframename = doc['name'];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TFramesDownlaod(
                                                    trendingFrame:
                                                        trendingframe,
                                                    tname: trendingframename),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  doc['imageurl'],
                                                ),
                                                fit: BoxFit.cover),
                                          )),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 180,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    viewportFraction: 0.8,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  itemCount: snapshot.data?.docs.length,
                                );
                              } else {
                                return Center(
                                  child: LoadingAnimationWidget.prograssiveDots(
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(22)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 7,
                            blurRadius: 15,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: StreamBuilder(
                        stream: ref.snapshots(),
                        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: LoadingAnimationWidget.prograssiveDots(
                                size: 30,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  dynamic doc =
                                      snapshot.data?.docs[index].data();
                                  if (isLoading) {
                                    return buildEffect();
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                doc['imageurl'],
                                              ),
                                              fit: BoxFit.cover),
                                        ),
                                        margin: const EdgeInsets.only(
                                            right: 20.0,
                                            left: 20.0,
                                            bottom: 20.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    String framename =
                                                        doc['name'];

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Frames(
                                                                frameName:
                                                                    framename),
                                                      ),
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                      imageUrl: doc['imageurl'],
                                                      fit: BoxFit.cover,
                                                      color: Colors.grey[500],
                                                      colorBlendMode:
                                                          BlendMode.modulate),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              doc['name'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.spartan(
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                });
                          }
                        },
                      ),
                    ))
                  ]),
                ),
        ));
  }
}
