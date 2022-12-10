import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_consts.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
// na kojoj smo stranici
  int _page = 0;
// koliko itema zelimo da dobijemo svaki put
  final int _limit = 20;
// da li je pokrenuto prvi put ili ne
  bool _isFirstLoadRunning = false;
// omogucava nam da znamo da li imamo jos data itemsa
  bool _hasNextPage = true;
// ako imamo jos itema ova metoda ce nam pomoci da to loadujemo i
// prikazuje CircularProgressIndicator dok loaduje
  bool _isLoadMoreRunning = false;

// za postovanje informacija koje dobijemo od endpointa, snimamo u listu
  List _posts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // display progress indicator at the bottom
      });

      _page += 1; // increase page by 1 (novih 20 itema)

      try {
        final res = await http
            .get(Uri.parse('${BASE_URL}photos?_page=$_page&_limit=$_limit'));
        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (e) {
        //print(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false; // display progress indicator at the bottom
      });
    }
  }

// kad se prvi put otvori app, ucitavamo data(prvih 20 itema)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    // try metod za ucitavanje itema
    try {
      final res = await http
          .get(Uri.parse('${BASE_URL}photos?_page=$_page&_limit=$_limit'));
      setState(() {
        _posts = json.decode(res.body);
      });
    } catch (e) {
      //print(e.toString());
    }
    // kad se ucita prvih 20, stavljamo u false
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: FlutterLogo(),
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      height: 800,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  InkWell(
                                    onTap: () {
                                      context.go('/');
                                      Navigator.pop(context);
                                    },
                                    child: const ListTile(
                                      leading: FlutterLogo(size: 56.0),
                                      title: Text('Home Page'),
                                      subtitle: Text('Displays comments'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      context.go('/page2');
                                      Navigator.pop(context);
                                    },
                                    child: const ListTile(
                                      leading: FlutterLogo(size: 56.0),
                                      title: Text('Second Page'),
                                      subtitle: Text('Displays images'),
                                    ),
                                  ),
                                  const SizedBox(height: 200),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.density_medium_rounded))
        ],
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      controller: _controller,
                      itemCount: _posts.length,
                      itemBuilder: (_, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          _posts[index]['url'],
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }
}
