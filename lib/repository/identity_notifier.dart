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
import 'package:shared_preferences/shared_preferences.dart';

class IdentityNotifier extends StateNotifier<Map<String, String>> {
  IdentityNotifier()
      : super({
          'name': '',
          'email': '',
        });

  Future<void> getIdentity() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String _name = _prefs.getString('identity_name');
    final String _email = _prefs.getString('identity_email');

    state = {
      'name': _name ?? '',
      'email': _email ?? '',
    };
  }

  Future<void> setIdentity(Map<String, String> identity) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('identity_name', identity['name']);
    _prefs.setString('identity_email', identity['email']);

    state = {
      'name': identity['name'],
      'email': identity['email'],
    };
  }
}
