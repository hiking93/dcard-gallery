import 'dart:async';
import 'dart:math';

import 'package:dcard_gallery/shared/widget/post_list_item.dart';
import 'package:dcard_gallery/shared/widget/progress_list_item.dart';
import 'package:flutter/material.dart';
import 'package:dcard_gallery/shared/api/dcard_api.dart';
import 'package:dcard_gallery/shared/model/post.dart';

class DiscoverPage extends StatefulWidget {
  final String forum;

  const DiscoverPage({Key key, this.forum}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DiscoverPageState(forum: forum);
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  String forum;

  // View control
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // Data for ListView
  List<Widget> _widgets;

  // Raw data from API
  StreamSubscription<List<Post>> _postApiCall;
  List<Post> _posts;
  bool _endOfList = false;

  _DiscoverPageState({this.forum});

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refresh();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQueryData = MediaQuery.of(context);
    EdgeInsets listPadding;
    var safeAreaPadding = mediaQueryData.padding;
    if (mediaQueryData.orientation == Orientation.portrait) {
      listPadding = EdgeInsets.only(
          left: safeAreaPadding.left,
          right: safeAreaPadding.right,
          bottom: safeAreaPadding.bottom);
    } else {
      final screenSize = mediaQueryData.size;
      final horizontalPadding = (screenSize.width - screenSize.height) / 2;
      listPadding = EdgeInsets.only(
          left: max(safeAreaPadding.left, horizontalPadding),
          right: max(safeAreaPadding.right, horizontalPadding),
          bottom: safeAreaPadding.bottom);
    }

    return Container(
      color: Colors.grey[300],
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        child: NotificationListener<ScrollNotification>(
          child: ListView.builder(
            padding: listPadding,
            itemCount: _widgets?.length ?? 0,
            itemBuilder: (context, index) {
              return _widgets[index];
            },
          ),
          onNotification: (ScrollNotification scrollInfo) {
            if (!_endOfList && scrollInfo.metrics.extentAfter < 640) {
              _fetchPosts(
                  before: _posts?.isNotEmpty == true ? _posts.last.id : null);
            }
          },
        ),
        onRefresh: () => _refresh(),
      ),
    );
  }

  Future<List<Post>> _refresh() {
    _endOfList = false;
    return _fetchPosts();
  }

  Future<List<Post>> _fetchPosts({int before}) {
    _postApiCall?.cancel();
    Future<List<Post>> postApiCall = DcardApiHelper.fetchPosts(
      forum: forum,
      before: before,
      limit: 100,
    ).catchError((e) {
      print('Posts error of $forum: ${e.toString()}');
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: new Text(e.toString()),
        ));
      return null;
    });
    _postApiCall = postApiCall.asStream().listen((posts) {
      postApiCall = null;
      if (posts == null) {
        return;
      }
      if (posts.isEmpty) {
        _endOfList = true;
      } else if (before == null) {
        _posts = posts;
      } else {
        _posts += posts;
      }
      _notifyList();
    });
    return postApiCall;
  }

  void _notifyList() {
    if (!this.mounted) {
      return;
    }
    setState(() {
      List<Widget> widgets = List()
        ..addAll(_posts.map((post) => PostListItem(post)));
      if (!_endOfList) {
        widgets.add(ProgressListItem());
      }
      _widgets = widgets;
    });
  }
}
