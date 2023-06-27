import 'package:flutter/material.dart';
import 'package:os_project/checkin.dart';
import 'package:os_project/result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Colors.white,
          leading: const Icon(Icons.language),
          title: const Text("GPS LOCATION"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[300],
          onPressed: () {},
          child: const Icon(Icons.home),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.pink[200],
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                tooltip: 'Check-In Location',
                icon: const Icon(
                  Icons.pin_drop_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MainScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Check-In Location',
                icon: const Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ShowResult(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/7572144.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 200),
                    Card(
                      elevation: 10,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white70),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const MainScreen(),
                                  ),
                                );
                              },
                              child: const Text("Check-In Location",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 100,
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white70),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ShowResult(),
                                  ),
                                );
                              },
                              child: const Text("Show Result",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
