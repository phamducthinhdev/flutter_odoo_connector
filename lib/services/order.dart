import 'package:odoo_rpc/odoo_rpc.dart';

class OrderService {
  Future<dynamic> getPurchaseOrders(OdooClient client,
      {List args = const [],
      Map<String, dynamic> kwargs = const {'order': 'id desc'}}) async {
    try {
      var res = await client.callKw({
        'model': 'purchase.order',
        'method': 'search_read',
        'args': args,
        'kwargs': kwargs
      });
      return res;
    } catch (e) {
      return null;
    }
  }
}
