import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_firebase_flutter/database_services.dart';
import 'package:flutter/material.dart';

class AddAnimex extends StatefulWidget {
  @override
  _AddAnimexState createState() => _AddAnimexState();
}

class _AddAnimexState extends State<AddAnimex> {
  String name,score;

  getName(name){
    this.name = name;
  }

  getScore(score){
    this.score = score;
  }

  int _currentIndex = 0;
  String radioValue;

  void pilihanRadion(int type){
    setState(() {
      _currentIndex = type;
      switch(_currentIndex){
        case 1:
          radioValue = 'Romance';
          break;
        case 2:
          radioValue = 'Comedy';
          break;
        case 3:
          radioValue = 'Action';
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ADD'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-80,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (String name){
                      getName(name);
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama'
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (String score){
                      getScore(score);
                    },
                    decoration: InputDecoration(
                        labelText: 'Score'
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Pilih Genre'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: _currentIndex,
                          onChanged: pilihanRadion,
                          activeColor: Colors.red,
                        ),
                        Text('Romance')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: 2,
                          groupValue: _currentIndex,
                          onChanged: pilihanRadion,
                          activeColor: Colors.red,
                        ),
                        Text('Comedy')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: 3,
                          groupValue: _currentIndex,
                          onChanged: pilihanRadion,
                          activeColor: Colors.red,
                        ),
                        Text('Action')
                      ],
                    ),
                  ],
                ),
                FloatingActionButton(
                  child: Text('+'),
                  onPressed: (){
                    DatabaseServices.addData(name, score, radioValue);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
