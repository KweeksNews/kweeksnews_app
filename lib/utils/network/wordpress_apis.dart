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

import '../../common/config.dart';
import 'network_utils.dart';

class WpApi extends NetworkUtils {
  static final Uri _apiUrl = Uri(
    scheme: 'https',
    host: siteHostName,
    path: 'wp-json/',
  );

  const WpApi();

  Future<Map> getPosts({
    @required Map<String, String> request,
    bool forceRefresh,
  }) async {
    try {
      final Uri payload = Uri.parse(Uri.decodeFull(Uri(
        path: 'wp/v2/posts',
        queryParameters: request,
      ).toString()));
      return handleResponse(
        await getRequest(
          apiUrl: _apiUrl,
          endPoint: payload,
          forceRefresh: forceRefresh,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> getComments({
    @required Map<String, String> request,
    bool forceRefresh,
  }) async {
    try {
      final Uri payload = Uri.parse(Uri.decodeFull(Uri(
        path: 'wp/v2/comments',
        queryParameters: request,
      ).toString()));
      return handleResponse(
        await getRequest(
          apiUrl: _apiUrl,
          endPoint: payload,
          forceRefresh: forceRefresh,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> postComment({@required Map request}) async {
    try {
      final Uri path = Uri(path: 'wp/v2/comments');
      return handleResponse(
        await postRequest(
          apiUrl: _apiUrl,
          endPoint: path,
          request: request,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }
}
