import 'package:flutter/material.dart';
import 'package:flutter_app_coba/todo.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'helper.dart';

class AddScreen extends StatefulWidget {
  final Function updateTodo;

  AddScreen({this.updateTodo});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class Pilihan{
  const Pilihan(this.kode, this.warna);
  final int kode;
  final Container warna;
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isNewTaskFinalized = false;
  int _kodewarna;
  String _title = '';
  DateTime _date = DateTime.now();
  String _time = '';
  String _description = '';
  final df = new DateFormat('hh:mm a');
  final DateFormat _dateFormatter = DateFormat('yMd');

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();

  final List<String> _warnas = ['merah','biru','hijau'];
  List<Pilihan> pilihans = [
    Pilihan(1, Container(color: Colors.red, width: 100, height: 10)),
    Pilihan(2, Container(color: Colors.green, width: 100, height: 10)),
    Pilihan(3, Container(color: Colors.blue, width: 100, height: 10)),
  ];

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

  // _handleDatePicker() async{
  //   final DateTime date = await showDatePicker(
  //       context: context,
  //       initialDate: _date,
  //       firstDate: DateTime(2000),
  //       lastDate: DateTime(2030),
  //   );
  //   if (date != null && date != _date){
  //     setState((){
  //       _date = date;
  //     });
  //     _dateController.text = _dateFormatter.format(date);
  //   }
  // }

  _handleDatePicker() async{
    DateTime date = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      currentTime: DateTime.now(), locale: LocaleType.en);
    if(date != null) setState(() => _date = date);
    _dateController.text = _dateFormatter.format(_date);
  }

  _handleTimePicker() async{
    DateTime time = await DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      currentTime: DateTime.now(), locale: LocaleType.en);
    if(time != null) setState(() => _time = df.format(time));
    _timeController.text = (_time);
  }

  _submit(){
    _formKey.currentState.save();
    print('$_title,$_kodewarna,$_date,$_time,$_description,$isNewTaskFinalized');

    // insert task
    Todo newTodo = Todo(
      judul: _title,
      udah: (isNewTaskFinalized) ? 1 : 0,
      warna: _kodewarna,
      date: _date,
      waktu: _time,
      desk: _description,
    );
    Helper.instance.insertTodo(newTodo);
    widget.updateTodo(false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isNewTaskFinalized,
                        activeColor: Colors.orange[400],
                        onChanged: (newValue){ // kalo checkbox diubah
                          setState(() {
                            isNewTaskFinalized = newValue;
                          });
                        }
                      ),
                      Text(
                        'Finalize',
                        style: TextStyle(
                          fontSize: 18.0
                        ),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      Expanded(
                        child:
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText:'Color'),
                            items: pilihans.map((Pilihan warna){ //map = list itu diapain
                              return DropdownMenuItem(
                                value: warna.kode,
                                child: warna.warna,
                              );
                            }).toList(),
                            onChanged: (value){
                              setState((){
                                _kodewarna = value;
                              });
                            },
                            value: _kodewarna
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText:'Title'),
                    keyboardType: TextInputType.text,
                    onSaved: (input) => _title = input,
                    initialValue: _title,
                  ),
                  Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(labelText:'Date'),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        // Expanded(
                        //   child: TextFormField(
                        //     decoration: InputDecoration(labelText:'Time'),
                        //     keyboardType: TextInputType.text,
                        //     onSaved: (input) => _time = input,
                        //     initialValue: _time,
                        //   ),
                        // )
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _timeController,
                            onTap: _handleTimePicker,
                            decoration: InputDecoration(labelText:'Time'),
                          ),
                        ),
                      ]
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText:'Description'),
                    keyboardType: TextInputType.text,
                    onSaved: (input) => _description = input,
                    initialValue: _description,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.orange,
        onPressed: _submit,
      ),
    );
  }
}
