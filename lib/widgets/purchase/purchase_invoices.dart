import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoo_connector/services/invoice.dart';

class PurchaseInvoices extends StatefulWidget {
  const PurchaseInvoices({super.key});

  @override
  State<PurchaseInvoices> createState() => _PurchaseInvoicesState();
}

class _PurchaseInvoicesState extends State<PurchaseInvoices> {
  Future? _invoices;
  final InvoiceService _invoiceService = InvoiceService();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    OdooClient client = context.read<OdooClient>();
    _invoices = _invoiceService.getInvoices(client);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _invoices,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final record = snapshot.data[index] as Map<String, dynamic>;
                return Column(children: [
                  ListTile(
                    leading: const Icon(Icons.article),
                    title: Text(record['name']),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  )
                ]);
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
