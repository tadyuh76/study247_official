const youtubeBaseUrl1 = "https://youtube.com/watch?v=";
const youtubeBaseUrl2 = "https://youtu.be/";
const youtubeBaseUrl3 = "https://m.youtube.com/watch?v=";
const youtubeIdLength = 11;

bool isYoutubeUrl(String url) {
  if (url.startsWith(youtubeBaseUrl1) ||
      url.startsWith(youtubeBaseUrl2) ||
      url.startsWith(youtubeBaseUrl3)) {
    return true;
  }
  return false;
}

String getYoutubeId(String url) {
  if (url.startsWith(youtubeBaseUrl1)) {
    return url.substring(
      youtubeBaseUrl1.length,
      youtubeBaseUrl1.length + youtubeIdLength,
    );
  } else if (url.startsWith(youtubeBaseUrl2)) {
    return url.substring(
      youtubeBaseUrl2.length,
      youtubeBaseUrl2.length + youtubeIdLength,
    );
  } else {
    return url.substring(
      youtubeBaseUrl3.length,
      youtubeBaseUrl3.length + youtubeIdLength,
    );
  }
}

String getYoutubeThumbnailUrl(String videoId) {
  return "https://img.youtube.com/vi/$videoId/mqdefault.jpg";
}
