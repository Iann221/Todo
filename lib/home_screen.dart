import 'package:flutter/material.dart';
import 'package:flutter_app_coba/add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget _buildTodo(int index){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: null,
                          activeColor: Colors.orange[400],
                        ),
                        Text(
                          'ini judul',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text('deskripsi'),
                    Text(
                      'waktu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 5.0,
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Things to Do'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.search),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.segment),
              )
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index){
          return _buildTodo(index);
        }
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddScreen(),
              ),
          ),
      ),
    );
  }
}
