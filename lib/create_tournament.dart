// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:select_form_field/select_form_field.dart';



class FormWidgetsDemo extends StatefulWidget {
  const FormWidgetsDemo({Key? key}) : super(key: key);

  @override
  _FormWidgetsDemoState createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String? description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;


  TextEditingController? _controller;
  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'boxValue',
      'label': 'Box Label',
      'icon': Icon(Icons.stop),
    },
    {
      'value': 'circleValue',
      'label': 'Circle Label Loooooooooooooooooooong text',
      'icon': Icon(Icons.fiber_manual_record),
      'textStyle': TextStyle(color: Colors.red),
    },
    {
      'value': 'starValue',
      'label': 'Star Label',
      'enable': false,
      'icon': Icon(Icons.grade),
    },
  ];

  /*final List<Map<String, dynamic>> _items = [
    {'value': 1},
    {'value': 2},
    {'value': 3},
    {'value': 4},
    {'value': 5},
    {'value': 6},
    {'value': 7},
    {'value': 8},
    {'value': 9},
    {'value': 10},
    {'value': 11},
    {'value': 12},
    {'value': 13},
    {'value': 14},
    {'value': 15},
    {'value': 16},
    {'value': 17},
    {'value': 18},
    {'value': 19},
    {'value': 20},
    {'value': 21},
    {'value': 22},
    {'value': 23},
    {'value': 24},
    {'value': 25},
    {'value': 26},
    {'value': 27},
    {'value': 28},
    {'value': 29},
    {'value': 30},
    {'value': 31},
  ];*/

  @override
  void initState() {
    super.initState();

    //_initialValue = 'starValue';
    _controller = TextEditingController(text: '2');

    _getValue();
  }

  api_create(title) async {
    String password = '4ivkqNaDIX4EYlBMg2jPDEXetsm3KhQciinltHgN';
    /*String username = 'sergannn';
    String password = '4ivkqNaDIX4EYlBMg2jPDEXetsm3KhQciinltHgN';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);*/
    print("Attempting to fetch data from network");

    final url = Uri.parse(
        "https://sergannn:"+password+"@api.challonge.com/v1/tournaments.json");
    var response = await http.post(url, body: {"tournament[name]": "ser"});
   print(response.body);
   print("...");
  }
  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API
  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = 'circleValue';
        _controller?.text = 'circleValue';
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form widgets'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter a title...',
                            labelText: 'Title',
                          ),
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                        ), SelectFormField(
                          type: SelectFormFieldType.dialog,
                          controller: _controller,
                          //initialValue: _initialValue,
                          icon: Icon(Icons.format_shapes),
                          labelText: 'Shape',
                          changeIcon: true,
                          dialogTitle: 'Pick a item',
                          dialogCancelBtn: 'CANCEL',
                          enableSearch: true,
                          dialogSearchHint: 'Search item',
                          items: _items,
                          onChanged: (val) => setState(() => _valueChanged = val),
                          validator: (val) {
                            setState(() => _valueToValidate = val ?? '');
                            return null;
                          },
                          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a description...',
                            labelText: 'Description',
                          ),
                          onChanged: (value) {
                            description = value;
                          },
                          maxLines: 5,
                        ),
                        _FormDatePicker(
                          date: date,
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimated value',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            Text(
                              intl.NumberFormat.currency(
                                  symbol: "\$", decimalDigits: 0)
                                  .format(maxValue),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Slider(
                              min: 0,
                              max: 500,
                              divisions: 500,
                              value: maxValue,
                              onChanged: (value) {
                                setState(() {
                                  maxValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: brushedTeeth,
                              onChanged: (checked) {
                                setState(() {
                                  brushedTeeth = checked;
                                });
                              },
                            ),
                            Text('Brushed Teeth',
                                style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Enable feature',
                                style: Theme.of(context).textTheme.bodyText1),
                            Switch(
                              value: enableFeature,
                              onChanged: (enabled) {
                                setState(() {
                                  enableFeature = enabled;
                                });
                              },
                            ),
                          ],
                        ),ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            //if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            api_create(title);
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('Processing Data'+description!+title!+date.toString())),
                            );
                            //  }
                          },
                          child: const Text('Submit'),
                        )
                      ].expand(
                            (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        ),
      ],
    );
  }
}