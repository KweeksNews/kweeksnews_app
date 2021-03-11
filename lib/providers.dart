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

import 'repository/identity_notifier.dart';
import 'repository/related_posts_notifier.dart';
import 'repository/theme_notifier.dart';
import 'utils/database/database_utils.dart';

final themeStateProvider = StateNotifierProvider<ThemeNotifier>(
  (ref) => ThemeNotifier(),
);

final identityProvider = StateNotifierProvider<IdentityNotifier>(
  (ref) => IdentityNotifier(),
);

final savedPostsDaoProvider = Provider<SavedPostsDao>(
  (ref) => AppDatabase().savedPostsDao,
);

final relatedPostsProvider =
    StateNotifierProvider.autoDispose<RelatedPostsNotifier>(
  (ref) => RelatedPostsNotifier(),
);
