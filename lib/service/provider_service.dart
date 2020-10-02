import 'package:flutter/cupertino.dart';
import 'package:flutter_connpass_app/export_path.dart';

class ConnpassProviderService with ChangeNotifier {
  List<Events> _eventList = List<Events>();
  List<Events> getEventList() => _eventList;

  ReadAPI _readAPI = ReadAPI();

  String _keyword;
  String getKeyword() => _keyword;

  int _pageNum;
  int getPageNum() => _pageNum;

  // initial search
  void getSearchList() async {
    print('getSearchList start');
    await _readAPI.getEventData(_keyword, _pageNum).then((value) {
      _pageNum++;
      if (value == null || value.length == 0) {
        getSearchList();
        if (_pageNum == 100) return;
      }
      _eventList = value;
    });
    notifyListeners();
  }

  // for refresh
  void refreshSearchList() async {
    print('refreshSearchList start');
    await _readAPI.getEventData(_keyword, _pageNum).then((value) {
      _pageNum++;
      if (value == null || value.length == 0) {
        refreshSearchList();
        if (_pageNum == 100) return;
      } else {
        value.forEach((element) {
          _eventList.add(element);
        });
      }
    });
    notifyListeners();
  }

  void setKeyword(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  void setPageNum(int pageNum) {
    _pageNum = pageNum;
    notifyListeners();
  }

  // for favorite
  List<Events> _favoriteList = List<Events>();
  List<Events> getFavoriteList() => _favoriteList;
  void addFavoriteList(Events event) {
    _favoriteList.add(event);
    notifyListeners();
  }

  void removeFavoriteList(Events event) {
    _favoriteList.remove(event);
    notifyListeners();
  }
}
