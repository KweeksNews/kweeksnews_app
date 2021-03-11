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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/comment.dart';
import '../providers.dart';
import '../utils/network/wordpress_apis.dart';
import '../widgets/comment_box.dart';
import '../widgets/error_indicator.dart';
import '../widgets/identity_settings.dart';
import '../widgets/loading_indicator.dart';

class Comments extends StatefulWidget {
  final int postId;

  const Comments({
    @required this.postId,
    Key key,
  }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final PagingController _pagingController = PagingController<int, Comment>(
    firstPageKey: 1,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FToast _flutterToast = FToast();
  bool _forceRefresh = false;
  String _name;
  String _email;
  String _comment;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey as int);
    });
    _flutterToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final Map raw = await WpApi.getComments(
        request: {
          'post': '${widget.postId}',
          'page': '$pageKey',
          'per_page': '5',
          'order': 'desc',
          'orderby': 'date',
          '_fields': 'id,author_name,author_avatar_urls,date,content',
        },
        forceRefresh: _forceRefresh,
      );
      final int totalPosts =
          int.parse(raw['headers'].value('x-wp-total') as String);
      final List<Comment> comments = List<Comment>.from(
          raw['body'].map((m) => Comment.fromJson(m as Map)) as Iterable);
      final int fetched = _pagingController.itemList?.length ?? 0;

      if (_forceRefresh) {
        _forceRefresh = false;
      }

      if (fetched + comments.length == totalPosts) {
        _pagingController.appendLastPage(comments);
      } else {
        final int nextPageKey = pageKey + 1;
        _pagingController.appendPage(comments, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _sendComment() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();

      if (_name.isEmpty && _email.isEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return const IdentitySettingsDialog();
          },
        );
      }

      _flutterToast.showToast(
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            color: Theme.of(context).buttonColor,
          ),
          child: Text(
            'Mengirim komentar...',
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  color: Theme.of(context).iconTheme.color,
                ),
          ),
        ),
      );

      try {
        final Map result = await WpApi.postComment(
          request: {
            'post': widget.postId,
            'author_email': _email,
            'author_name': _name,
            'content': _comment,
          },
        );

        if (result['status'] == 201) {
          _pagingController.refresh();
          _formKey.currentState.reset();
          _flutterToast.showToast(
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                color: Theme.of(context).buttonColor,
              ),
              child: Text(
                'Komentar terkirim!',
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Theme.of(context).iconTheme.color,
                    ),
              ),
            ),
          );
        }
      } catch (error) {
        _flutterToast.showToast(
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
              color: Theme.of(context).buttonColor,
            ),
            child: Text(
              'Gagal mengirim komentar!',
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    color: Theme.of(context).iconTheme.color,
                  ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Komentar',
            style: Theme.of(context).primaryTextTheme.headline1,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            children: [
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
                          message: 'Belum ada komentar.\nJadilah yang pertama!',
                          image: 'assets/no_data.png',
                        );
                      },
                      firstPageProgressIndicatorBuilder: (context) {
                        return const LoadingIndicator(
                          count: 5,
                          type: 'comment',
                        );
                      },
                      itemBuilder: (context, comment, index) {
                        return CommentBox(comment: comment as Comment);
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
                          type: 'comment',
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
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Center(
                  child: Consumer(
                    builder: (context, watch, child) {
                      final Map<String, String> identity =
                          watch(identityProvider.state);
                      _name = identity['name'];
                      _email = identity['email'];

                      return Text(
                        _name.isNotEmpty && _email.isNotEmpty
                            ? 'Kirim komentar sebagai\n$_name ($_email)'
                            : 'Kamu belum mengatur identitas!',
                        style: Theme.of(context).primaryTextTheme.headline6,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 55,
                            maxHeight: 55,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).cardTheme.shadowColor,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            style: Theme.of(context).primaryTextTheme.headline4,
                            decoration: InputDecoration(
                              hintText: 'Tulis komentar',
                              hintStyle:
                                  Theme.of(context).primaryTextTheme.headline4,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              filled: true,
                              fillColor: Theme.of(context).cardTheme.color,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Tulis komentar!';
                              } else if (value.length > 300) {
                                return 'Batas komentar adalah 300 karakter!';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (String value) {
                              _comment = value;
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).cardTheme.shadowColor,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Material(
                            color: Theme.of(context).accentColor,
                            child: InkWell(
                              splashColor:
                                  Theme.of(context).cardTheme.shadowColor,
                              onTap: () => _sendComment(),
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidPaperPlane,
                                    size: 20,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
