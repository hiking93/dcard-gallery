import 'package:dcard_gallery/shared/model/post.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoPage extends StatefulWidget {
  final List<Medium> media;
  final int index;

  PhotoPage(this.media, this.index);

  @override
  State<StatefulWidget> createState() => _PhotoPageState(media, index);
}

class _PhotoPageState extends State<PhotoPage> {
  final List<Medium> media;
  final int index;

  _PhotoPageState(this.media, this.index);

  int _page;

  void _onPageChanged(index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
    _page = index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                '圖片 ${_page + 1} / ${media.length}',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              elevation: 2,
            ),
          )),
      body: SafeArea(
        child: PageView.builder(
          controller: PageController(initialPage: index),
          itemCount: media.length,
          itemBuilder: (context, index) {
            String imageUrl = media[index].url;
            return Stack(
              key: ValueKey(imageUrl),
              fit: StackFit.expand,
              children: [
                Center(child: CircularProgressIndicator()),
                FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imageUrl,
                    fadeInDuration: Duration(milliseconds: 300),
                    fit: BoxFit.contain),
              ],
            );
          },
          onPageChanged: _onPageChanged,
        ),
      ),
    );
  }
}
