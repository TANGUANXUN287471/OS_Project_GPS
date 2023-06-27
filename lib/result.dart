import 'dart:convert';

import 'package:flutter/material.dart';
import 'model/myconfig.dart';
import 'model/user.dart';
import 'package:http/http.dart' as http;

class ShowResult extends StatefulWidget {
  const ShowResult({super.key});

  @override
  State<ShowResult> createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  String dialog = "No Data Available";
  List<User> itemList = <User>[];
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Result"),
      ),
      body: itemList.isEmpty
          ? Center(
              child: Text(dialog),
            )
          : Stack(
              children: [
                // Container(
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage("assets/images/42660.jpg"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                SafeArea(
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        color: const Color.fromARGB(255, 48, 212, 48),
                        alignment: Alignment.center,
                        child: Text(
                          "${itemList.length} Users Checked-In",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: itemList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showDetails(index);
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(8),
                                    tileColor: Colors.white60,
                                    visualDensity: const VisualDensity(
                                        horizontal: 2, vertical: 1),
                                    leading: const CircleAvatar(
                                        backgroundColor: Colors.blueGrey,
                                        child: Icon(Icons.person,
                                            color: Colors.white)),
                                    title: Text(
                                      "Name :  ${itemList[index].name}",
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Matric No : ${itemList[index].num}",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Check-in Time : ${itemList[index].datereg}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: const Icon(Icons.check_box,
                                        color: Colors.cyan),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void loadUser() {
    http.post(Uri.parse("${MyConfig().server}/gps_location/php/loaduser.php"),
        body: {}).then((response) {
      debugPrint(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        debugPrint(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['user'].forEach((v) {
            itemList.add(User.fromJson(v));
          });
          print(itemList[0].name);
        }
        setState(() {});
      }
    });
  }

  void _showDetails(index) {
    showModalBottomSheet(
      elevation: 20,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 600,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close")),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
                  child: Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(itemList[index].name.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              )),
                          title: Text("# ${itemList[index].num.toString()}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text("Phone Number"),
                          subtitle: Text(itemList[index].phone.toString()),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 4, 0),
                          minVerticalPadding: 0,
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email"),
                          subtitle: Text(itemList[index].email.toString()),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 4, 0),
                          minVerticalPadding: 0,
                        ),
                        ListTile(
                          leading: const Icon(Icons.timer_sharp),
                          title: const Text("Check-In Time"),
                          subtitle: Text(itemList[index].datereg.toString()),
                        ),
                        ListTile(
                          leading: const Icon(Icons.pin_drop),
                          title: const Text("Location"),
                          subtitle: Text(
                              "${itemList[index].state.toString()}, ${itemList[index].city.toString()}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.arrow_downward_outlined),
                          title: const Text("Coordinates"),
                          subtitle: Text(
                              "${itemList[index].lat.toString()}, ${itemList[index].long.toString()}"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
