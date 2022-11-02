import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_version/new_version.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmq/widgets/navigation_drawer_widget.dart';

import 'Main Pages/Templates/Sub Templates/templates.dart';
import 'Main Pages/Templates/Sub Templates/trending_templates_download.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await DefaultCacheManager().emptyCache();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    //
    // DevicePreview(
    //     builder: (context) =>
    //
    const MyApp(),
    //
    // enabled: !kReleaseMode)
    //
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tamil Meme Templates',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConnectivityResult previous;
  bool noInternet = false;
  @override
  void initState() {
    getEffect();
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dynamic notification = message.notification;
      dynamic android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.yellow,
                playSound: true,
                sound: const RawResourceAndroidNotificationSound(
                    'notification_sound'),
                icon: '@mipmap/msg_notification',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    try {
      InternetAddress.lookup('google.com').then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        } else {
          _showdialog();
        }
      }).catchError((error) {
        _showdialog();
      });
    } on SocketException catch (_) {
      _showdialog();
    }

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if ((connresult == ConnectivityResult.mobile) ||
          (connresult == ConnectivityResult.wifi)) {
        noInternet = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage()),
            (Route<dynamic> route) => false);
      } else if (previous == ConnectivityResult.none) {
        noInternet = true;
        _showdialog();
      }

      previous = connresult;
    });
    _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(androidId: 'com.ceosurya.tamilmemetemplates');
    final status = await newVersion.getVersionStatus();
    if (status!.canUpdate) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update available!!!',
          dialogText: 'We have got an update for you. The app needs an update.',
          updateButtonText: 'Get updates',
          allowDismissal: false);
    }
  }

  void _showdialog() {
    noInternet = true;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const CupertinoAlertDialog(
            title: Text(
              'Error\n',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: Text(
                "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again."),
          ),
        );
      },
    );
  }

  DateTime timeBackPressed = DateTime.now();
  bool isLoading = true;

  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("template").doc();
  CollectionReference ref = FirebaseFirestore.instance.collection('template');
  CollectionReference slide =
      FirebaseFirestore.instance.collection('trending_templates');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _floating = true;
  List allTemplates = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF7B61FF),
        key: _scaffoldKey,
        drawer: const NavigationDrawerWidget(),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 125,
        endDrawerEnableOpenDragGesture: true,
        body: WillPopScope(
          //pop scope
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
          child: noInternet
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
                                  'Templates',
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
                      backgroundColor: const Color(0xFF7B61FF),
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
                                        String trendingtemplate =
                                            doc['imageurl'];
                                        String ttempname = doc['name'];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TTemplateDownlaod(
                                                    trendingTemplate:
                                                        trendingtemplate,
                                                    tTname: ttempname),
                                          ),
                                        );
                                      },
                                      child: DelayedDisplay(
                                        delay:
                                            const Duration(milliseconds: 300),
                                        fadeIn: true,
                                        slidingBeginOffset: const Offset(0, 0),
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
                                                  onError:
                                                      (exception, stackTrace) {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "trending_templates")
                                                        .doc(doc['name'])
                                                        .delete();

                                                    // return print('object');
                                                  },
                                                  fit: BoxFit.cover),
                                            )),
                                      ),
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
                                    return Center(
                                      child: LoadingAnimationWidget
                                          .prograssiveDots(
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: DelayedDisplay(
                                        delay:
                                            const Duration(milliseconds: 300),
                                        fadeIn: true,
                                        slidingBeginOffset: const Offset(0, 0),
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
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
                                                      String templatename =
                                                          doc['name'];

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Templates(
                                                            templateName:
                                                                templatename,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: isLoading
                                                        ? const Center()
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                doc['imageurl'],
                                                            fit: BoxFit.cover,
                                                            color: Colors
                                                                .grey[500],
                                                            colorBlendMode:
                                                                BlendMode
                                                                    .modulate),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                doc['name'],
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.spartan(
                                                    textStyle: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
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
