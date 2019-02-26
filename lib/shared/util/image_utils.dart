class ImageUtils {
  static String makeImgurThumbnailUrl(String url, String thumbnailModifier) {
    RegExp regex = new RegExp(
      r"https?://(?:(?:i\\.)?imgur\\.com|imgur\\.dcard\\.tw)/(\\w+)(\\.\\w+)?",
      caseSensitive: false,
    );
    if (regex.hasMatch(url)) {
      Match match = regex.firstMatch(url);
      String imageId = match.group(1);
      String fileExt = match.group(2);

      // Trim thumbnail modifier at the end
      if (imageId.length % 2 == 0) {
        imageId = imageId.substring(0, imageId.length - 1);
      }

      // Add file extension if it does not exist in the url
      if (fileExt == null) {
        fileExt = '.jpg';
      } else if (fileExt == 'gifv') {
        fileExt = '.gif';
      }

      return "https://i.imgur.com/$imageId$thumbnailModifier$fileExt";
    } else {
      return url;
    }
  }
}
