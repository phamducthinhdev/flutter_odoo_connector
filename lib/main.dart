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
        primarySwatch: const MaterialColor(0xFF714B67, {
          50: Color(0xFFeee9ed),
          100: Color(0xFFd4c9d1),
          200: Color(0xFFb8a5b3),
          300: Color(0xFF9c8195),
          400: Color(0xFF86667e),
          500: Color(0xFF714B67),
          600: Color(0xFF69445f),
          700: Color(0xFF5e3b54),
          800: Color(0xFF54334a),
          900: Color(0xFF422339)
        }),
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
