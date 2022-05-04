import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/infoHandler/app_info.dart';
import 'package:provider/provider.dart';
//import 'Screens/ AllDeliveries.dart';
import 'Screens/splashScreen.dart';

void main() async {
  // //await Settings.init(cacheProvider: SharePreferenceCache());

  // runApp(new MaterialApp(
  //   home: AllDeliveries(),
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(
      child: ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Couriers App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MySplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      child: widget.child!,
      key: key,
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: EditProfileUI(),
//     );
//   }
// }

// class EditProfileUI extends StatefulWidget {
//   const EditProfileUI({Key? key}) : super(key: key);

//   @override
//   State<EditProfileUI> createState() => _EditProfileUIState();
// }

// class _EditProfileUIState extends State<EditProfileUI> {
//   bool isObscurePassword = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Edit Profile UI'),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.settings,
//                 color: Colors.white,
//               ))
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.only(left: 15, top: 20, right: 15),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(children: [
//             Center(
//               child: Stack(
//                 children: [
//                   Container(
//                     width: 130,
//                     height: 130,
//                     decoration: BoxDecoration(
//                         border: Border.all(width: 4, color: Colors.white),
//                         boxShadow: [
//                           BoxShadow(
//                               spreadRadius: 2,
//                               blurRadius: 10,
//                               color: Colors.black.withOpacity(0.1))
//                         ],
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: NetworkImage(
//                                 'https://cdn.pixabay.com/photo/2016/12/19/21/36/woman-1919143_1280.jpg'))),
//                   ),
//                   Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(width: 4, color: Colors.white),
//                             color: Colors.blue),
//                         child: Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                         ),
//                       ))
//                 ],
//               ),
//             ),
//             SizedBox(height: 30),
//             buildTextField("Full Name", "Demon", false),
//             buildTextField("Email", "demon90@gmail.com", false),
//             buildTextField("Password", "********", true),
//             buildTextField("Location", "New York", false),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 OutlinedButton(
//                   onPressed: () {},
//                   child: Text("CANCEL",
//                       style: TextStyle(
//                           fontSize: 15, letterSpacing: 2, color: Colors.black)),
//                   style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20))),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   child: Text("SAVE",
//                       style: TextStyle(
//                           fontSize: 15, letterSpacing: 2, color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                       primary: Colors.blue,
//                       padding: EdgeInsets.symmetric(horizontal: 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20))),
//                 ),
//               ],
//             )
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//       String labelText, String placeholder, bool isPasswordTextField) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 30),
//       child: TextField(
//         obscureText: isPasswordTextField ? isObscurePassword : false,
//         decoration: InputDecoration(
//             suffixIcon: isPasswordTextField
//                 ? IconButton(
//                     onPressed: () {
//                       setState(() {
//                         isObscurePassword = !isObscurePassword;
//                       });
//                     },
//                     icon: Icon(Icons.remove_red_eye, color: Colors.grey),
//                   )
//                 : null,
//             contentPadding: EdgeInsets.only(bottom: 5),
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             hintText: placeholder,
//             hintStyle: TextStyle(
//                 fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
//       ),
//     );
//   }
// }

// class MyApp extends StatefulWidget {
//   static final String title = 'Settings';

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Settings.getValue<bool>(HeaderPage.keyDarkMode, true);
//     return ValueChangeObserver<bool>(
//       cacheKey: HeaderPage.keyDarkMode,
//       defaultValue: true,
//       builder: (_, isDarkMode, __) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: MyApp.title,
//         theme: isDarkMode
//             ? ThemeData.dark().copyWith(
//                 primaryColor: Colors.teal,
//                 accentColor: Colors.white,
//                 scaffoldBackgroundColor: Color(0xFF170635),
//                 canvasColor: Color(0xFF170635),
//               )
//             : ThemeData.light().copyWith(accentColor: Colors.black),
//         home: SettingPage(),
//       ),
//     );
//   }
// }
