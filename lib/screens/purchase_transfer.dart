import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoo_connector/services/transfer_move.dart';

class PurchaseTransfer extends StatefulWidget {
  const PurchaseTransfer({super.key});

  @override
  State<PurchaseTransfer> createState() => _PurchaseTransferState();
}

class _PurchaseTransferState extends State<PurchaseTransfer> {
  final TransferMoveService _transferMoveService = TransferMoveService();
  Map<String, dynamic>? _transfer;
  Future? _stockMoves;

  final Map<String, String> tracking = {
    'serial': 'By Unique Serial Number',
    'lot': 'By Lots',
    'none': 'No Tracking'
  };

  Future<void> handleQtyDoneUpdate(int moveId) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);
          TextEditingController doneQtyController = TextEditingController();
          return AlertDialog(
            title: const Text('Select done quantity'),
            content: TextField(
              controller: doneQtyController,
            ),
            actions: [
              TextButton(
                  onPressed: () => navigator.pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    print('SAVE $moveId and ${doneQtyController.text}');
                    var res = await _transferMoveService.updateTransferMove(
                        context.read<OdooClient>(),
                        moveId,
                        {'quantity_done': int.parse(doneQtyController.text)});
                    navigator.pop();

                    print(res.toString());
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
    if (routes == null) {
      return const Text('Error while fetching data');
    } else {
      _transfer = routes["record"];
      OdooClient client = context.read<OdooClient>();
      _stockMoves = _transferMoveService
          .readTransferMoves(client, args: [_transfer?["move_lines"]]);

      return Scaffold(
        appBar: AppBar(
          title: Text('Transfer ${_transfer!['name']}'),
          centerTitle: true,
        ),
        body: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Source document:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _transfer!['origin'],
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Scheduled date:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _transfer!['scheduled_date'],
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'State:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _transfer!['state'],
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                const SizedBox(height: 28.0),
                // Move lines
                const Text(
                  'Operations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FutureBuilder(
                  future: _stockMoves,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final records = snapshot.data as List<dynamic>;
                        // print(records.toString());
                        List<DataRow> dataRows = [];
                        for (var i = 0; i < records.length; i++) {
                          dataRows.add(DataRow(cells: [
                            DataCell(Text(records[i]['name'])),
                            DataCell(
                                Text(records[i]['product_uom_qty'].toString())),
                            DataCell(
                              Text(records[i]['quantity_done'].toString()),
                              showEditIcon: records[i]['has_tracking'] != 'none'
                                  ? false
                                  : true,
                              onTap: records[i]['has_tracking'] != 'none'
                                  ? null
                                  : () => handleQtyDoneUpdate(records[i]['id']),
                            ),
                            DataCell(Text(tracking[records[i]['has_tracking']]
                                .toString())),
                            // DataCell(Text(records[i]['has_tracking'])),
                            DataCell(IconButton(
                                icon: const Icon(Icons.view_list),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      '/purchase/transfer/move',
                                      arguments: {"transfer_move": records[i]});
                                })),
                            // DataCell(records[i]['has_tracking'] != 'none'
                            //     ? IconButton(
                            //         icon: const Icon(Icons.view_list),
                            //         onPressed: () {
                            //           Navigator.of(context).pushNamed(
                            //               '/purchase/transfer/move',
                            //               arguments: {
                            //                 "transfer_move": records[i]
                            //               });
                            //         })
                            //     : const SizedBox.shrink()),
                          ]));
                        }

                        return LayoutBuilder(
                            builder: (context, constraints) => Container(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minWidth: constraints.maxWidth),
                                        child: DataTable(
                                          // border: TableBorder.all(width: 1),
                                          columns: const [
                                            DataColumn(label: Text('Product')),
                                            DataColumn(
                                                label: Text('Demand'),
                                                numeric: true),
                                            DataColumn(label: Text('Done')),
                                            DataColumn(label: Text('Tracking')),
                                            DataColumn(label: Text('')),
                                          ],
                                          rows: dataRows,
                                        )))));
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
        ),
      );
    }
  }
}
