// import 'package:flutter/material.dart';
// import 'package:flutter_settings_screens/flutter_settings_screens.dart';

// import 'settingPage.dart';

// class AccountPage extends StatelessWidget {
//   static const KeyLocation = 'key-location';
//   static const KeyLanguage = 'key-language';
//   static const KeyPassword = 'key-password';
//   @override
//   Widget build(BuildContext context) => SimpleSettingsTile(
//         title: 'Account Settings',
//         subtitle: 'Privacy, Security, Language',
//         leading: const IconWidget(icon: Icons.person, color: Colors.green),
//         child: SettingsScreen(
//           title: 'Account Settings',
//           children: <Widget>[
//             buildLanguage(),
//             buildLocation(),
//             buildPassword(),
//             buildPrivacy(context),
//             buildSecurity(context),
//             buildAccountInfo(context),
//           ],
//         ),
//       );
//   // onTap: () => Text('Clicked Report A Bug'));
//   Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
//       title: 'Privacy',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.lock, color: Colors.blue),
//       onTap: () => Text('Clicked Privacy'));
//   Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
//       title: 'Security',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.security, color: Colors.red),
//       onTap: () => Text('Clicked Security'));
//   Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
//       title: 'Account Info',
//       subtitle: '',
//       leading: const IconWidget(icon: Icons.text_snippet, color: Colors.purple),
//       onTap: () => Text('Clicked Account Info'));
//   Widget buildLanguage() => DropDownSettingsTile(
//         title: 'Language',
//         settingKey: KeyLanguage,
//         selected: 1,
//         values: <int, String>{
//           1: 'English',
//           2: 'Spanish',
//           3: 'French',
//           4: 'Indian',
//         },
//         onChange: (language) {/* TODO*/},
//       );
//   Widget buildPassword() => TextInputSettingsTile(
//         settingKey: KeyPassword,
//         title: 'Password',
//         obscureText: true,
//         validator: (password) => password != null && password.length >= 6
//             ? null
//             : 'Enter 6 characters',
//       );
//   Widget buildLocation() => TextInputSettingsTile(
//         settingKey: KeyLocation,
//         title: 'Location',
//         initialValue: 'Israel',
//         onChange: (location) {/* TODO*/},
//       );
// }
