import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? appVersion;

  @override
  void initState() {
    main();
    super.initState();
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> main() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF7B61FF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 85),
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
                Text(
                  'About',
                  style: GoogleFonts.spartan(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  )),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 19,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 100, bottom: 8.0),
                      child: SizedBox(
                        width: 125,
                        child: Image(image: AssetImage('assets/splash.png')),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'Tamil Meme Templates',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spartan(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      )),
                    ),
                    Text(
                      'v$appVersion',
                      style: GoogleFonts.spartan(
                          textStyle: const TextStyle(
                        color: Colors.white,
                      )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'Crush Over Love ❤️💫',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spartan(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'Tamil Meme Templates Will Be An Open-Source Project',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spartan(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                launchUrlString(
                                    'https://github.com/suryanarayanms/Tamil-Meme-Templates');
                                // launchUrl(Uri.https(
                                // 'https://github.com/suryanarayanms/Tamil-Meme-Templates'));
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Image(
                                        height: 25,
                                        image: AssetImage(
                                            'assets/github_icon_2.png')),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'loveforbutterflyeffect@gmail.com',
                                  query: encodeQueryParameters(<String, String>{
                                    'subject': 'Tamil Meme Templates',
                                    'body': 'Query: '
                                  }),
                                );
                                launchUrl(emailLaunchUri);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Image(
                                        height: 30,
                                        image: AssetImage('assets/gmail.png')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Made with ❤️ by Surya',
                          style: GoogleFonts.spartan(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
