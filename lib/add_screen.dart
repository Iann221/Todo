import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _warna;
  String _title = '';
  DateTime _date = DateTime.now();
  String _description = '';
  TextEditingController _dateController = TextEditingController();

  final List<String> _warnas = ['merah','biru','hijau'];
  final DateFormat _dateFormatter = DateFormat('yMd');

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async{
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
    );
    if (date != null && date != _date){
      setState((){
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit(){
    _formKey.currentState.save();
    print('$_warna,$_title,$_date,$_description');

    // insert task

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
                        value: false,
                        onChanged: null,
                        activeColor: Colors.orange[400],
                      ),

                    ],
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText:'Color'),
                    items: _warnas.map((String warna){
                      return DropdownMenuItem(
                        value: warna,
                        child: Text(warna),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState((){
                        _warna = value;
                      });
                    },
                    value: _warna
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText:'Title'),
                    keyboardType: TextInputType.text,
                    onSaved: (input) => _title = input,
                    initialValue: _title,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _dateController,
                    onTap: _handleDatePicker,
                    decoration: InputDecoration(labelText:'Date'),
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
