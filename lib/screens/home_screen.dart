import 'package:flutter/material.dart';
import 'package:flutter_connpass_app/export_path.dart';
import 'package:provider/provider.dart';

import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();

  String keyword;
  int pageNum = 0;

  final controller = ScrollController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConnpassProviderService connpassProviderService =
        Provider.of<ConnpassProviderService>(context);
    return Scaffold(
      backgroundColor: Color(0xFFE6F9FF),
      appBar: ScrollAppBar(
        controller: controller,
        backgroundColor: Colors.white,
        title: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60.0,
                  width: 110.0,
                  child: Image(
                    image: AssetImage('assets/images/connpass_logo_1.png'),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: 220.0,
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter a keyword",
                      suffixIcon: IconButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_controller.text.isEmpty)
                            return Toast.show("keywordを入力してください。", context);
                          connpassProviderService.setPageNum(0);
                          connpassProviderService.setKeyword(_controller.text);
                          connpassProviderService.getSearchList();
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: _currentIndex == 0 ? _page1() : _page2(), //_page1(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          _bottomeNavItem(Icons.list, "Searching"),
          _bottomeNavItem(Icons.favorite, "Favorite")
        ],
        onTap: onTabTapped,
      ),
    );
  }

  // return search page
  Widget _page1() {
    ConnpassProviderService connpassProviderService =
        Provider.of<ConnpassProviderService>(context);
    return connpassProviderService.getEventList() != null &&
            connpassProviderService.getEventList().length != 0
        ? SearchListScreen()
        : Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    'keywordを入力して、\n検索ボタンを押してください。',
                    style: TextStyle(fontSize: 18.0),
                  ),
          );
  }

  // return favorite page
  Widget _page2() {
    ConnpassProviderService connpassProviderService =
        Provider.of<ConnpassProviderService>(context);
    return connpassProviderService.getFavoriteList() != null &&
            connpassProviderService.getFavoriteList().length != 0
        ? FavoriteListScreen()
        : Center(
            child: Text(
              'Favoriteがありません。',
              style: TextStyle(fontSize: 18.0),
            ),
          );
  }

  _bottomeNavItem(IconData iconData, String title) {
    return BottomNavigationBarItem(
        icon: new Icon(
          iconData,
          color: Color(0xFFE9E9E9),
        ),
        activeIcon: new Icon(
          iconData,
          color: Color(0xFF6D7381),
        ),
        label: title);
  }

  void onTabTapped(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
  }
}
