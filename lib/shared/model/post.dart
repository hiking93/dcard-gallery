class Post {
  final int id;
  final String title;
  final String excerpt;
  final String school;
  final String department;
  final String gender;
  final bool withNickname;
  final String forumAlias;
  final List<Medium> media;

  Post({
    this.id,
    this.title,
    this.excerpt,
    this.school,
    this.department,
    this.gender,
    this.withNickname,
    this.forumAlias,
    this.media,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      school: json['school'],
      department: json['department'],
      gender: json['gender'],
      withNickname: json['withNickname'],
      forumAlias: json['forumAlias'],
      media: json['media']
          .map<Medium>((mediumJson) => Medium.fromJson(mediumJson))
          .toList(),
    );
  }
}

class Medium {
  final String url;

  Medium({this.url});

  factory Medium.fromJson(Map<String, dynamic> json) {
    return Medium(url: json['url']);
  }
}
