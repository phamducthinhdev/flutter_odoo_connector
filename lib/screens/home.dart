// import 'package:flutter/material.dart';
// // import 'package:odoo_rpc/odoo_rpc.dart';
// // import 'package:provider/provider.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         centerTitle: true,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const UserAccountsDrawerHeader(
//               accountName: Text("username"),
//               accountEmail: Text("user@mail.com"),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper.png"),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.credit_card),
//               title: const Text('Purchase'),
//               onTap: () {
//                 Navigator.of(context).pushNamed('/purchase');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Settings'),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       body: const Placeholder(),
//     );
//   }
// }
