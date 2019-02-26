import 'package:dcard_gallery/shared/cache.dart';
import 'package:dcard_gallery/shared/model/forum.dart';
import 'package:dcard_gallery/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditForumsPage extends StatefulWidget {
  final List<String> forumAliases;

  EditForumsPage({Key key, @required this.forumAliases}) : super(key: key);

  @override
  _EditForumsPageState createState() => _EditForumsPageState(forumAliases);
}

class _EditForumsPageState extends State<EditForumsPage>
    with TickerProviderStateMixin {
  List<String> forumAliases;

  _EditForumsPageState(this.forumAliases);

  @override
  Widget build(BuildContext context) {
    var safeAreaPadding = MediaQuery.of(context).padding;
    EdgeInsets listPadding = EdgeInsets.only(
        top: 8,
        left: safeAreaPadding.left,
        right: safeAreaPadding.right,
        bottom: safeAreaPadding.bottom + 8);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: Theme(
            data: ThemeData(
              primaryColor: Colors.grey[50],
              accentColor: Theme.of(context).accentColor,
            ),
            child: AppBar(
              title: Text(
                '編輯看板',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              elevation: 2,
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _showAddForumDialog();
                  },
                ),
              ],
            ),
          )),
      body: Builder(
        builder: (context) {
          return NotificationListener(
            child: ReorderableListView(
              padding: listPadding,
              onReorder: _onReorder,
              children: forumAliases.asMap().entries.map((entry) {
                int index = entry.key;
                String forumAlias = entry.value;
                return Dismissible(
                  key: Key(forumAlias),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    _onDismissed(context, index);
                  },
                  background: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    color: Colors.red[100],
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                    ),
                  ),
                  child: ListTile(
                    key: Key(forumAlias),
                    title: Text(_getForumDisplay(forumAlias)),
                    trailing: Icon(Icons.drag_handle),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      var item = forumAliases.removeAt(oldIndex);
      forumAliases.insert(newIndex, item);
      _saveResults();
    });
  }

  void _onDismissed(BuildContext context, int index) {
    setState(() {
      if (forumAliases.length > 1) {
        forumAliases.removeAt(index);
        _saveResults();
      } else {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: new Text('不准刪光光'),
          ));
      }
    });
  }

  Future _saveResults() async {
    SharedPreferences prefs = await Prefs.getInstance();
    await prefs.setStringList(Prefs.KEY_FORUMS, forumAliases);
  }

  String _getForumDisplay(String forumAlias) {
    return Cache.forumList
            .firstWhere(
              (forum) => forum.alias == forumAlias,
              orElse: () => null,
            )
            ?.name ??
        forumAlias;
  }

  void _showAddForumDialog() {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新增看板'),
          content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '輸入看板名稱或代號',
                ),
                validator: (value) {
                  value = value.trim();
                  Forum forum = Cache.forumList.firstWhere(
                      (forum) => forum.name == value || forum.alias == value,
                      orElse: () => null);
                  return (forum == null) ? '找不到「$value」' : null;
                },
                onSaved: (value) {
                  value = value.trim();
                  Forum forum = Cache.forumList.firstWhere(
                      (forum) => forum.name == value || forum.alias == value);
                  forumAliases
                    ..remove(forum.alias)
                    ..add(forum.alias);
                },
              )),
          actions: <Widget>[
            FlatButton(
              child: Text("新增"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _formKey.currentState.save();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
