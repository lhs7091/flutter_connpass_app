import 'package:flutter/material.dart';
import 'package:flutter_connpass_app/export_path.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  ReadAPI _readAPI = ReadAPI();
  List<Events> _eventList = List<Events>();

  String keyword;
  int pageNum = 0;

  final controller = ScrollController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          setState(() {
                            pageNum = 0;
                            keyword = _controller.text;
                          });
                          _searchList(_controller.text);
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
      body: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _eventList != null && _eventList.length != 0
                  ? ListView.builder(
                      itemCount: _eventList.length,
                      itemExtent: 120.0,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print(_eventList[
                                              _eventList.length - index - 1]
                                          .eventUrl);
                                      _launchURL(_eventList[
                                              _eventList.length - index - 1]
                                          .eventUrl);
                                    },
                                    child: Text(
                                      _eventList[index].title,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _eventList[
                                                _eventList.length - index - 1]
                                            .startedAt
                                            .replaceAll("T", "\n")
                                            .replaceAll("+", "~")
                                            .replaceFirst(":00", ""),
                                      ),
                                      Text(
                                        _eventList[_eventList.length -
                                                        index -
                                                        1]
                                                    .place !=
                                                null
                                            ? _eventList[_eventList.length -
                                                    index -
                                                    1]
                                                .place
                                            : '無',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('keywordを入力して、\n検索ボタンを押してください。'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _searchList(String keyword) async {
    await _readAPI.getEventData(keyword, pageNum).then((value) {
      if (value == null) {
        pageNum++;
        _searchList(keyword);
      }
      setState(() {
        _eventList = value;
        pageNum += 1;
      });
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    await _readAPI.getEventData(keyword, pageNum).then((List<Events> value) {
      setState(() {
        pageNum += 1;
        if (value != null) {
          value.forEach((element) {
            _eventList.add(element);
          });
        } else {
          _onRefresh();
        }
      });
    });
  }
}
