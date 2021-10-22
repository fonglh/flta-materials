import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';

class FriendPostTile extends StatelessWidget {
  final Post post;

  const FriendPostTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No height restriction, so the text might expand to be many lines long.
    // iOS's dynamic table views, or autosizing TextViews on Android
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleImage(
          imageProvider: AssetImage(
            post.profileImageUrl,
          ),
          imageRadius: 20,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          // Expanded widget children fill the rest of the container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.comment),
              Text('${post.timestamp} mins ago',
                  style: const TextStyle(fontWeight: FontWeight.w700))
            ],
          ),
        )
      ],
    );
  }
}
