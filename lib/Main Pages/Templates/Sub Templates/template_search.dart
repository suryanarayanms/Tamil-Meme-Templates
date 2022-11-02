// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:tmq/Main%20Pages/Templates/Sub%20Templates/template_download.dart';

// class Search extends StatefulWidget {
//   final String Name;
//   const Search({Key? key, required this.Name}) : super(key: key);

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   bool isLoading = true;
//   late Map<String, dynamic> userMap;
//   String search = "";
//   late String SearchName = widget.Name;
//   late CollectionReference ref = FirebaseFirestore.instance
//       .collection('template')
//       .doc(SearchName)
//       .collection("templates");

//   Widget buildEffect() {
//     return Shimmer.fromColors(
//         baseColor: Colors.grey.shade100,
//         highlightColor: Colors.grey.shade200,
//         child: GestureDetector(
//             child: Card(
//           clipBehavior: Clip.antiAlias,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         )));
//   }

//   @override
//   void initState() {
//     super.initState();

//     getEffect();
//   }

//   void onSearch() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     await _firestore
//         .collection('templates')
//         .doc(SearchName)
//         .collection('templates')
//         .where("name", isEqualTo: search)
//         .get()
//         .then((value) {
//       setState(() {
//         // userMap = value.docs[0].data;
//       });
//       print(userMap);
//     });
//   }

//   getEffect() async {
//     setState(() {
//       isLoading = true;
//     });
//     await Future.delayed(const Duration(milliseconds: 1240), () {});
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.grey[200],
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 45,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(13)),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           child: Image.asset('assets/search.png'),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: TextField(
//                               onChanged: (value) {
//                                 setState(() {
//                                   search = value;
//                                 });
//                               },
//                               autofocus: true,
//                               cursorColor: Colors.black,
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "Search Template",
//                                 hintStyle:
//                                     TextStyle(color: Colors.grey, fontSize: 20),
//                                 focusColor: Colors.black,
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(13)),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: StreamBuilder(
//                               stream: ref.snapshots(),
//                               builder:
//                                   (_, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                 if (!snapshot.hasData) {
//                                   return Center(
//                                     child:
//                                         LoadingAnimationWidget.prograssiveDots(
//                                       size: 30,
//                                       color: Colors.black,
//                                     ),
//                                   );
//                                 } else {
//                                   return GridView.builder(
//                                     physics: const BouncingScrollPhysics(),
//                                     padding: const EdgeInsets.all(10),
//                                     itemCount: snapshot.data?.docs.length,
//                                     itemBuilder: (context, index) {
//                                       dynamic doc =
//                                           snapshot.data?.docs[index].data();

//                                       if (isLoading) {
//                                         return buildEffect();
//                                       } else {
//                                         // var carousalurl;
//                                         return GestureDetector(
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(22)),
//                                             ),
//                                             child: Card(
//                                               clipBehavior: Clip.antiAlias,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: CachedNetworkImage(
//                                                 imageUrl: doc['imageurl'],
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           onTap: () {
//                                             String templatedownload =
//                                                 doc['imageurl'];

//                                             // print(doc['imageurl']);

//                                             // print(index),
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         TemplateDownlaod(
//                                                           TemplateDownload:
//                                                               templatedownload,
//                                                         )));
//                                           },
//                                         );
//                                       }
//                                     },
//                                     gridDelegate:
//                                         const SliverGridDelegateWithMaxCrossAxisExtent(
//                                             maxCrossAxisExtent: 200,
//                                             childAspectRatio: 3 / 2,
//                                             crossAxisSpacing: 10,
//                                             mainAxisSpacing: 10,
//                                             mainAxisExtent: 150),
//                                   );
//                                 }
//                               }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
