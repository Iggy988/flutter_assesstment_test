import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/coment_user_repository.dart';

import '../../models/comments_model.dart';
import '../widgets/search_user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController listScrollController = ScrollController();
  FetchUserCommentsList _userList = FetchUserCommentsList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: FlutterLogo(),
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
                showSearch(context: context, delegate: SearchUser());
              },
              icon: const Icon(Icons.search_sharp),
            ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (listScrollController.hasClients) {
              final position = listScrollController.position.minScrollExtent;
              listScrollController.animateTo(
                position,
                duration: const Duration(seconds: 3),
                curve: Curves.easeOut,
              );
            }
          },
          isExtended: true,
          tooltip: "Scroll to Top",
          child: const Icon(Icons.arrow_upward),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<CommentsModel>>(
            future: _userList.getuserList(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              return ListView.builder(
                controller: listScrollController,
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ExpansionTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${data?[index].id}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      title: Text('${data?[index].email}'),
                      children: [
                        Text('${data?[index].body}'),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
