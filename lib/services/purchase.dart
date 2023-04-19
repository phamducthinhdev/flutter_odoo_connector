import 'package:odoo_rpc/odoo_rpc.dart';

class PurchaseService {
  // Orders
  Future<dynamic> fetchPurchaseOrders(OdooClient client) async {
    try {
      var res = await client.callKw({
        'model': 'purchase.order',
        'method': 'search_read',
        'args': [],
        'kwargs': {},
      });
      return res;
    } catch (e) {
      return null;
    }
  }

  // Transfers
  Future<dynamic> fetchPurchaseTransfers(OdooClient client) async {
    try {
      var res = await client.callKw({
        'model': 'stock.picking',
        'method': 'search_read',
        'args': [
          [
            ['picking_type_id.code', '=', 'incoming']
          ]
        ],
        'kwargs': {},
      });
      return res;
    } catch (e) {
      return null;
    }
  }

  // Invoices
  Future<dynamic> fetchPurchaseInvoices(OdooClient client) async {
    try {
      var res = await client.callKw({
        'model': 'account.move',
        'method': 'search_read',
        'args': [],
        'kwargs': {},
      });
      return res;
    } catch (e) {
      return null;
    }
  }
}
