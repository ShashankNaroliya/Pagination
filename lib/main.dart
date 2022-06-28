import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_list_pagination/model/data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;

  late int totalPages;

  List<Id> Ids = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getIdData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
    } else {
      if (currentPage >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri = Uri.parse("https://reqres.in/api/users?page=$currentPage");

    final response = await http.get(uri);

    if (response.statusCode == 2) {
      final result = IdsData.fromJson(response.body);

      if (isRefresh) {
        Ids = result.data;
      } else {
        Ids.addAll(result.data);
      }

      currentPage++;

      totalPages = result.page;

      print(response.body);
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infinite List Pagination"),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          final result = await getIdData(isRefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getIdData();
          if (result) {
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            final Id = Ids[index];

            return ListTile(
              title: Text(Id.email),
              subtitle: Text(Id.first_name),
              subtitle: Text(Id.last_name),
               trailing:  Image(Id.avatar)
                style: TextStyle(color: Colors.green),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: Ids.length,
        ),
      ),
    );
  }
}

