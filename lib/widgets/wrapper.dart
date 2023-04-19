import 'package:flutter/material.dart';
import 'package:odoo_connector/screens/authenticate.dart';
import 'package:odoo_connector/screens/home.dart';
import 'package:odoo_connector/screens/purchase.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:hive/hive.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  // Widget handleWrapper() async {
  //   var box = await Hive.openBox('myBox');
  //   dynamic session = box.get('session');
  //   return session ? Home() : Authenticate();
  // }

  @override
  Widget build(BuildContext context) {
    final orpc = context.read<OdooClient>();
    return orpc.sessionId == null ? const Authenticate() : const Purchase();
  }
}
