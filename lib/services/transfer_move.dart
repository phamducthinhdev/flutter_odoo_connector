import 'package:odoo_rpc/odoo_rpc.dart';

class TransferMoveService {
  Future<dynamic>? getTransferMoves(OdooClient client,
      {List args = const [],
      Map<String, dynamic> kwargs = const {'order': 'id desc'}}) async {
    try {
      var res = await client.callKw({
        'model': 'stock.move',
        'method': 'search_read',
        'args': args,
        'kwargs': kwargs
      });
      return res;
    } catch (e) {
      print('Error ${e.toString()}');
      return null;
    }
  }

  Future<dynamic>? readTransferMoves(OdooClient client,
      {List args = const [], Map<String, dynamic> kwargs = const {}}) async {
    try {
      var res = await client.callKw({
        'model': 'stock.move',
        'method': 'read',
        'args': args,
        'kwargs': kwargs,
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
}
