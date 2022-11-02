import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmq/main.dart';

import 'package:tmq/widgets/flushbar.dart';

class TTemplateDownlaod extends StatefulWidget {
  final String trendingTemplate;
  final String tTname;
  const TTemplateDownlaod({
    Key? key,
    required this.trendingTemplate,
    required this.tTname,
  }) : super(key: key);

  @override
  _TTemplateDownlaodState createState() => _TTemplateDownlaodState();
}

class _TTemplateDownlaodState extends State<TTemplateDownlaod> {
  int downloadnotification = 0;
  late String tempName = widget.tTname;

  _save() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final String tTemplateurl = widget.trendingTemplate;

      var response = await Dio().get(tTemplateurl,
          options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 100, name: tempName);

      flutterLocalNotificationsPlugin.show(
          0,
          "Template Downloaded",
          "",
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            timeoutAfter: 5000,
            color: Colors.yellow,
            playSound: true,
            sound:
                const RawResourceAndroidNotificationSound('notification_sound'),
            icon: '@mipmap/msg_notification',
          )));
      return Snackbar()
          .showFlushbar(context: context, message: "Template Downloaded");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF7B61FF),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            clipBehavior: Clip.antiAlias,
                            color: const Color(0xFF7B61FF),
                            child: CachedNetworkImage(
                              imageUrl: widget.trendingTemplate,
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B61FF),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(-7, -10),
                                  spreadRadius: 1),
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(7, 10),
                                  spreadRadius: 1)
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(-7, -10),
                                spreadRadius: 1),
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(7, 10),
                                spreadRadius: 1)
                          ],
                        ),
                        child: FloatingActionButton.extended(
                            backgroundColor: const Color(0xFF7B61FF),
                            disabledElevation: 100,
                            onPressed: () {
                              _save();
                            },
                            label: Text(
                              'Download',
                              style: GoogleFonts.spartan(
                                  textStyle: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            icon: const Icon(
                              Icons.download,
                              size: 20,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
