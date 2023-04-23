import 'package:odoo_rpc/odoo_rpc.dart';

class AuthService {
  late OdooClient? odooClientInstance;
  late OdooSession? session;
  AuthService({this.odooClientInstance});

  // Odoo session
  Stream<OdooSession>? get sessionStream {
    // odooClientInstance!.sessionStream.listen((event) { })
    return odooClientInstance?.sessionStream;
    // if (odooClientInstance == null) {
    //   return null;
    // } else {
    //   return odooClientInstance!.sessionStream;
    // }
  }

  // Authenticate
  Future<OdooSession?> odooAuthenticate(
      String db, String login, String password) async {
    try {
      // odooClientInstance.sessionStream;
      session = await odooClientInstance!.authenticate(db, login, password);
      return session;
    } on OdooException catch (e) {
      // print(e.toString());
      throw Exception('Check configuration');
      return null;
    } catch (e) {
      // print(e.toString());
      throw Exception('Something went wrong !');
      return null;
    }
  }

  // Sign out
  Future<void> odooLogout() async {
    try {
      await odooClientInstance!.destroySession();
      session = null;
    } catch (e) {
      print(e.toString());
    }
  }
}
