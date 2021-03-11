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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/post.dart';
import '../utils/network/wordpress_apis.dart';
import '../widgets/error_indicator.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/post_box.dart';
import 'single_post.dart';

class Search extends StatefulWidget {
  const Search();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textFieldController = TextEditingController();
  final PagingController _pagingController = PagingController<int, Post>(
    firstPageKey: 1,
  );
  bool _forceRefresh = false;
  String _searchTerm;
  Timer _timeHandle;

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
    _textFieldController.dispose();
    _pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_searchTerm?.isEmpty ?? true) {
        _pagingController.error = 'No keyword';
      } else {
        final Map raw = await WpApi.getPosts(
          request: {
            'search': _searchTerm,
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
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _updateSearchTerm(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Cari',
          style: Theme.of(context).primaryTextTheme.headline1,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).cardTheme.shadowColor,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: TextField(
                      controller: _textFieldController,
                      style: Theme.of(context).primaryTextTheme.headline4,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Cari',
                        hintStyle: Theme.of(context).primaryTextTheme.headline4,
                        suffixIcon: _searchTerm?.isEmpty ?? true
                            ? Icon(
                                Icons.search_rounded,
                                color: Theme.of(context).primaryColor,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  _textFieldController.clear();
                                  _updateSearchTerm('');
                                  _pagingController.refresh();
                                },
                              ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (text) {
                        _updateSearchTerm(text);
                        if (_timeHandle != null) {
                          _timeHandle.cancel();
                        }
                        _timeHandle = Timer(
                          const Duration(milliseconds: 1000),
                          () {
                            _pagingController.refresh();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
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
                        message: 'Tidak ada hasil.\nCoba kata kunci lain.',
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
                      final String heroId =
                          '${Random().nextInt(100)}-${post.id}';

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
                      if (_pagingController.error == 'No keyword') {
                        return const ErrorIndicator(
                          message:
                              'Masukkan kata kunci dan mulailah menjelajah!',
                          image: 'assets/search.png',
                        );
                      } else {
                        return ErrorIndicator(
                          message: 'Gagal memuat data.',
                          image: 'assets/error.png',
                          onTryAgain: () {
                            _pagingController.refresh();
                          },
                        );
                      }
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
            ),
          ],
        ),
      ),
    );
  }
}
