import 'package:flutter/material.dart';
import 'package:odoo_connector/widgets/login/login_form.dart';
import 'package:odoo_connector/widgets/loading.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool loading = false;
  String error = '';

  void setLoading(bool state) {
    setState(() => loading = state);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[300],
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  // Welcome
                  Text('Se connecter a Odoo',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                  const SizedBox(height: 25),
                  // Form fields
                  LoginForm(setLoading: setLoading),
                ],
              ),
            ),
          );
  }
}
