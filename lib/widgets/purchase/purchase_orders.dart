import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoo_connector/services/order.dart';

class PurchaseOrders extends StatefulWidget {
  const PurchaseOrders({super.key});

  @override
  State<PurchaseOrders> createState() => _PurchaseOrdersState();
}

class _PurchaseOrdersState extends State<PurchaseOrders> {
  Future? _orders;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    OdooClient client = context.read<OdooClient>();
    _orders = _orderService.getPurchaseOrders(client);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orders,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final record = snapshot.data[index] as Map<String, dynamic>;
                // return Text(record['name']);
                return ListTile(
                  leading: const Icon(Icons.article),
                  title: Text(record['name']),
                  // subtitle: record,
                  trailing: const Icon(Icons.navigate_next),
                );
              },
            );
          } else {
            return const Text('Couldn\'t fetch data');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
