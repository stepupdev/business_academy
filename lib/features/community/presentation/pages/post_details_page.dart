// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/config/app_routes.dart';
import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/services/auth_services.dart';
import 'package:stepup_community/core/utils/app_strings.dart';
import 'package:stepup_community/core/utils/helper_utils.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/data/posts/posts_models.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/community/presentation/widgets/comment_widget.dart';
import 'package:stepup_community/features/community/presentation/widgets/post_details_card.dart';
import 'package:stepup_community/features/community/presentation/widgets/post_details_shimmer.dart';
import 'package:stepup_community/features/groups/controller/groups_controller.dart';

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
      backgroundColor: dark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor.withValues(alpha: 0.9), const Color(0xFF003BC6).withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        title: Text(
          widget.post?.groupId != null ? 'Group Post' : 'Post Details',
          style: GoogleFonts.poppins(
            color: TColors.textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 16.sp),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (widget.post?.user?.id == currentUserId)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white, size: 18.sp),
              color: dark ? const Color(0xFF1A1A1A) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                if (value == 'edit') {
                  final isGroupPost = true;
                  final groupId = widget.post?.groupId.toString();

                  debugPrint("POST DETAILS: Navigating to edit. isGroupPost=$isGroupPost, groupId=$groupId");

                  if (isGroupPost && groupId != null) {
                    try {
                      debugPrint("POST DETAILS: Pre-loading group topics for groupId=$groupId");
                      final groupsController = Get.find<GroupsController>();
                      groupsController.fetchGroupsTopic(groupId);
                    } catch (e) {
                      debugPrint("Error pre-loading group topics: $e");
                    }
                  }

                  context.push('/edit-post', extra: {'post': widget.post});
                } else if (value == 'delete') {
                  _showDeleteDialog(context, controller);
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18.sp, color: AppColors.primaryColor),
                          8.wS,
                          Text('Edit Post', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18.sp, color: Colors.red),
                          8.wS,
                          Text('Delete Post', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return PostDetailsShimmer();
        }

        final post = widget.post ?? controller.communityPostsById.value.result;

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: commentsScrollController,
                  slivers: [
                    // Post Details Card
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 4.h),
                        decoration: BoxDecoration(
                          color: dark ? const Color(0xFF1A1A1A) : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: dark ? Colors.black12 : Colors.grey.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: PostDetailsCard(
                          onTap: () {
                            if (post?.image != null) {
                              context.push(AppRoutes.fullImageView, extra: post?.image);
                            }
                          },
                          name: post?.user?.name ?? "",
                          rank: post?.user?.rank?.name ?? "",
                          topic: post?.topic?.name ?? "",
                          postId: int.tryParse(widget.postId),
                          time: HelperUtils.formatTime(post?.createdAt ?? DateTime.now()),
                          postImage: post?.image ?? "",
                          videoUrl: post?.videoUrl ?? "",
                          dp: post?.user?.avatar ?? "",
                          caption: post?.content ?? "",
                          likesCount: post?.likesCount?.toString() ?? '0',
                          commentCount: ((controller.comments.value.result?.data?.length)).toString(),
                          isLiked: post?.isLiked ?? false,
                          isSaved: post?.isSaved ?? false,
                          onCommentTap: () {
                            _commentFocusNode.requestFocus();
                          },
                          onLike: () {
                            final postId = post?.id ?? 0;
                            if (postId == 0) return;

                            final currentState = widget.post?.isLiked ?? false;
                            if (mounted) {
                              setState(() {
                                post?.isLiked = !currentState;
                              });
                            }
                            controller.communityPostsById.refresh();
                            if (post?.likesCount != null) {
                              post?.likesCount = currentState ? (post.likesCount ?? 0) - 1 : (post.likesCount ?? 0) + 1;
                            }
                            controller.likePostAndSyncState(context, postId, currentState);
                          },
                          onSave: () {
                            final postId = post?.id ?? 0;
                            if (postId == 0) return;

                            final currentState = post?.isSaved ?? false;
                            if (mounted) {
                              setState(() {
                                post?.isSaved = !currentState;
                              });
                            }
                            controller.communityPostsById.refresh();

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
                        ),
                      ),
                    ),

                    // Comments Section Header
                    SliverToBoxAdapter(
                      child: Container(
                        color: dark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        child: Row(
                          children: [
                            Icon(Icons.comment_outlined, color: AppColors.primaryColor, size: 20.sp),
                            8.wS,
                            Text(
                              "Comments",
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: dark ? Colors.white : Colors.grey.shade800,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${controller.comments.value.result?.data?.length ?? 0}",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Comments List
                    Obx(() {
                      final comments = controller.comments.value.result?.data ?? [];
                      if (controller.commentLoading.value) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 200.h,
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 3),
                            ),
                          ),
                        );
                      }
                      if (comments.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 300.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.chat_bubble_outline, size: 32.sp, color: AppColors.primaryColor),
                                ),
                                16.hS,
                                Text(
                                  "No Comments Yet",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: dark ? Colors.white : Colors.grey.shade800,
                                  ),
                                ),
                                6.hS,
                                Text(
                                  "Be the first to share your thoughts!",
                                  style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final comment = comments[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 1.h),
                            decoration: BoxDecoration(
                              color: dark ? const Color(0xFF1A1A1A) : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: dark ? Colors.black12 : Colors.grey.withValues(alpha: 0.04),
                                  blurRadius: 2,
                                  offset: const Offset(0, 0.5),
                                ),
                              ],
                            ),
                            child: CommentWidget(
                              avatarUrl: comment.user?.avatar ?? '',
                              userName: comment.user?.name ?? '',
                              rank: comment.user?.rank?.name ?? '',
                              time: HelperUtils.formatTime(comment.createdAt ?? DateTime.now()),
                              content: comment.content ?? '',
                              replies: comment.replies ?? [],
                              isLiked: comment.isLiked ?? false,
                              likesCount: comment.likesCount?.toString() ?? '0',
                              onLikeTap: () {
                                final commentId = comment.id ?? 0;
                                if (commentId == 0) return;

                                final currentState = comment.isLiked ?? false;
                                comment.isLiked = !currentState;
                                controller.comments.refresh();
                                if (!currentState) {
                                  comment.likesCount = (comment.likesCount ?? 0) + 1;
                                } else {
                                  comment.likesCount = (comment.likesCount ?? 0) - 1;
                                }
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
                              onDelete: () => _showDeleteCommentDialog(context, controller, comment, post),
                              onReplyDelete: (value) => _showDeleteReplyDialog(context, controller, value, post),
                              onReply: () {
                                debugPrint("here is the comment id: ${comment.id}");
                                debugPrint("Here is the parent id: ${comment.parentId}");
                                if (mounted) {
                                  setState(() {
                                    _isReplying = true;
                                    _replyingTo = comment.id!;
                                  });
                                }
                                Future.delayed(Duration(milliseconds: 100), () => _commentFocusNode.requestFocus());
                              },
                            ),
                          );
                        }, childCount: comments.length),
                      );
                    }),
                  ],
                ),
              ),

              // Comment Input Section
              Container(
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF1A1A1A) : Colors.white,
                  border: Border(
                    top: BorderSide(color: dark ? Colors.grey.shade800 : Colors.grey.shade200, width: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: dark ? Colors.black26 : Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                child: SafeArea(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage: NetworkImage(
                            Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? '',
                          ),
                        ),
                      ),
                      12.wS,
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: dark ? Colors.grey.shade700 : Colors.grey.shade200, width: 1),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                  controller: _commentController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 4,
                                  focusNode: _commentFocusNode,
                                  style: GoogleFonts.inter(fontSize: 14.sp, color: dark ? Colors.white : Colors.black),
                                  decoration: InputDecoration(
                                    hintText:
                                        _isReplying
                                            ? 'Replying to ${controller.comments.value.result?.data?.firstWhere((element) => element.id == _replyingTo).user?.name ?? ''}'
                                            : 'Add a comment...',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13.sp),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              if (_isReplying)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isReplying = false;
                                      _replyingTo = null;
                                      _commentController.clear();
                                      _commentFocusNode.unfocus();
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8.w),
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, size: 16.sp, color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      12.wS,
                      GestureDetector(
                        onTap: () {
                          debugPrint("here is the _replyto: $_replyingTo");
                          debugPrint("Parent id is ${_replyingTo?.toString()}");
                          controller.selectedPostId.value = post?.id ?? 0;

                          controller.addComments(
                            context: context,
                            postId: controller.selectedPostId.value.toString(),
                            comments: _commentController.text.trim(),
                            parentId: (_isReplying && _replyingTo != null) ? _replyingTo.toString() : "",
                          );
                          _commentController.clear();
                          setState(() {
                            _isReplying = false;
                            _replyingTo = null;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primaryColor, const Color(0xFF003BC6)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.send_rounded, color: Colors.white, size: 18.sp),
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

  void _showDeleteDialog(BuildContext context, CommunityController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Delete Post', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Text(
              'Are you sure you want to delete this post? This action cannot be undone.',
              style: GoogleFonts.inter(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  controller.deletePost(widget.postId, context).then((_) {
                    controller.getCommunityPosts();
                    Navigator.of(context).pop();
                    context.pop();
                  });
                },
                child: Text('Delete', style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
    );
  }

  void _showDeleteCommentDialog(BuildContext context, CommunityController controller, comment, post) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(AppStrings.deleteComment, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Text(AppStrings.deleteCommentConfirmation, style: GoogleFonts.inter()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.selectedPostId.value = post?.id ?? 0;
                  controller
                      .deleteComments(comment.id.toString(), controller.selectedPostId.value.toString(), context)
                      .then((_) {
                        controller.getComments(post?.id.toString() ?? "");
                        controller.syncCommentsCountAcrossControllers(controller.selectedPostId.value.toString(), -1);
                      });
                },
                child: Text('Delete', style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
    );
  }

  void _showDeleteReplyDialog(BuildContext context, CommunityController controller, String replyId, post) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(AppStrings.deleteComment, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Text(AppStrings.deleteCommentConfirmation, style: GoogleFonts.inter()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel, style: GoogleFonts.inter(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.selectedPostId.value = post?.id ?? 0;
                  controller.deleteComments(replyId, post?.id?.toString() ?? "", context);
                  controller.getComments(post?.id.toString() ?? "");
                },
                child: Text(
                  AppStrings.delete,
                  style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );
  }
}
