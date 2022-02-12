import 'dart:convert' as cnv;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';
import 'package:pharma_inc/model_users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isLoading = false;
  List usersData = <dynamic>[];
  List usersFiltered = <dynamic>[];
  String query = '';
  final Color strongblue = const Color(0xFF0083CA);
  final Color darktangerine = const Color(0xFFFCAF17);

  TextEditingController _searchTextController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    CircularProgressIndicator();
    fetchUser();
    _searchTextController.addListener(() {
      print(_searchTextController.text);
      query = _searchTextController.text;
      setState(() {});
    });
  }

  Future<List<dynamic>> fetchUser() async {
    var url = Uri.parse('https://randomuser.me/api/?results=50');
    http.Response result = await http.get(url);
    return cnv.jsonDecode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['name']['title'] +
        " " +
        user['name']['first'] +
        " " +
        user['name']['last'];
  }

  String _email(dynamic user) {
    return user['email'];
  }

  String _dateUser(dynamic user) {
    return DateFormat.yMd().format(DateTime.parse(user['dob']['date']));
  }

  String _gender(dynamic user) {
    return user['gender'];
  }

  String _phone(dynamic user) {
    return user['phone'];
  }

  String _cell(dynamic user) {
    return user['cell'];
  }

  String _address(dynamic user) {
    return user['location']['street']["name"] +
        ", " +
        user['location']['street']["number"].toString() +
        ", " +
        user['location']["city"] +
        ", " +
        user['location']["state"] +
        "/" +
        user['location']["country"] +
        ", " +
        user['location']["postcode"].toString();
  }

  String _id(dynamic user){
    return user["id"]["name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _body());
  }

  Container _body() {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: fetchUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Flex(
              direction: Axis.vertical,
              children: [
                //adicionar filtro aqui
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                controller: _searchTextController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.blue,
                    size: 50.0,
                  ),
                  border: InputBorder.none,
                  hintText: 'Digite o nome do usuario desejado',
                ),
            ),
              ),
                const SizedBox(height: 30,),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                            child: Card(
                              child: _expansionTileCard(snapshot, index),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: strongblue,
                valueColor: AlwaysStoppedAnimation<Color>(darktangerine),
              ),
            );
          }
        },
      ),
    );
  }

  ExpansionTileCard _expansionTileCard(AsyncSnapshot<dynamic> snapshot, int index) {
    return ExpansionTileCard(
                            baseColor: Colors.cyan[50],
                            expandedColor: Colors.red[50],
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  snapshot.data[index]['picture']['large']),
                            ),
                            // title: Text(_name(snapshot.data[index])),
                            title: Text("Nome: ${_name(snapshot.data[index])}"),
                            subtitle: Text(
                                "Email: ${_email(snapshot.data[index])} "
                                    "\nData Nascimento: ${_dateUser(snapshot.data[index])}"),
                            children: <Widget>[
                              const Divider(
                                thickness: 1.0,
                                height: 1.0,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Text("ID: ${_id(snapshot.data[index])}"
                                      "\nGênero: ${_gender(snapshot.data[index])} \nTelefone: ${_phone(snapshot.data[index])}"
                                          "\nCelular: ${_cell(snapshot.data[index])}"
                                          "\nEndereço: ${_address(snapshot.data[index])}"),
                                ),
                              ),
                            ],
                          );
  }

}


