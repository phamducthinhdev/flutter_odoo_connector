import 'package:flutter/material.dart';
import 'package:odoo_connector/services/auth.dart';
import 'package:odoo_connector/widgets/login/login_field.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:odoo_connector/services/purchase.dart';
import 'package:hive/hive.dart';

class LoginForm extends StatefulWidget {
  final Function setLoading;
  const LoginForm({super.key, required this.setLoading});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  var box = Hive.box('myBox');

  // Inputs controllers
  final urlController = TextEditingController();
  final dbController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleSignIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final navigator = Navigator.of(context);
      // widget.setLoading(true);
      final orpc = context.read<OdooClient>();
      orpc.baseURL = urlController.text;
      print(orpc);
      print(orpc.baseURL);
      OdooSession? session = await AuthService(odooClientInstance: orpc)
          .odooAuthenticate(dbController.text, usernameController.text,
              passwordController.text);
      if (session != null) {
        print('logged in');
        navigator.popAndPushNamed('/purchase');
      } else {
        print('Failed to log in');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Odoo URL
          LoginField(
            controller: urlController,
            hintText: 'URL',
            obscureText: false,
          ),
          const SizedBox(height: 25),
          // Odoo db
          LoginField(
              controller: dbController,
              hintText: 'Database',
              obscureText: false),
          const SizedBox(height: 25),
          // Username
          LoginField(
            controller: usernameController,
            hintText: 'Username',
            obscureText: false,
          ),
          const SizedBox(height: 25),
          // Password
          LoginField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 25),
          // Sign in button
          ElevatedButton(
              onPressed: () {
                handleSignIn(context);
              },
              child: const Text('Sign in')),
        ],
      ),
    );
  }
}
