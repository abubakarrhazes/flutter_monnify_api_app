// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_monnify_api/global_variables.dart';

import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Monnify? monnify;
  final _payment_key = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    initializeMonnify();
    super.initState();
  }

  void showToast(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void initializeMonnify() async {
    monnify = await Monnify.initialize(
        applicationMode: ApplicationMode.TEST,
        apiKey: apiKey,
        contractCode: contractNumber);
  }

  Future<void> onInitializePayment() async {
    final amount = double.parse(_amount.text);
    final name = _name.text;
    final email = _email.text;
    final paymentReference = DateTime.now().millisecondsSinceEpoch.toString();
    final transaction = TransactionDetails().copyWith(
        amount: amount,
        currencyCode: 'NGN',
        paymentReference: paymentReference,
        customerName: name,
        customerEmail: email);
    try {
      final response =
          await monnify?.initializePayment(transaction: transaction);
      showToast(response.toString());
    } catch (e) {
      showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Monnify Api Integration'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 236, 229, 229)),
              child: Form(
                key: _payment_key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _amount,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field cant be empty';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Enter Amount',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field cant be empty';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _email,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          RegExp emailRegExp = RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

                          if (value == null || value.isEmpty) {
                            return 'Email can\'t be empty';
                          } else if (!emailRegExp.hasMatch(value)) {
                            return 'Enter a correct email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_payment_key.currentState!.validate()) {
                            print(_amount.text);
                            print(_email.text);
                            print(_name.text);
                            onInitializePayment();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Text(
                            'Pay Now',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
