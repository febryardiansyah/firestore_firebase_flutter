import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_firebase_flutter/database_services.dart';
import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  final String score;
  final String name;
  final String genre;
  final DocumentSnapshot currentDoc;

  const EditData({Key key, this.score, this.name, this.genre,this.currentDoc}) : super(key: key);


  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController scoreCtrl = TextEditingController();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtrl.text = widget.name;
    scoreCtrl.text = widget.score;
//    _currentIndex = widget.genre;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Data'),
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
                    controller: nameCtrl,
                    decoration: InputDecoration(
                        labelText: 'Nama',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: scoreCtrl,
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
                    DatabaseServices.editData(nameCtrl.text, scoreCtrl.text, radioValue, widget.currentDoc);
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
