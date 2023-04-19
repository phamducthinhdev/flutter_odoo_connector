import 'package:flutter/material.dart';
import 'package:odoo_connector/widgets/purchase/purchase_invoices.dart';
import 'package:odoo_connector/widgets/purchase/purchase_orders.dart';
import 'package:odoo_connector/widgets/purchase/purchase_transfers.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoo_connector/widgets/user_drawer.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    PurchaseOrders(),
    PurchaseTransfers(),
    PurchaseInvoices()
  ];

  void _onBottomNavigationItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final session = context.read<OdooClient>().sessionId;

    if (session != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Purchase'),
          centerTitle: true,
        ),
        drawer: UserDrawer(
          name: session.userName,
          email: session.userLogin,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.drafts), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2), label: 'Inventory'),
            BottomNavigationBarItem(
                icon: Icon(Icons.request_page), label: 'Invoices'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onBottomNavigationItemTapped,
        ),
      );
    } else {
      return Text('No data');
    }
  }
}
