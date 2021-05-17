import 'package:flutter/material.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/forum/forum_screen.dart';
import 'package:subb_front/utils/api_collection.dart';

// Todo: Today's statistics on homepage
class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<ApiResponse> _futureResponse;

  @override
  void initState() {
    super.initState();
    _futureResponse = getHomepage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          // Todo: Navigate to search screen.
        },
        child: Icon(Icons.search),
      ),
      body: FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return RefreshIndicator(
                  child: ThreadsPage(
                      threads:
                          parseThreads(snapshot.data!.data! as List<dynamic>)),
                  onRefresh: () {
                    setState(() {
                      _futureResponse =
                          getHomepage();
                    });
                    return _futureResponse;
                  },
                );
              }
          }
        },
      ),
    );
  }
}
