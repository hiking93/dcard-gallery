class Forum {
  final String name;
  final String alias;

  Forum({
    this.name,
    this.alias,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      name: json['name'],
      alias: json['alias'],
    );
  }
}
