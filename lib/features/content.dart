import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../data/models.dart';
import '../ui/components.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final people = ['Marian Marshall', 'Lee Brown', 'James Mack']
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return PageFrame(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Feeds', style: TextStyle(fontSize: 42)),
                    ),
                    IconButton(
                      tooltip: 'Open navigation',
                      onPressed: () => go(context, '/menu'),
                      icon: const Icon(Icons.menu_rounded, color: muted),
                    ),
                    Avatar(onTap: () => go(context, '/profile')),
                  ],
                ),
                const SizedBox(height: 12),
                SearchBox(onChanged: (value) => setState(() => query = value)),
              ],
            ),
          ),
          Expanded(
            child: people.isEmpty
                ? const EmptyState(
                    'No posts found',
                    'Try searching for Marian, Lee, or James.',
                  )
                : ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final person = people[index],
                          liked = store.liked.contains(person);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Avatar(onTap: () => go(context, '/profile')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(person),
                                      Text(
                                        index == 0 ? '2 min ago' : '3 hours',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FollowButton(
                                  followed: store.following.contains(person),
                                  onPressed: () =>
                                      store.toggle(store.following, person),
                                ),
                              ],
                            ),
                          ),
                          GreyBox(
                            height: index == 0 ? 210 : 260,
                            radius: 0,
                            label: 'Photo by $person',
                            onTap: () => go(
                              context,
                              '/article',
                              stories[index % stories.length],
                            ),
                            child: index == 1
                                ? Row(
                                    children: [
                                      const Expanded(child: SizedBox()),
                                      Container(
                                        width: 4,
                                        color: store.dark
                                            ? const Color(0xFF17181D)
                                            : Colors.white,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Expanded(child: SizedBox()),
                                            Container(
                                              height: 4,
                                              color: store.dark
                                                  ? const Color(0xFF17181D)
                                                  : Colors.white,
                                            ),
                                            const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () =>
                                    store.toggle(store.liked, person),
                                icon: Icon(
                                  liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color: liked ? purple : muted,
                                ),
                                label: Text(
                                  '${968 + (liked ? 1 : 0)}',
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => go(
                                  context,
                                  '/article',
                                  stories[index % stories.length],
                                ),
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 17,
                                  color: muted,
                                ),
                                label: const Text(
                                  '26',
                                  style: TextStyle(color: muted, fontSize: 13),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'Save post',
                                onPressed: () => store.toggle(
                                  store.saved,
                                  stories[index % stories.length].title,
                                ),
                                icon: Icon(
                                  store.saved.contains(
                                        stories[index % stories.length].title,
                                      )
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: muted,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return PageFrame(
      title: 'Categories',
      menu: true,
      actions: [
        IconButton(
          tooltip: 'Saved articles',
          onPressed: () => go(context, '/saved'),
          icon: const Icon(Icons.favorite_border, color: muted),
        ),
        IconButton(
          tooltip: 'Browse articles',
          onPressed: () => go(context, '/articles'),
          icon: const Icon(Icons.search, color: muted),
        ),
      ],
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(0, 12, 24, 24),
        itemCount: stories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final story = stories[index];
          return GreyBox(
            height: 160,
            radius: 8,
            onTap: () => go(context, '/articles', story.category),
            label: '${story.category} cover',
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 20,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: ink,
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(72, 28),
                    ),
                    onPressed: () =>
                        store.toggle(store.following, story.category),
                    child: Text(
                      store.following.contains(story.category)
                          ? 'Following'
                          : '+ Follow',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  right: 130,
                  child: Text(
                    story.category.replaceAll(' & ', ' &\n'),
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Positioned(
                  right: 20,
                  bottom: 20,
                  child: Text(
                    '✎ 281k   ♟ 197k',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key, this.category, this.savedOnly = false});
  final String? category;
  final bool savedOnly;
  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  int selected = 0;
  String query = '';
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    var items = stories
        .where(
          (s) =>
              (widget.category == null || s.category == widget.category) &&
              (!widget.savedOnly || store.saved.contains(s.title)) &&
              s.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    if (selected == 1) items = items.reversed.toList();
    return PageFrame(
      title: widget.savedOnly
          ? 'Saved articles'
          : widget.category ?? 'Articles',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SearchBox(
              hint: 'Search articles…',
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          if (!widget.savedOnly)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  for (final (index, label) in ['For You', 'Featured'].indexed)
                    TextButton(
                      onPressed: () => setState(() => selected = index),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: selected == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selected == index
                              ? Theme.of(context).colorScheme.onSurface
                              : muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? EmptyState(
                    widget.savedOnly
                        ? 'Nothing saved yet'
                        : 'No articles found',
                    widget.savedOnly
                        ? 'Tap a bookmark on an article to keep it here.'
                        : 'Try another title.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final story = items[index];
                      return GreyBox(
                        height: 380,
                        onTap: () => go(context, '/article', story),
                        label: story.title,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Avatar(size: 28),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      story.author,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '3m',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                story.title,
                                style: const TextStyle(
                                  fontSize: 32,
                                  height: 1.18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                '◉ 4.5k    ♥ 916',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.story});
  final Story story;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return PageFrame(
      title: 'Article',
      actions: [
        IconButton(
          tooltip: 'Save article',
          onPressed: () => store.toggle(store.saved, story.title),
          icon: Icon(
            store.saved.contains(story.title)
                ? Icons.bookmark
                : Icons.bookmark_border,
          ),
        ),
      ],
      child: ListView(
        children: [
          const GreyBox(height: 260, radius: 0, label: 'Article cover'),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: purple,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  story.title,
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Avatar(size: 32),
                    const SizedBox(width: 10),
                    Expanded(child: Text(story.author)),
                    const Text(
                      '5 min read',
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  story.excerpt,
                  style: const TextStyle(fontSize: 20, height: 1.6),
                ),
                const SizedBox(height: 20),
                const Text(
                  'A fresh perspective',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Take a moment to notice the details. The people you meet, the places you discover, and the ideas you collect can all become a starting point.\n\nChoose one small thing to explore today. Write it down, share it with a friend, and see where it takes you.',
                  style: TextStyle(fontSize: 17, height: 1.7),
                ),
                const SizedBox(height: 24),
                FollowButton(
                  followed: store.following.contains(story.author),
                  onPressed: () => store.toggle(store.following, story.author),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
