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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../common/config.dart';
import '../models/post.dart';
import '../utils/network/wordpress_apis.dart';
import '../widgets/error_indicator.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/post_box.dart';
import 'single_post.dart';

class Content extends StatelessWidget {
  const Content();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCategories.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Image(
            image: AssetImage(
              Theme.of(context).canvasColor == const Color(0xFF000000)
                  ? 'assets/dark/icon.png'
                  : 'assets/light/icon.png',
            ),
            width: 170,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor:
                    Theme.of(context).tabBarTheme.unselectedLabelColor,
                labelColor: Theme.of(context).tabBarTheme.labelColor,
                indicator: Theme.of(context).tabBarTheme.indicator,
                tabs: List.generate(tabCategories.length, (index) {
                  final List cat = tabCategories[index] as List;
                  final String name = cat[0] as String;

                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height:
                            Theme.of(context).primaryTextTheme.headline3.height,
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .fontSize,
                        fontWeight: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .fontWeight,
                        fontFamily: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .fontFamily,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: List.generate(tabCategories.length, (index) {
            final List cat = tabCategories[index] as List;
            final int catId = cat[1] as int;

            return ContentTab(
              category: catId,
            );
          }),
        ),
      ),
    );
  }
}

class ContentTab extends StatefulWidget {
  final int category;

  const ContentTab({
    @required this.category,
    Key key,
  }) : super(key: key);

  @override
  _ContentTabState createState() => _ContentTabState();
}

class _ContentTabState extends State<ContentTab> {
  final PagingController _pagingController = PagingController<int, Post>(
    firstPageKey: 1,
  );
  bool _forceRefresh = false;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey as int);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final Map raw = await WpApi.getPosts(
        request: {
          'categories': widget.category == 0 ? '' : '${widget.category}',
          'categories_exclude': '1084',
          'page': '$pageKey',
          'per_page': '10',
          '_fields': 'id,date,title,content,custom,link',
        },
        forceRefresh: _forceRefresh,
      );
      final int totalPosts =
          int.parse(raw['headers'].value('x-wp-total') as String);
      final List<Post> posts = List<Post>.from(
          raw['body'].map((m) => Post.fromJson(m as Map)) as Iterable);
      final int fetched = _pagingController.itemList?.length ?? 0;

      if (_forceRefresh) {
        _forceRefresh = false;
      }

      if (fetched + posts.length == totalPosts) {
        _pagingController.appendLastPage(posts);
      } else {
        final int nextPageKey = pageKey + 1;
        _pagingController.appendPage(posts, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
      ),
      child: RefreshIndicator(
        onRefresh: () {
          _forceRefresh = true;

          return Future.sync(
            () => _pagingController.refresh(),
          );
        },
        child: PagedListView(
          pagingController: _pagingController,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          builderDelegate: PagedChildBuilderDelegate(
            noItemsFoundIndicatorBuilder: (context) {
              return const ErrorIndicator(
                message: 'Belum ada kiriman.',
                image: 'assets/no_data.png',
              );
            },
            firstPageProgressIndicatorBuilder: (context) {
              return const LoadingIndicator(
                count: 5,
                type: 'post',
              );
            },
            itemBuilder: (context, post, index) {
              final String heroId = '${Random().nextInt(100)}-${post.id}';

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SinglePost(
                        post: post as Post,
                        heroId: heroId,
                      ),
                    ),
                  );
                },
                child: PostBox(
                  post: post as Post,
                  heroId: heroId,
                ),
              );
            },
            firstPageErrorIndicatorBuilder: (context) {
              return ErrorIndicator(
                message: 'Gagal memuat data.',
                image: 'assets/error.png',
                onTryAgain: () {
                  _pagingController.refresh();
                },
              );
            },
            newPageProgressIndicatorBuilder: (context) {
              return const LoadingIndicator(
                count: 3,
                type: 'post',
              );
            },
            newPageErrorIndicatorBuilder: (context) {
              return ErrorIndicator(
                message: 'Gagal memuat data.',
                image: 'assets/error.png',
                onTryAgain: () {
                  _pagingController.retryLastFailedRequest();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
