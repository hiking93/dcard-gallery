import 'package:dcard_gallery/screen/edit_forums.dart';
import 'package:dcard_gallery/shared/api/dcard_api.dart';
import 'package:dcard_gallery/shared/cache.dart';
import 'package:dcard_gallery/shared/model/forum.dart';
import 'package:dcard_gallery/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:dcard_gallery/screen/discover.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> _tabForumAliases;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 100,
    );
    _preparePage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            Theme(
              data: ThemeData(
                primaryColor: Colors.grey[50],
                accentColor: Theme.of(context).accentColor,
              ),
              child: SliverAppBar(
                title: Text('探索'),
                centerTitle: true,
                elevation: 2,
                forceElevated: true,
                floating: true,
                snap: true,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editForums();
                    },
                  ),
                ],
                bottom: _tabForumAliases == null
                    ? PreferredSize(
                        preferredSize: Size(double.infinity, 0.0),
                        child: Container(),
                      )
                    : TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: _tabForumAliases.map((forumAlias) {
                          return Tab(text: _getForumTabDisplay(forumAlias));
                        })?.toList(),
                      ),
              ),
            )
          ];
        },
        body: _tabForumAliases == null
            ? Container()
            : TabBarView(
                controller: _tabController,
                children: _tabForumAliases
                        ?.map((forum) => DiscoverPage(
                              key: ValueKey(forum),
                              forum: forum,
                            ))
                        ?.toList() ??
                    [],
              ),
      ),
    );
  }

  String _getForumTabDisplay(String forumAlias) {
    List<Forum> forumList = Cache.forumList;
    if (forumList == null) return '--';
    return forumList
            .firstWhere(
              (forum) => forum.alias == forumAlias,
              orElse: () => null,
            )
            ?.name ??
        forumAlias;
  }

  Future _preparePage() async {
    var forumList = Cache.forumList;
    if (forumList == null) {
      forumList = await DcardApiHelper.fetchForums().catchError((e) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: new Text(e.toString()),
          ));
      });
    }
    SharedPreferences prefs = await Prefs.getInstance();
    setState(() {
      Cache.forumList = forumList;
      _tabForumAliases = prefs.getStringList(Prefs.KEY_FORUMS) ??
          ['photography', 'pet', 'food'];
    });
  }

  void _editForums() async {
    if (Cache.forumList == null || _tabForumAliases == null) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: new Text('看板列表載入中，請稍後再試'),
        ));
    } else {
      List<String> result =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EditForumsPage(forumAliases: _tabForumAliases);
      }));
      if (result != null) {
        setState(() {
          _tabForumAliases = result;
        });
      }
    }
  }
}
