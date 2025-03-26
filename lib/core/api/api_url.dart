class ApiUrl {
  static const String baseUrl = 'http://165.22.253.163/api/v1';
  static const String login = '$baseUrl/auth/oauth/login';
  static const String user = '$baseUrl/user';
  static const String communities = '$baseUrl/communities';
  static const String communityPosts = '$baseUrl/posts';
  static const String createPost = '$baseUrl/posts/create';
  static const String postUpdate = '$baseUrl/posts/update';
  static const String topics = '$baseUrl/topics';
  static const String myPosts = '$baseUrl/user/posts';
  static const String savePosts = '$baseUrl/user/saved-posts';
  static const String likePost = '$baseUrl/like';
  static const String savePost = '$baseUrl/save';
  static const String groups = '$baseUrl/groups';
  static const String notification = '$baseUrl/notifications';
  static const String createComments = '$baseUrl/comments/create';
  static const String comments = '$baseUrl/comments';
}
