import 'package:odoo_rpc/odoo_rpc.dart';

class TransferService {
  Future<dynamic>? fetchTransferMoves(OdooClient client, List moveIds) async {
    try {
      var res = await client.callKw({
        'model': 'stock.move',
        'method': 'read',
        'args': [moveIds],
        'kwargs': {},
      });
      return res;
    } catch (e) {
      print('Error ${e.toString()}');
      return null;
    }
  }

  Future<dynamic>? updateTransferMove(
      OdooClient client, int moveId, Map<String, dynamic> args) async {
    try {
      var res = await client.callKw({
        'model': 'stock.move',
        'method': 'write',
        'args': [
          [moveId],
          args
        ],
        'kwargs': {},
      });
      return res;
    } catch (e) {
      print('Error ${e.toString()}');
      return null;
    }
  }

  Future<dynamic>? getTransferMoveLines(OdooClient client,
      {List args = const []}) async {
    try {
      await client.checkSession();
      return await client.callKw({
        'model': 'stock.move.line',
        'method': 'search_read',
        'args': [args],
        // 'args': [
        //   [
        //     ['move_id.id', '=', moveId],
        //     args
        //   ]
        // ],
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
