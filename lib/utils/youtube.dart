const youtubeBaseUrl = "https://youtube.com/watch?v=";
const youtubeIdLength = 11;

bool isYoutubeUrl(String url) {
  if (url.startsWith(youtubeBaseUrl)) {
    return true;
  }
  return false;
}

String getYoutubeId(String url) {
  return url.substring(
    youtubeBaseUrl.length,
    youtubeBaseUrl.length + youtubeIdLength,
  );
}

String getYoutubeThumbnailUrl(String videoId) {
  return "https://img.youtube.com/vi/$videoId/mqdefault.jpg";
}
