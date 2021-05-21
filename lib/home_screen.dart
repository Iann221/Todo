import 'package:flutter/material.dart';
import 'package:flutter_app_coba/add_screen.dart';
import 'package:flutter_app_coba/todo.dart';
import 'package:intl/intl.dart';
import 'helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFinished;
  IconData appBarSearchIcon;
  Widget appBarTitle = Text('Things to do');

  Future<List<Todo>> _displayedTodos;

  final DateFormat _dateFormatter = DateFormat('yMd');

  @override
  void initState(){
    super.initState();
    _updateTodoList(false);
    appBarSearchIcon = Icons.search;
    appBarTitle = Text('Tings to do');
    isFinished = false;
  }

  // update todolist tapi cek filter on ato ngga
  _updateTodoList(statusfilter){
    if(statusfilter){
      setState(() {
        _displayedTodos = Helper.instance.getDoneTodoList();
      });
    } else {
      setState(() {
        _displayedTodos = Helper.instance.getTodoList();
      });
    }
  }

  _searchTodoList(queryString){
    setState((){
      _displayedTodos = Helper.instance.searchTodoList(queryString);
      appBarSearchIcon = Icons.search;
      appBarTitle = Text('Things to do');
    });
  }

  Widget _buildTodo(Todo todo){
    print(todo.id);
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
                          value: todo.udah == 1, // value = true
                          onChanged: (value){
                            todo.udah = value ? 1 : 0; // kalo kecek, todonya 1
                            Helper.instance.updateTodo(todo); // update db
                            _updateTodoList(false); // ubah list jg
                          },
                          activeColor: Colors.orange[400],
                        ),
                        Text(
                          todo.judul,
                          style: TextStyle(
                            fontSize: 18,
                            decoration: todo.udah == 1 ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                    Text(todo.desk),
                    Text(
                      "${_dateFormatter.format(todo.date)} ${todo.waktu}",
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
                color: todo.getColor(),
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
        title: appBarTitle,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  appBarSearchIcon,
                ),
                tooltip: 'Search',
                onPressed: (){
                  if (appBarSearchIcon == Icons.search){
                    setState((){
                      appBarSearchIcon = Icons.close;
                      appBarTitle = TextField(
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'search todos',
                          isDense: true,
                          contentPadding: EdgeInsets.all(4.0),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onSubmitted: (searchKey){
                          _searchTodoList(searchKey);
                        },
                      );
                    });
                  }
                  else{
                    setState((){
                      appBarSearchIcon = Icons.search;
                      appBarTitle = Text('Things to do');
                    });
                  }
                }
              ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.sort),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget> [
                    Text('Status'),
                    Checkbox(
                      value: isFinished,
                      activeColor: Colors.orange[400],
                      onChanged: (newValue){
                        setState(() {
                          isFinished = newValue;
                        });
                        _updateTodoList(isFinished);
                      }
                    )
                  ]
                )
              ),
              PopupMenuItem(
                child: Text('Date'),
              ),
              PopupMenuItem(
                child: Text('Priority'),
              ),
            ]
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: _displayedTodos,
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Tidak ada kerjaan'),
            );
          }
          return Container(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return _buildTodo(snapshot.data[index]);
                },
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.orange,
          // kode utk munculin widget lain ketika diklik
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddScreen(updateTodo: _updateTodoList),
              ),
          ),
      //     onPressed: () {Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => AddScreen(updateTodo: _updateTodoList),
      //     ),
      //   );
      // }
      ),
    );
  }
}
