import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoo_connector/services/transfer.dart';

class PurchaseTransferMove extends StatefulWidget {
  const PurchaseTransferMove({super.key});

  @override
  State<PurchaseTransferMove> createState() => _PurchaseTransferMoveState();
}

class _PurchaseTransferMoveState extends State<PurchaseTransferMove> {
  final TransferService _transferService = TransferService();
  Map<String, dynamic>? _transferMove;
  Future? _transferMoveLines;

  void handleTransferMoveLineScanCreate() {
    print('test');
  }

  Future<void> handleTransferMoveLineManualCreate(
      Map<String, dynamic>? transferMove) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);
          TextEditingController serialNumberController =
              TextEditingController();
          TextEditingController doneQtyController = TextEditingController();
          return AlertDialog(
            title: const Text('Enter done quantity'),
            content: Column(
              children: [
                TextField(
                  controller: serialNumberController,
                ),
                TextField(
                  controller: doneQtyController,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => navigator.pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    // print(transferMove!['product_uom']);
                    // print('SAVE $transferMove and ${doneQtyController.text}');
                    var res = await _transferService.createTransferMoveLine(
                        context.read<OdooClient>(),
                        args: {
                          'picking_id': transferMove!['picking_id'][0],
                          'move_id': transferMove['id'],
                          'location_dest_id': transferMove['location_dest_id']
                              [0],
                          'location_id': transferMove['location_id'][0],
                          'product_id': transferMove['product_id'][0],
                          'product_uom_id': transferMove['product_uom'][0],
                          'lot_name': serialNumberController.text,
                          'qty_done': int.parse(doneQtyController.text)
                        });
                    navigator.pop();

                    print('Response : ${res.toString()}');
                  },
                  child: const Text('Save')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    OdooClient client = context.read<OdooClient>();

    if (routes == null) {
      return const Text('Error while fetching data');
    }

    _transferMove = routes["transfer_move"];
    _transferMoveLines = _transferService.getTransferMoveLines(client, args: [
      ['move_id.id', '=', _transferMove!['id']],
      ['product_qty', '=', 0]
    ]);
    print('Transfer move : $_transferMove');
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Move - ${_transferMove!['name']}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Produit:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  _transferMove!['name'],
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Demande initial:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${_transferMove!['product_uom_qty']}",
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantity done:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${_transferMove!['quantity_done']} / ${_transferMove!['product_uom_qty']}",
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(height: 28.0),
            const Text(
              'Detailed Operations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder(
              future: _transferMoveLines,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final records = snapshot.data as List<dynamic>;
                    List<DataRow> dataRows = [];
                    // print(records.toString());
                    for (var i = 0; i < records.length; i++) {
                      dataRows.add(DataRow(cells: [
                        DataCell(Text(records[i]['lot_name'].toString())),
                        DataCell(Text(records[i]['qty_done'].toString())),
                      ]));
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) => Container(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              // border: TableBorder.all(width: 1),
                              columns: const [
                                DataColumn(
                                    label: Text('Lot/Serial Number Name')),
                                DataColumn(label: Text('Done'), numeric: true),
                              ],
                              rows: dataRows,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Text('No data');
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              handleTransferMoveLineScanCreate();
            },
            heroTag: null,
            child: const Icon(Icons.barcode_reader),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await handleTransferMoveLineManualCreate(_transferMove);
            },
            heroTag: null,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      // FloatingActionButton(
      //   onPressed: () async {
      //     await handleTransferMoveLineCreate(_transferMove);
      //   },
      //   child: const Icon(Icons.barcode_reader),
      // ),
    );
  }
}
