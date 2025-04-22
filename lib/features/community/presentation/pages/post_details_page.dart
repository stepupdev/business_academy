// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/core/utils/helper_utils.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/data/posts/posts_models.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/community/presentation/widgets/comment_widget.dart';
import 'package:business_application/features/community/presentation/widgets/post_details_card.dart';
import 'package:business_application/features/community/presentation/widgets/post_details_shimmer.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;
  final Posts? post;
  final bool isVideo;
  final String? commentId;
  // late bool isGroupPost;
  // late String? groupId;
  final bool fromSearchPage;

  PostDetailsPage({
    super.key,
    required this.postId,
    this.post,
    this.commentId,
    this.isVideo = true,
    this.fromSearchPage = false,
    // required this.isGroupPost,
    // this.groupId,
  }) {
    // Add debug print to see the values being passed
    debugPrint("POST DETAILS PAGE CONSTRUCTOR:  postId=$postId, fromSearchPage=$fromSearchPage");
  }
  @override
  PostDetailsPageState createState() => PostDetailsPageState();
}

class PostDetailsPageState extends State<PostDetailsPage> with AutomaticKeepAliveClientMixin {
  late ScrollController commentsScrollController;

  @override
  bool get wantKeepAlive => true;
  late CommunityController communityController;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isReplying = false;
  int? _replyingTo;
  bool _isInitialized = false; // To ensure the logic runs only once

  @override
  void initState() {
    super.initState();
    commentsScrollController = ScrollController();
    commentsScrollController.addListener(() {
      if (commentsScrollController.hasClients) {
        if (commentsScrollController.position.pixels >= commentsScrollController.position.maxScrollExtent - 300) {
          communityController.loadNextCommentsPage(widget.postId);
        }
        if (widget.commentId != null) {
          // jump to that specific comment
          final index = communityController.comments.value.result?.data?.indexWhere(
            (element) => element.id == widget.commentId,
          );
          if (index != null && index >= 0) {
            commentsScrollController.jumpTo(index * 100.0); // Adjust the multiplier as needed
          }
        }
      }
    });
    debugPrint("Widget group id: ${widget.post?.groupId}");
    communityController = Get.find<CommunityController>();
    communityController.scrollController.addListener(() {
      if (communityController.scrollController.hasClients) {
        if (communityController.commentsScrollController.position.pixels >=
            communityController.commentsScrollController.position.maxScrollExtent - 300) {
          communityController.loadNextCommentsPage(widget.postId);
        }
      }
    });
    // if (widget.post != null) {
    //   // find the topic name and match it with groups fetches topic name, if it's matches, then set the isGroupPost to true
    //   final groupController = Get.find<GroupsController>();
    //   if (groupController.groupsTopicResponse.value.result?.data?.isNotEmpty ?? false) {
    //     for (var topic in groupController.groupsTopicResponse.value.result!.data!) {
    //       if (topic.name == widget.post?.topic?.name) {
    //         widget.isGroupPost = true;

    //         break;
    //       }
    //     }
    //   }
    // }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isInitialized) {
      debugPrint("From search Page: ${widget.fromSearchPage}");

      final controller = Get.find<CommunityController>();
      controller.selectedPostId.value = int.tryParse(widget.postId) ?? 0;
      // controller.getCommunityPostsById(widget.postId);
      if (widget.post?.commentsCount != null) {
        await controller.getComments(widget.postId);
      }

      // Initialize group controller if this is a group post
      if (widget.post?.groupId != null) {
        debugPrint("POST DETAILS: This is a group post! Loading group details...");
        final groupController = Get.find<GroupsController>();
        groupController.selectedPostId.value = int.tryParse(widget.postId) ?? 0;
        groupController.currentGroupId.value = widget.post?.groupId.toString() ?? "";
        // Preload group topics
        groupController.fetchGroupsTopic(widget.post?.groupId.toString() ?? "");
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    commentsScrollController.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dark = Ui.isDarkMode(context);
    final controller = Get.find<CommunityController>();
    final currentUserId = Get.find<AuthService>().currentUser.value.result?.user?.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? AppColors.dark : AppColors.light,
        title: Text(widget.post?.groupId != null ? 'Group Post Details' : 'Post Details'),
        actions: [
          if (widget.post?.user?.id == currentUserId)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // Debug information to verify values
                  final isGroupPost = true;
                  final groupId = widget.post?.groupId.toString();

                  debugPrint("POST DETAILS: Navigating to edit. isGroupPost=$isGroupPost, groupId=$groupId");

                  // Force fetch group topics if needed
                  if (isGroupPost && groupId != null) {
                    try {
                      debugPrint("POST DETAILS: Pre-loading group topics for groupId=$groupId");
                      final groupsController = Get.find<GroupsController>();
                      groupsController.fetchGroupsTopic(groupId);
                    } catch (e) {
                      debugPrint("Error pre-loading group topics: $e");
                    }
                  }

                  // Navigate with explicit parameters
                  context.push('/edit-post', extra: {'post': widget.post});
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Delete Post'),
                          content: Text('Are you sure you want to delete this post?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                controller.deletePost(widget.postId, context).then((_) {
                                  controller.getCommunityPosts();
                                  Navigator.of(context).pop(); // Navigate back after deletion
                                });
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit Post')),
                    PopupMenuItem(value: 'delete', child: Text('Delete Post')),
                  ],
            ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: dark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return PostDetailsShimmer();
        }

        // final post = controller.communityPostsById.value.result;
        final post = widget.post ?? controller.communityPostsById.value.result;

        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: commentsScrollController, // Use the dedicated ScrollController
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return PostDetailsCard(
                          onTap: () {},
                          name: post?.user?.name ?? "",
                          rank: post?.user?.rank?.name ?? "",
                          topic: post?.topic?.name ?? "",
                          postId: int.tryParse(widget.postId),
                          time: HelperUtils.formatTime(post?.createdAt ?? DateTime.now()),
                          postImage: post?.image ?? "",
                          videoUrl: post?.videoUrl ?? "",
                          dp: post?.user?.avatar ?? "",
                          caption: post?.content ?? "",
                          commentCount: post?.commentsCount.toString() ?? "",
                          isLiked: post?.isLiked ?? false,
                          isSaved: post?.isSaved ?? false,
                          onCommentTap: () {
                            _commentFocusNode.requestFocus();
                          },
                          onLike: () {
                            final postId = post?.id ?? 0;
                            if (postId == 0) return;

                            // Update UI optimistically - this is still fine in the view
                            final currentState = widget.post?.isLiked ?? false;
                            if (mounted) {
                              setState(() {
                                post?.isLiked = !currentState;
                              });
                            }
                            controller.communityPostsById.refresh();

                            // Call controller method instead of direct API call
                            controller.likePostAndSyncState(context, postId, currentState);
                          },
                          onSave: () {
                            final postId = post?.id ?? 0;
                            if (postId == 0) return;

                            // Update UI optimistically - this is still fine in the view
                            final currentState = post?.isSaved ?? false;
                            if (mounted) {
                              setState(() {
                                post?.isSaved = !currentState;
                              });
                            }
                            controller.communityPostsById.refresh();

                            // Call controller method instead of direct API call
                            controller.savePostAndSyncState(context, postId, currentState);
                          },
                          onTopicTap: () {
                            if (widget.fromSearchPage) {
                              if (widget.post?.groupId != null) {
                                // Navigate to the group details page
                                final groupController = Get.find<GroupsController>();
                                groupController.isLoading(true);
                                groupController.currentGroupId.value = widget.post?.groupId.toString() ?? '';
                                groupController.selectedTopic.value = post?.topic?.name ?? "";
                                // groupController.currentGroupId.value = widget.groupId ?? '';
                                debugPrint("Here is the group id: ${widget.post?.groupId}");

                                var topicId = post?.topic?.id?.toString();
                                groupController.fetchGroupsTopic(widget.post?.groupId.toString() ?? '');
                                // groupController.fetchGroupPosts(widget.groupId!);
                                // groupController.filterPostsByTopic(post?.topic?.name ?? "", topicId: topicId);

                                groupController.filterPostsByTopic(post?.topic?.name ?? "", topicId: topicId);
                                context.push(AppRoutes.groupDetails);
                              } else {
                                // Navigate to the community feed page
                                controller.selectedTopic.value = post?.topic?.name ?? "";
                                controller.selectedTopicId.value = post?.topic?.id?.toString() ?? "";
                                context.go(AppRoutes.communityFeed);
                              }
                            } else if (widget.post?.groupId != null) {
                              // Navigate to the group details page with the selected topic
                              final groupController = Get.find<GroupsController>();
                              groupController.selectedTopic.value = post?.topic?.name ?? "";
                              groupController.currentGroupId.value = widget.post?.groupId.toString() ?? '';
                              groupController.filterPostsByTopic(
                                post?.topic?.name ?? "",
                                topicId: post?.topic?.id?.toString(),
                              );
                              context.pop();
                            } else {
                              // Navigate to the community feed page with the selected topic
                              controller.selectedTopic.value = post?.topic?.name ?? "";
                              controller.selectedTopicId.value = post?.topic?.id?.toString() ?? "";
                              context.go(AppRoutes.communityFeed);
                            }
                          },
                        );
                      }),
                      Divider(height: 1.h),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Comments",
                          style: GoogleFonts.plusJakartaSans(fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Obx(() {
                        final comments = controller.comments.value.result?.data ?? [];
                        if (controller.commentLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (comments.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                AppStrings.noCommentsFound,
                                style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        }
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return SizedBox(
                          height:
                              controller.comments.value.result?.data?.length != null
                                  ? (controller.comments.value.result?.data?.length)! * 200.h
                                  : 0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Allow smooth scrolling
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return CommentWidget(
                                avatarUrl: comment.user?.avatar ?? '',
                                userName: comment.user?.name ?? '',
                                rank: comment.user?.rank?.name ?? '',
                                time: HelperUtils.formatTime(comment.createdAt ?? DateTime.now()),
                                content: comment.content ?? '',
                                replies: comment.replies ?? [],
                                isLiked: comment.isLiked ?? false,
                                onLikeTap: () {
                                  final commentId = comment.id ?? 0;
                                  if (commentId == 0) return;

                                  final currentState = comment.isLiked ?? false;
                                  comment.isLiked = !currentState;
                                  controller.comments.refresh();
                                  controller.likeCommentsAndSyncState(context, commentId, currentState);
                                },
                                isReplyLiked: comment.replies?.any((reply) => reply.isLiked ?? false) ?? false,
                                onReplyTap: (replyId) {
                                  if (replyId == 0) return;

                                  final currentState =
                                      comment.replies?.firstWhere((reply) => reply.id == replyId).isLiked ?? false;
                                  comment.replies?.firstWhere((reply) => reply.id == replyId).isLiked = !currentState;
                                  controller.comments.refresh();
                                  controller.likeCommentsAndSyncState(context, replyId, currentState);
                                },
                                onDelete: () {
                                  // show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text(AppStrings.deleteComment),
                                          content: Text(AppStrings.deleteCommentConfirmation),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                // Call the delete comment method
                                                controller.selectedPostId.value = post?.id ?? 0;
                                                controller
                                                    .deleteComments(
                                                      comment.id.toString(),
                                                      controller.selectedPostId.value.toString(),
                                                      context,
                                                    )
                                                    .then((_) {
                                                      controller.getComments(
                                                        post?.id.toString() ?? "",
                                                      ); // Refresh comments after deletion
                                                      controller.syncCommentsCountAcrossControllers(
                                                        controller.selectedPostId.value.toString(),
                                                        -1,
                                                      );
                                                    });
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                onReplyDelete: (value) {
                                  debugPrint("here is the reply id: $value");
                                  // show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text(AppStrings.deleteComment),
                                          content: Text(AppStrings.deleteCommentConfirmation),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(AppStrings.cancel),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                controller.selectedPostId.value = post?.id ?? 0;
                                                controller.deleteComments(value, post?.id?.toString() ?? "", context);
                                                controller.getComments(post?.id.toString() ?? "");
                                              },
                                              child: Text(AppStrings.delete),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                onReply: () {
                                  debugPrint("here is the comment id: ${comment.id}");
                                  debugPrint("Here is the parent id: ${comment.parentId}");
                                  if (mounted) {
                                    setState(() {
                                      _isReplying = true;
                                      _replyingTo = comment.id!; // Set the parent comment ID
                                    });
                                  }
                                  Future.delayed(Duration(milliseconds: 100), () => _commentFocusNode.requestFocus());
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: dark ? AppColors.dark : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundImage: NetworkImage(
                          Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? '',
                        ),
                      ),
                      10.wS,
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              controller: _commentController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 3,
                              focusNode: _commentFocusNode,
                              decoration: InputDecoration(
                                fillColor: dark ? AppColors.dark : Colors.white,
                                filled: true,
                                hintText:
                                    _isReplying
                                        ? 'Replying to ${controller.comments.value.result?.data?.firstWhere((element) => element.id == _replyingTo).user?.name ?? ''}'
                                        : 'Add comment',
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: AppColors.borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: AppColors.borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: AppColors.borderColor),
                                ),
                              ),
                            ),
                            if (_isReplying)
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isReplying = false;
                                      _replyingTo = null;
                                      _commentController.clear();
                                      _commentFocusNode.unfocus();
                                    });
                                  },
                                  child: Icon(Icons.close, size: 20.sp, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),

                      10.wS,
                      IconButton(
                        onPressed: () {
                          debugPrint("here is the _replyto: $_replyingTo");
                          debugPrint("Parent id is ${_replyingTo?.toString()}");
                          controller.selectedPostId.value = post?.id ?? 0;
                          // if (_commentController.text.trim().isEmpty) {
                          //   Ui.showErrorSnackBar(context, message: "Please enter a comment");
                          //   return;
                          // }
                          controller.addComments(
                            context: context,
                            postId: controller.selectedPostId.value.toString(),
                            comments: _commentController.text.trim(),
                            parentId:
                                (_isReplying && _replyingTo != null)
                                    ? _replyingTo.toString()
                                    : "", // Pass parentId for replies
                          );
                          _commentController.clear();
                          setState(() {
                            _isReplying = false;
                            _replyingTo = null; // Reset the parent comment ID after adding the reply
                          });
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/share.svg",
                          height: 24.h,
                          color: dark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
