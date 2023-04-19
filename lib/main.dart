import 'package:flutter/material.dart';
import 'package:odoo_connector/screens/authenticate.dart';
import 'package:odoo_connector/screens/purchase.dart';
import 'package:odoo_connector/screens/purchase_transfer.dart';
import 'package:odoo_connector/screens/purchase_transfer_move.dart';
import 'package:odoo_connector/widgets/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  // OdooSession? session = null;
  final orpc = OdooClient('http://localhost:8068');
  runApp(FutureProvider<OdooClient>(
    initialData: orpc,
    create: (context) => Future.value(orpc),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo Connector',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
        '/authenticate': (context) => const Authenticate(),
        // '/home': (context) => const Home(),
        '/purchase': (context) => const Purchase(),
        '/purchase/transfer': (context) => const PurchaseTransfer(),
        '/purchase/transfer/move': (context) => const PurchaseTransferMove(),
      },
    );
  }
}
