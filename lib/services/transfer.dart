import 'package:odoo_rpc/odoo_rpc.dart';

class TransferService {
  Future<dynamic> getTransfers(OdooClient client,
      {List args = const [],
      Map<String, dynamic> kwargs = const {'order': 'id desc'}}) async {
    try {
      var res = await client.callKw({
        'model': 'stock.picking',
        'method': 'search_read',
        'args': args,
        'kwargs': kwargs,
      });
      return res;
    } catch (e) {
      return null;
    }
  }
}
