// import 'package:flutter/material.dart';
// import 'package:flutter_settings_screens/flutter_settings_screens.dart';
// import 'package:my_app/Screens/set/header_page.dart';
// import 'package:my_app/Screens/set/settingPage.dart';

// class NotificationsPage extends StatelessWidget {
// //  const NotificationsPage({ Key? key }) : super(key: key);
//   static const keyNews = 'key-news';
//   static const keyActivity = 'key-activity';
//   static const keyNewsletter = 'key-newsletter';
//   static const keyAppUpdates = 'key-appUpdates';

//   @override
//   Widget build(BuildContext context) => SimpleSettingsTile(
//         title: 'Notifications',
//         subtitle: 'Newsletter, App Updates',
//         leading: const IconWidget(
//           icon: Icons.notifications,
//           color: Colors.redAccent,
//         ),
//         child: SettingsScreen(
//           title: 'Notifications',
//           children: <Widget>[
//             buildNews(),
//             buildActivity(),
//             //buildNewsletter(),
//             //buildAppUpdates(),
//           ],
//         ),
//       );

//   Widget buildNews() => SwitchSettingsTile(
//         settingKey: keyNews,
//         title: 'News For You',
//         leading: IconWidget(icon: Icons.message, color: Colors.blue),
//       );
//   Widget buildActivity() => SwitchSettingsTile(
//         settingKey: keyActivity,
//         title: 'Account Activity',
//         leading: IconWidget(icon: Icons.person, color: Colors.orange),
//       );
// }
