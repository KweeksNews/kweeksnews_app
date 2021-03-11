// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_utils.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class SavedPost extends DataClass implements Insertable<SavedPost> {
  final int id;
  final int catId;
  final String category;
  final String date;
  final String link;
  final String title;
  final String content;
  final String image;
  final String video;
  final String author;
  final String avatar;
  SavedPost(
      {@required this.id,
      @required this.catId,
      @required this.category,
      @required this.date,
      @required this.link,
      @required this.title,
      @required this.content,
      @required this.image,
      this.video,
      @required this.author,
      @required this.avatar});
  factory SavedPost.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return SavedPost(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      catId: intType.mapFromDatabaseResponse(data['${effectivePrefix}cat_id']),
      category: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
      date: stringType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      link: stringType.mapFromDatabaseResponse(data['${effectivePrefix}link']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      image:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}image']),
      video:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}video']),
      author:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}author']),
      avatar:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}avatar']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || catId != null) {
      map['cat_id'] = Variable<int>(catId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || video != null) {
      map['video'] = Variable<String>(video);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    return map;
  }

  SavedPostsCompanion toCompanion(bool nullToAbsent) {
    return SavedPostsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      catId:
          catId == null && nullToAbsent ? const Value.absent() : Value(catId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      video:
          video == null && nullToAbsent ? const Value.absent() : Value(video),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
    );
  }

  factory SavedPost.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SavedPost(
      id: serializer.fromJson<int>(json['id']),
      catId: serializer.fromJson<int>(json['catId']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<String>(json['date']),
      link: serializer.fromJson<String>(json['link']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      image: serializer.fromJson<String>(json['image']),
      video: serializer.fromJson<String>(json['video']),
      author: serializer.fromJson<String>(json['author']),
      avatar: serializer.fromJson<String>(json['avatar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catId': serializer.toJson<int>(catId),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<String>(date),
      'link': serializer.toJson<String>(link),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'image': serializer.toJson<String>(image),
      'video': serializer.toJson<String>(video),
      'author': serializer.toJson<String>(author),
      'avatar': serializer.toJson<String>(avatar),
    };
  }

  SavedPost copyWith(
          {int id,
          int catId,
          String category,
          String date,
          String link,
          String title,
          String content,
          String image,
          String video,
          String author,
          String avatar}) =>
      SavedPost(
        id: id ?? this.id,
        catId: catId ?? this.catId,
        category: category ?? this.category,
        date: date ?? this.date,
        link: link ?? this.link,
        title: title ?? this.title,
        content: content ?? this.content,
        image: image ?? this.image,
        video: video ?? this.video,
        author: author ?? this.author,
        avatar: avatar ?? this.avatar,
      );
  @override
  String toString() {
    return (StringBuffer('SavedPost(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('link: $link, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('video: $video, ')
          ..write('author: $author, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          catId.hashCode,
          $mrjc(
              category.hashCode,
              $mrjc(
                  date.hashCode,
                  $mrjc(
                      link.hashCode,
                      $mrjc(
                          title.hashCode,
                          $mrjc(
                              content.hashCode,
                              $mrjc(
                                  image.hashCode,
                                  $mrjc(
                                      video.hashCode,
                                      $mrjc(author.hashCode,
                                          avatar.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SavedPost &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.category == this.category &&
          other.date == this.date &&
          other.link == this.link &&
          other.title == this.title &&
          other.content == this.content &&
          other.image == this.image &&
          other.video == this.video &&
          other.author == this.author &&
          other.avatar == this.avatar);
}

class SavedPostsCompanion extends UpdateCompanion<SavedPost> {
  final Value<int> id;
  final Value<int> catId;
  final Value<String> category;
  final Value<String> date;
  final Value<String> link;
  final Value<String> title;
  final Value<String> content;
  final Value<String> image;
  final Value<String> video;
  final Value<String> author;
  final Value<String> avatar;
  const SavedPostsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.link = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.image = const Value.absent(),
    this.video = const Value.absent(),
    this.author = const Value.absent(),
    this.avatar = const Value.absent(),
  });
  SavedPostsCompanion.insert({
    this.id = const Value.absent(),
    @required int catId,
    @required String category,
    @required String date,
    @required String link,
    @required String title,
    @required String content,
    @required String image,
    this.video = const Value.absent(),
    @required String author,
    @required String avatar,
  })  : catId = Value(catId),
        category = Value(category),
        date = Value(date),
        link = Value(link),
        title = Value(title),
        content = Value(content),
        image = Value(image),
        author = Value(author),
        avatar = Value(avatar);
  static Insertable<SavedPost> custom({
    Expression<int> id,
    Expression<int> catId,
    Expression<String> category,
    Expression<String> date,
    Expression<String> link,
    Expression<String> title,
    Expression<String> content,
    Expression<String> image,
    Expression<String> video,
    Expression<String> author,
    Expression<String> avatar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (link != null) 'link': link,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (image != null) 'image': image,
      if (video != null) 'video': video,
      if (author != null) 'author': author,
      if (avatar != null) 'avatar': avatar,
    });
  }

  SavedPostsCompanion copyWith(
      {Value<int> id,
      Value<int> catId,
      Value<String> category,
      Value<String> date,
      Value<String> link,
      Value<String> title,
      Value<String> content,
      Value<String> image,
      Value<String> video,
      Value<String> author,
      Value<String> avatar}) {
    return SavedPostsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      category: category ?? this.category,
      date: date ?? this.date,
      link: link ?? this.link,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      video: video ?? this.video,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<int>(catId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (video.present) {
      map['video'] = Variable<String>(video.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedPostsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('link: $link, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('video: $video, ')
          ..write('author: $author, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }
}

class $SavedPostsTable extends SavedPosts
    with TableInfo<$SavedPostsTable, SavedPost> {
  final GeneratedDatabase _db;
  final String _alias;
  $SavedPostsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _catIdMeta = const VerificationMeta('catId');
  GeneratedIntColumn _catId;
  @override
  GeneratedIntColumn get catId => _catId ??= _constructCatId();
  GeneratedIntColumn _constructCatId() {
    return GeneratedIntColumn(
      'cat_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  GeneratedTextColumn _category;
  @override
  GeneratedTextColumn get category => _category ??= _constructCategory();
  GeneratedTextColumn _constructCategory() {
    return GeneratedTextColumn(
      'category',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedTextColumn _date;
  @override
  GeneratedTextColumn get date => _date ??= _constructDate();
  GeneratedTextColumn _constructDate() {
    return GeneratedTextColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _linkMeta = const VerificationMeta('link');
  GeneratedTextColumn _link;
  @override
  GeneratedTextColumn get link => _link ??= _constructLink();
  GeneratedTextColumn _constructLink() {
    return GeneratedTextColumn(
      'link',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedTextColumn _image;
  @override
  GeneratedTextColumn get image => _image ??= _constructImage();
  GeneratedTextColumn _constructImage() {
    return GeneratedTextColumn(
      'image',
      $tableName,
      false,
    );
  }

  final VerificationMeta _videoMeta = const VerificationMeta('video');
  GeneratedTextColumn _video;
  @override
  GeneratedTextColumn get video => _video ??= _constructVideo();
  GeneratedTextColumn _constructVideo() {
    return GeneratedTextColumn(
      'video',
      $tableName,
      true,
    );
  }

  final VerificationMeta _authorMeta = const VerificationMeta('author');
  GeneratedTextColumn _author;
  @override
  GeneratedTextColumn get author => _author ??= _constructAuthor();
  GeneratedTextColumn _constructAuthor() {
    return GeneratedTextColumn(
      'author',
      $tableName,
      false,
    );
  }

  final VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  GeneratedTextColumn _avatar;
  @override
  GeneratedTextColumn get avatar => _avatar ??= _constructAvatar();
  GeneratedTextColumn _constructAvatar() {
    return GeneratedTextColumn(
      'avatar',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        catId,
        category,
        date,
        link,
        title,
        content,
        image,
        video,
        author,
        avatar
      ];
  @override
  $SavedPostsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'saved_posts';
  @override
  final String actualTableName = 'saved_posts';
  @override
  VerificationContext validateIntegrity(Insertable<SavedPost> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('cat_id')) {
      context.handle(
          _catIdMeta, catId.isAcceptableOrUnknown(data['cat_id'], _catIdMeta));
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category'], _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
          _linkMeta, link.isAcceptableOrUnknown(data['link'], _linkMeta));
    } else if (isInserting) {
      context.missing(_linkMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('video')) {
      context.handle(
          _videoMeta, video.isAcceptableOrUnknown(data['video'], _videoMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author'], _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar'], _avatarMeta));
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedPost map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SavedPost.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SavedPostsTable createAlias(String alias) {
    return $SavedPostsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $SavedPostsTable _savedPosts;
  $SavedPostsTable get savedPosts => _savedPosts ??= $SavedPostsTable(this);
  SavedPostsDao _savedPostsDao;
  SavedPostsDao get savedPostsDao =>
      _savedPostsDao ??= SavedPostsDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedPosts];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$SavedPostsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SavedPostsTable get savedPosts => attachedDatabase.savedPosts;
}
