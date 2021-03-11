/* 
 * Copyright (C) 2021  Ahmad Rulim
 * 
 * This file is part of Flutter WordPress.
 * 
 * Flutter WordPress is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Flutter WordPress is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Flutter WordPress.  If not, see <https://www.gnu.org/licenses/>.
 * 
 * @license GPL-3.0-or-later <https://spdx.org/licenses/GPL-3.0-or-later.html>
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../utils/network/wordpress_apis.dart';

abstract class RelatedPostsState {
  const RelatedPostsState();
}

class RelatedPostsLoading extends RelatedPostsState {
  const RelatedPostsLoading();
}

class RelatedPostsLoaded extends RelatedPostsState {
  final List<Post> posts;

  const RelatedPostsLoaded(
    this.posts,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RelatedPostsLoaded && o.posts == posts;
  }

  @override
  int get hashCode => posts.hashCode;
}

class RelatedPostsError extends RelatedPostsState {
  const RelatedPostsError();
}

class RelatedPostsNotifier extends StateNotifier<RelatedPostsState> {
  RelatedPostsNotifier() : super(const RelatedPostsLoading());

  Future<void> getPosts(int postId, int catId) async {
    try {
      state = const RelatedPostsLoading();
      const WpApi _wpApi = WpApi();
      final Map<String, String> request = {
        'exclude': '$postId',
        'categories': '$catId',
        'page': '1',
        'per_page': '3',
        '_fields': 'id,date,title,content,custom,link',
      };
      final Map raw = await _wpApi.getPosts(request: request);
      final List<Post> posts = List<Post>.from(
          raw['body'].map((m) => Post.fromJson(m as Map)) as Iterable);
      state = RelatedPostsLoaded(posts);
    } catch (error) {
      state = const RelatedPostsError();
    }
  }
}
