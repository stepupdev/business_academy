import 'dart:convert';

import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


@GenerateMocks([http.Client])
void main() {
  late CommunityRep communityRep;
  late MockClient mockClient;

  setUp(() {
    communityRep = CommunityRep();
    mockClient = MockClient(
      (http.Request request) async => http.Response('Not Found', 404),
    );
  });

  group('CommunityRep Tests', () {
    test('Create Post', () async {
      final mockResponse = {"success": true, "message": "Post created successfully"};

      when(
        mockClient.send(any as http.BaseRequest),
      ).thenAnswer((_) async => http.StreamedResponse(Stream.value(utf8.encode(jsonEncode(mockResponse))), 200));

      final response = await communityRep.communityPosts(
        content: "Test content",
        topicId: "1",
        imageFile: null,
        videoUrl: null,
      );

      expect(response['success'], true);
      expect(response['message'], "Post created successfully");
    });

    test('Create Comments', () async {
      final mockResponse = {"success": true, "message": "Comment added successfully"};

      when(
        mockClient.post(
          Uri.parse('${ApiUrl.createComments}'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final response = await communityRep.createComments({"post_id": "1", "content": "Test comment", "parent_id": "0"});

      expect(response['success'], true);
      expect(response['message'], "Comment added successfully");
    });

    test('Like Post', () async {
      final mockResponse = {"success": true, "message": "Post liked successfully"};

      when(
        mockClient.post(
          Uri.parse(ApiUrl.likePost),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final response = await communityRep.likePosts({"type": "App\\Models\\Post", "id": 1});

      expect(response['success'], true);
      expect(response['message'], "Post liked successfully");
    });

    test('Save Post', () async {
      final mockResponse = {"success": true, "message": "Post saved successfully"};

      when(
        mockClient.post(
          Uri.parse(ApiUrl.savePost),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final response = await communityRep.savePost({"post_id": 1});

      expect(response['success'], true);
      expect(response['message'], "Post saved successfully");
    });
  });
}
