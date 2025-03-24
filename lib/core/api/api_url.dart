class ApiUrl {
  static const String baseUrl = 'http://165.22.253.163/api/v1';
  static const String login = '$baseUrl/auth/oauth/login';
  static const String communityPosts = '$baseUrl/posts';
  static const String createPost = '$baseUrl/posts/create';
  static const String topics = '$baseUrl/topics';
  static const String myPosts = '$baseUrl/user/posts';
  static const String savePosts = '$baseUrl/user/saved-posts';
  static const String likePost = '$baseUrl/like';
  static const String savePost = '$baseUrl/save';
}