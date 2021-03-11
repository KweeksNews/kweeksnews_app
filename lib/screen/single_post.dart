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
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/post.dart';
import '../providers.dart';
import '../repository/related_posts_notifier.dart';
import '../utils/database/database_utils.dart';
import '../widgets/error_indicator.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/post_box.dart';
import 'comments.dart';

class SinglePost extends StatefulWidget {
  final Post post;
  final String heroId;

  const SinglePost({
    @required this.post,
    @required this.heroId,
    Key key,
  }) : super(key: key);

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  YoutubePlayerController _playerController;

  String get _postTitle {
    return HtmlUnescape().convert(widget.post.title);
  }

  @override
  void initState() {
    super.initState();
    context.read(relatedPostsProvider).getPosts(
          widget.post.id,
          widget.post.catId,
        );
    if (widget.post.video != '') {
      _playerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.post.video),
        flags: const YoutubePlayerFlags(
          loop: true,
        ),
      );
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    if (widget.post.video != '') {
      _playerController.pause();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.post.video != '') {
      _playerController.dispose();
    }
  }

  Widget buildPostScreen({
    @required BuildContext context,
    Widget player,
  }) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
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
                      color: Theme.of(context).buttonColor,
                      child: InkWell(
                        splashColor: Theme.of(context).cardTheme.shadowColor,
                        onTap: () => Navigator.of(context).pop(),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).cardTheme.shadowColor,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Consumer(
                        builder: (context, watch, child) {
                          final SavedPostsDao savedPostsDao =
                              watch(savedPostsDaoProvider);

                          return StreamBuilder(
                            stream:
                                savedPostsDao.isSavedPost(id: widget.post.id),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == true) {
                                return ClipOval(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Theme.of(context)
                                          .cardTheme
                                          .shadowColor,
                                      onTap: () =>
                                          savedPostsDao.deleteSavedPost(
                                        id: widget.post.id,
                                      ),
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: Icon(
                                            Icons.bookmark_rounded,
                                            size: 20,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ClipOval(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Theme.of(context)
                                          .cardTheme
                                          .shadowColor,
                                      onTap: () =>
                                          savedPostsDao.createSavedPost(
                                        post: widget.post,
                                      ),
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: Icon(
                                            Icons.bookmark_border_rounded,
                                            size: 20,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor:
                                Theme.of(context).cardTheme.shadowColor,
                            onTap: () => Share.share(
                              '$_postTitle\n${widget.post.link}',
                            ),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  Icons.share_rounded,
                                  size: 20,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).cardTheme.shadowColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Comments(postId: widget.post.id),
                fullscreenDialog: true,
              ),
            );
          },
          child: Icon(
            Icons.chat_bubble_rounded,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).cardTheme.shadowColor,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: widget.heroId,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: widget.post.video != ''
                          ? player
                          : FadeInImage(
                              placeholder:
                                  const AssetImage('assets/placeholder.png'),
                              image: NetworkImage(widget.post.image),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          _postTitle,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          widget.post.category,
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(widget.post.avatar),
                        ),
                        title: Text(
                          widget.post.author,
                          style: Theme.of(context).primaryTextTheme.subtitle2,
                        ),
                        subtitle: Text(
                          widget.post.date,
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                        ),
                      ),
                      Html(
                        data: widget.post.content,
                        onLinkTap: (url) async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw "Couldn't launch $url";
                          }
                        },
                        style: {
                          '*': Style(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                          ),
                          'h2': Style.fromTextStyle(
                            Theme.of(context).textTheme.headline2,
                          ),
                          'h3': Style.fromTextStyle(
                            Theme.of(context).textTheme.headline3,
                          ),
                          'h4': Style.fromTextStyle(
                            Theme.of(context).textTheme.headline4,
                          ),
                          'h5': Style.fromTextStyle(
                            Theme.of(context).textTheme.headline5,
                          ),
                          'h6': Style.fromTextStyle(
                            Theme.of(context).textTheme.headline6,
                          ),
                          'p': Style.fromTextStyle(
                            Theme.of(context).textTheme.bodyText1,
                          ),
                          'pre': Style.fromTextStyle(
                            Theme.of(context).textTheme.bodyText2,
                          ),
                          '.blocks-gallery-item': Style(
                            display: Display.BLOCK,
                          ),
                          '.has-text-align-right': Style(
                            direction: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            fontSize: FontSize.percent(150),
                            fontFamily: 'Amiri',
                            lineHeight: 2,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          'Kiriman Terkait',
                          style: Theme.of(context).primaryTextTheme.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Consumer(
                        builder: (context, watch, child) {
                          final RelatedPostsState state =
                              watch(relatedPostsProvider.state);

                          if (state is RelatedPostsLoading) {
                            return const LoadingIndicator(
                              count: 3,
                              type: 'post',
                            );
                          } else if (state is RelatedPostsLoaded) {
                            return Column(
                              children:
                                  List.generate(state.posts.length, (index) {
                                final String heroId =
                                    '${Random().nextInt(100)}-${state.posts[index].id}';

                                return InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SinglePost(
                                          post: state.posts[index],
                                          heroId: heroId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: PostBox(
                                    post: state.posts[index],
                                    heroId: heroId,
                                  ),
                                );
                              }),
                            );
                          } else {
                            return ErrorIndicator(
                              message: 'Gagal memuat data.',
                              image: 'assets/error.png',
                              onTryAgain: () {
                                context.read(relatedPostsProvider).getPosts(
                                      widget.post.id,
                                      widget.post.catId,
                                    );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.video != '') {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _playerController,
        ),
        builder: (context, player) => buildPostScreen(
          context: context,
          player: player,
        ),
      );
    } else {
      return buildPostScreen(
        context: context,
      );
    }
  }
}
