import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoo_connector/services/transfer.dart';

class PurchaseTransfers extends StatefulWidget {
  const PurchaseTransfers({super.key});

  @override
  State<PurchaseTransfers> createState() => _PurchaseTransfersState();
}

class _PurchaseTransfersState extends State<PurchaseTransfers> {
  Future? _transfers;
  final TransferService _transferService = TransferService();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    OdooClient client = context.read<OdooClient>();
    _transfers = _transferService.getTransfers(client, args: [
      [
        ['picking_type_id.code', '=', 'incoming']
      ]
    ], kwargs: {
      'order': 'id desc'
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _transfers,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final record = snapshot.data[index] as Map<String, dynamic>;
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(record['name']),
                      trailing: const Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.of(context).pushNamed('/purchase/transfer',
                            arguments: {"record": record});
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(),
                    )
                  ],
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
