import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:odoo_connector/services/transfer_move.dart';
import 'package:odoo_connector/services/transfer_move_line.dart';

class PurchaseTransferMove extends StatefulWidget {
  const PurchaseTransferMove({super.key});

  @override
  State<PurchaseTransferMove> createState() => _PurchaseTransferMoveState();
}

class _PurchaseTransferMoveState extends State<PurchaseTransferMove> {
  final TransferMoveLineService _transferMoveLineService =
      TransferMoveLineService();
  final TransferMoveService _transferMoveService = TransferMoveService();
  Map<String, dynamic>? _transferMove;
  Future? _transferMoveLines;

  Future? handleTransferMoveLineCreate(String serialNumber,
      {int doneQty = 1}) async {
    OdooClient client = context.read<OdooClient>();
    var res =
        await _transferMoveLineService.createTransferMoveLine(client, args: {
      'picking_id': _transferMove!['picking_id'][0],
      'move_id': _transferMove!['id'],
      'location_dest_id': _transferMove!['location_dest_id'][0],
      'location_id': _transferMove!['location_id'][0],
      'product_id': _transferMove!['product_id'][0],
      'product_uom_id': _transferMove!['product_uom'][0],
      'lot_name': serialNumber,
      'qty_done': doneQty
    });
    return res;
  }

  Future<String?> handleUniqueBarcodeScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get platform version.')));
      return null;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occured while scanning.')));
      return null;
    }
    if (!mounted) return null;
    return barcodeScanRes;
  }

  Future? handleContinuousBarcodeScan() async {
    List<String> scannedBarcodes = [];
    try {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", false, ScanMode.BARCODE)!
          .listen((barcode) {
        if (barcode == null) {
          return;
        }
        scannedBarcodes.add(barcode.toString());
      });
      print('scannedBarcodes Response : $scannedBarcodes');
      return scannedBarcodes;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occured while scanning.')));
      return scannedBarcodes;
    }
  }

  Future<void> handleTransferMoveLineManualCreate(
      Map<String, dynamic>? transferMove) {
    final alertFormKey = GlobalKey<FormState>();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);
          TextEditingController serialNumberController =
              TextEditingController();
          // TextEditingController doneQtyController =
          //     TextEditingController(text: '1');
          return AlertDialog(
            scrollable: true,
            title: const Text('Add manually'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: alertFormKey,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Serial number',
                    // icon: Icon(Icons.account_box),
                  ),
                  controller: serialNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a serial number.';
                    }
                    return null;
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => navigator.pop(),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    if (alertFormKey.currentState!.validate()) {
                      var res = await handleTransferMoveLineCreate(
                          serialNumberController.text);
                      navigator.pop();
                      print('Response : ${res.toString()}');
                    }
                  },
                  child: const Text('Save')),
            ],
          );
        });
  }

  void handleSerialTrackingBarcodeScan() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);
          return AlertDialog(
            title: const Text('Choose a Scan type'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String? barcodeString = await handleUniqueBarcodeScan();
                      if (barcodeString == null || barcodeString.isEmpty) {
                        navigator.pop();
                        return;
                      }
                      await handleTransferMoveLineCreate(barcodeString);
                      navigator.pop();
                    },
                    child: const Text('Single Scan')),
                ElevatedButton(
                    onPressed: () async {
                      List<String> barcodeList =
                          await handleContinuousBarcodeScan();
                      for (final barcode in barcodeList) {
                        await handleTransferMoveLineCreate(barcode);
                      }
                      navigator.pop();
                    },
                    child: const Text('Continuous Scan')),
              ],
            ),
          );
        });
  }

  void handleNoTrackingBarcodeScan() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);
          int nbrBarcodeScanned = 0;
          return AlertDialog(
            title: const Text('Choose a Scan type'),
            content: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of scanned products : $nbrBarcodeScanned'),
                ElevatedButton(
                    onPressed: () async {
                      List<String> barcodeList =
                          await handleContinuousBarcodeScan();
                      nbrBarcodeScanned = barcodeList.length;
                    },
                    child: const Text('Scan')),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => navigator.pop(),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    OdooClient client = context.read<OdooClient>();
                    await _transferMoveService.updateTransferMove(
                        client,
                        _transferMove?['id'],
                        {'quantity_done': nbrBarcodeScanned});
                    navigator.pop();
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
    if (_transferMove!['has_tracking'] == 'serial') {
      _transferMoveLines =
          _transferMoveLineService.getTransferMoveLines(client, args: [
        ['move_id.id', '=', _transferMove!['id']],
        ['product_qty', '=', 0]
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Move - ${_transferMove!['name']}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product:',
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
                'Initial demand:',
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
          // Conditional rendering based the tracking type of the transfer move
          _transferMove!['has_tracking'] != 'serial'
              ? const SizedBox.shrink()
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            for (var i = 0; i < records.length; i++) {
                              dataRows.add(DataRow(cells: [
                                DataCell(
                                    Text(records[i]['lot_name'].toString())),
                                DataCell(
                                    Text(records[i]['qty_done'].toString())),
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
                                                DataColumn(
                                                    label: Text(
                                                        'Lot/Serial Number')),
                                                DataColumn(
                                                    label: Text('Done'),
                                                    numeric: true),
                                              ],
                                              rows: dataRows,
                                            )))));
                          } else {
                            return const Text('No data');
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      })
                ])
        ]),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_transferMove?['has_tracking'] == 'serial') {
                handleSerialTrackingBarcodeScan();
              } else {
                handleNoTrackingBarcodeScan();
              }
            },
            heroTag: null,
            child: const Icon(Icons.barcode_reader),
          ),
          const SizedBox(height: 10),
          // FloatingActionButton(
          //   onPressed: () async {
          //     await handleUniqueBarcodeScan();
          //     // handleUniqueBarcodeScan()
          //     // handleTransferMoveLineScanCreate();
          //   },
          //   heroTag: null,
          //   child: const Icon(Icons.adf_scanner),
          // ),
          // const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await handleTransferMoveLineManualCreate(_transferMove);
            },
            heroTag: null,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
