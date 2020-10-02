import 'package:flutter/material.dart';
import 'package:flutter_connpass_app/export_path.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchListScreen extends StatefulWidget {
  @override
  _SearchListScreenState createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  List<Events> _eventList;
  ReadAPI _readAPI = ReadAPI();
  int pageNum;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnpassProviderService>(
      builder: (BuildContext context, eventList, child) {
        if (eventList.getEventList().length > 0) {
          _eventList = eventList.getEventList();
          return Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    children: [
                      ListView.builder(
                        itemCount: _eventList.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
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
                              child: ListTile(
                                onTap: () {
                                  _launchURL(
                                      _eventList[_eventList.length - index - 1]
                                          .eventUrl);
                                },
                                title: new Text(
                                  _eventList[_eventList.length - index - 1]
                                      .title,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF182545),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_eventList[
                                            _eventList.length - index - 1]
                                        .startedAt
                                        .replaceAll("T", " ")
                                        .replaceAll("+", "~")
                                        .replaceFirst(":00", "")),
                                    Text(
                                      _eventList[_eventList.length - index - 1]
                                                  .place !=
                                              null
                                          ? _eventList[
                                                  _eventList.length - index - 1]
                                              .place
                                          : '無',
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: -10.0,
                                  runSpacing: 0.0,
                                  children: [
                                    _buildAppFavoriteIcon(_eventList[
                                        _eventList.length - index - 1]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildAppFavoriteIcon(Events event) {
    ConnpassProviderService connpassProviderService =
        Provider.of<ConnpassProviderService>(context, listen: false);

    final bool alreadySaved =
        connpassProviderService.getFavoriteList().contains(event);

    return IconButton(
        icon: alreadySaved ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        color: Color(0xFF9097A6),
        onPressed: () {
          setState(() {
            if (alreadySaved)
              connpassProviderService.removeFavoriteList(event);
            else
              connpassProviderService.addFavoriteList(event);
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
    print('onRefresh start');
    ConnpassProviderService connpassProviderService =
        Provider.of<ConnpassProviderService>(context, listen: false);
    connpassProviderService.refreshSearchList();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
  }
}
