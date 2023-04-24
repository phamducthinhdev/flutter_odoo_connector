import 'package:odoo_rpc/odoo_rpc.dart';

class TransferMoveLineService {
  Future<dynamic>? getTransferMoveLines(OdooClient client,
      {List args = const []}) async {
    try {
      await client.checkSession();
      return await client.callKw({
        'model': 'stock.move.line',
        'method': 'search_read',
        'args': [args],
        'kwargs': {},
      });
    } catch (e) {
      print('Error ${e.toString()}');
      return null;
    }
  }

  Future<dynamic>? createTransferMoveLine(OdooClient client,
      {Map<String, dynamic> args = const {}}) async {
    try {
      return await client.callKw({
        'model': 'stock.move.line',
        'method': 'create',
        'args': [args],
        'kwargs': {},
      });
    } catch (e) {
      print('Error ${e.toString()}');
      return null;
    }
  }
}
