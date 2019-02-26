import 'package:dcard_gallery/screen/photo.dart';
import 'package:dcard_gallery/shared/model/post.dart';
import 'package:dcard_gallery/shared/util/avatar_utils.dart';
import 'package:dcard_gallery/shared/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  PostListItem(this.post) : super(key: ValueKey(post.id));

  @override
  Widget build(context) => _buildPostWidget(context, post);

  Widget _buildPostWidget(BuildContext context, Post post) {
    var media = post.media;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAuthorWidget(),
        media.length > 0
            ? _buildPhotoPagerWidget(context, media)
            : SizedBox(height: 1),
        _buildContentWidget(context),
        _buildDividerWidget(),
      ],
    );
  }

  Widget _buildAuthorWidget() {
    final List<Widget> rowChildren = [
      post.withNickname
          ? AvatarUtils.getPersonaAvatar(
              gender: post.gender,
              personaId: post.department,
              width: 24,
              height: 24,
            )
          : AvatarUtils.getGenderAvatar(
              gender: post.gender,
              width: 24,
              height: 24,
            ),
      SizedBox(width: 12),
      Text(post.school ?? '匿名'),
    ];
    if (post.department != null) {
      rowChildren
        ..add(SizedBox(width: 8))
        ..add(Text(
          post.withNickname ? '@${post.department}' : post.department,
          style: TextStyle(
            color: post.withNickname ? Colors.black54 : Colors.black87,
          ),
        ));
    }
    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: rowChildren,
        ),
      ),
    );
  }

  Widget _buildPhotoPagerWidget(BuildContext context, List<Medium> media) {
    return AspectRatio(
      aspectRatio: 1,
      child: PageIndicatorContainer(
        pageView: PageView.builder(
          controller: PageController(),
          itemCount: media.length,
          itemBuilder: (context, index) {
            String imageUrl =
                ImageUtils.makeImgurThumbnailUrl(media[index].url, 'm');
            return Material(
              key: ValueKey(imageUrl),
              color: Color(0xffc8d1d7),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(child: CircularProgressIndicator()),
                  FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: imageUrl,
                      fadeInDuration: Duration(milliseconds: 300),
                      fit: BoxFit.contain),
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PhotoPage(media, index);
                        }));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        length: media.length,
        padding: EdgeInsets.only(bottom: 8),
        indicatorColor: Color(0xaaaaaaaa),
        indicatorSelectorColor: Theme.of(context).accentColor,
        size: 8,
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    return Material(
      color: Colors.grey[50],
      child: InkWell(
        onTap: () => _viewPost(post),
        child: Padding(
          padding: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.title,
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: post.excerpt.isNotEmpty
                    ? Text(
                        post.excerpt,
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWidget() {
    return Container(
      height: 16,
    );
  }

  void _viewPost(Post post) async {
    final String url = 'https://www.dcard.tw/f/${post.forumAlias}/p/${post.id}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
