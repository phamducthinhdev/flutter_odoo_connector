// import 'package:flutter/material.dart';
// import 'package:odoo_rpc/odoo_rpc.dart';
// import 'package:provider/provider.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   Future? _orders;
//   void handleFetchPurchase() {
//     // PurchaseService purchaseService = PurchaseService(client: client)
//   }

//   @override
//   void initState() {
//     _orders = context.read<OdooClient>().callKw({
//       'model': 'purchase.order',
//       'method': 'search_read',
//       'args': [],
//       'kwargs': {},
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orpc = context.read<OdooClient>();
//     Future orders;

//     print(orpc.sessionId);

//     void fetchOrders() async {
//       var orders = await orpc.callKw({
//         'model': 'purchase.order',
//         'method': 'search_read',
//         'args': [],
//         'kwargs': {
//           // 'context': {'bin_size': true},
//           // 'domain': [],
//           // 'fields': ['id', 'name', 'email', '__last_update', 'image_128'],
//           // 'limit': 80,
//         },
//       });
//       // print(orders);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder(
//         future: _orders,
//         builder: (context, AsyncSnapshot<dynamic> snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, index) {
//                   final record = snapshot.data[index] as Map<String, dynamic>;
//                   // return Text(record['name']);
//                   return ListTile(
//                     leading: const Icon(Icons.article),
//                     title: Text(record['name']),
//                     // subtitle: record,
//                     trailing: const Icon(Icons.navigate_next),
//                   );
//                 },
//               );
//             } else {
//               return const Text('Couldn\'t fetch data');
//             }
//           } else {
//             return const CircularProgressIndicator();
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.telegram), label: 'Orders'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.telegram), label: 'Inventory'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.telegram), label: 'Invoices'),
//         ],
//       ),
//     );
//   }
// }
