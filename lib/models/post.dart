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

import 'package:intl/intl.dart';

import '../utils/database/database_utils.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String image;
  final String video;
  final String author;
  final String avatar;
  final String category;
  final String date;
  final String link;
  final int catId;

  const Post({
    this.id,
    this.title,
    this.content,
    this.image,
    this.video,
    this.author,
    this.avatar,
    this.category,
    this.date,
    this.link,
    this.catId,
  });

  factory Post.fromJson(Map<dynamic, dynamic> json) {
    final int id = json['id'] as int;
    final String title = json['title']['rendered'] as String;
    final String content =
        json['content'] != null ? json['content']['rendered'] as String : '';
    final String image = json['custom']['featured_image'] != ''
        ? json['custom']['featured_image'] as String
        : 'https://kweeksnews.com/wp-content/uploads/2021/01/placeholder.png';
    final String video = json['custom']['td_video'] as String;
    final String author = json['custom']['author']['name'] as String;
    final String avatar = json['custom']['author']['avatar'] as String;
    final String category = json['custom']['categories'] != ''
        ? json['custom']['categories'][0]['name'] as String
        : '';
    final int catId = json['custom']['categories'] != ''
        ? json['custom']['categories'][0]['cat_ID'] as int
        : 0;
    final String date = DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
        .format(DateTime.parse(json['date'] as String))
        .toString();
    final String link = json['link'] as String;

    return Post(
      id: id,
      title: title,
      content: content,
      image: image,
      video: video,
      author: author,
      avatar: avatar,
      category: category,
      date: date,
      link: link,
      catId: catId,
    );
  }

  factory Post.fromDatabaseJson(SavedPost data) {
    return Post(
      id: data.id,
      title: data.title,
      content: data.content,
      image: data.image,
      video: data.video != '' ? data.video : '',
      author: data.author,
      avatar: data.avatar,
      category: data.category,
      date: data.date,
      link: data.link,
      catId: data.catId,
    );
  }

  SavedPost toDatabaseJson() {
    return SavedPost(
      id: id,
      title: title,
      content: content,
      image: image,
      video: video,
      author: author,
      avatar: avatar,
      category: category,
      date: date,
      link: link,
      catId: catId,
    );
  }
}
