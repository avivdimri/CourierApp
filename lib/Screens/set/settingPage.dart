// import 'package:flutter/material.dart';
// import 'package:flutter_settings_screens/flutter_settings_screens.dart';
// import 'package:my_app/Screens/set/header_page.dart';
// import 'accountPage.dart';
// import 'notificationsPage.dart';

// class SettingPage extends StatefulWidget {
//   //const SettingPage({Key? key}) : super(key: key);

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.all(24),
//         children: [
//           HeaderPage(),
//           SettingsGroup(
//             title: 'GENERAL',
//             children: <Widget>[
//               AccountPage(),
//               NotificationsPage(),
//               buildLogout(),
//               buildDeleteAccount(),
//             ],
//           ),
//           const SizedBox(height: 32),
//           SettingsGroup(
//             title: 'FEEDBACK',
//             children: <Widget>[
//               const SizedBox(height: 8),
//               buildReportBug(context),
//               buildSendFeedback(context),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildLogout() => SimpleSettingsTile(
//       title: 'Logout',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.logout, color: Colors.blueAccent),
//       onTap: () => Text('Clicked Logout'));
//   Widget buildDeleteAccount() => SimpleSettingsTile(
//       title: 'Delete Account ',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
//       onTap: () => Text('Clicked Delete Account'));

//   Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
//       title: 'Report A Bug',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.bug_report, color: Colors.teal),
//       onTap: () => Text('Clicked Report A Bug'));

//   Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
//       title: 'Delete Account ',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.thumb_up, color: Colors.purple),
//       onTap: () => Text('Clicked SendFeedback '));
// }

// class IconWidget extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   const IconWidget({
//     Key? key,
//     required this.icon,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//       ),
//       child: Icon(icon, color: Colors.white),
//     );
//   }
// }
