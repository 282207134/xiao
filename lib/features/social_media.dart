import 'dart:async';
import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../data/models.dart';
import '../ui/components.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  int tab = 0;
  String query = '';
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final people = contacts
        .where(
          (name) =>
              name.toLowerCase().contains(query.toLowerCase()) &&
              (tab != 1 || name == 'Kevin Watkins') &&
              (tab != 2 || name != 'Kevin Watkins'),
        )
        .toList();
    return PageFrame(
      title: 'Messages',
      menu: true,
      actions: [
        IconButton(
          tooltip: 'New conversation',
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (ctx) => SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const ListTile(
                    title: Text(
                      'Start a conversation',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  for (final name in contacts)
                    ListTile(
                      leading: const Avatar(),
                      title: Text(name),
                      onTap: () {
                        Navigator.pop(ctx);
                        go(context, '/conversation', name);
                      },
                    ),
                ],
              ),
            ),
          ),
          icon: const Icon(Icons.edit_square, color: muted),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Row(
              children: [
                const Text('Chat', style: TextStyle(fontSize: 42)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: purple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '24',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SearchBox(
              hint: 'Search messages…',
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final (index, title) in [
                'All messages',
                'Unread',
                'Read',
              ].indexed)
                TextButton(
                  onPressed: () => setState(() => tab = index),
                  child: Text(
                    title,
                    style: TextStyle(color: index == tab ? purple : muted),
                  ),
                ),
            ],
          ),
          Expanded(
            child: people.isEmpty
                ? const EmptyState(
                    'No conversations',
                    'Search for another contact.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final name = people[index], messages = store.chats[name];
                      final previews = [
                        "Okay! I’ll see you there!",
                        'You just make an awesome work…',
                        '3 photos',
                        'I’ll be there in 15 minutes',
                        'Let’s go out for a dinner!',
                        'Please send me the invoice via…',
                      ];
                      return Container(
                        margin: const EdgeInsets.fromLTRB(20, 4, 0, 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .06),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          leading: Avatar(
                            size: 48,
                            initials: name == 'Kevin Watkins' ? 'KW' : null,
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              color: name == 'Kevin Watkins' ? purple : null,
                            ),
                          ),
                          subtitle: Text(
                            messages?.last.text ??
                                previews[contacts.indexOf(name)],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Text(
                              '17m',
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                          ),
                          onTap: () => go(context, '/conversation', name),
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

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key, required this.contact});
  final String contact;
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final text = TextEditingController(), scroll = ScrollController();
  @override
  void dispose() {
    text.dispose();
    scroll.dispose();
    super.dispose();
  }

  void send() {
    if (text.text.trim().isEmpty) return;
    StoreScope.of(context).send(widget.contact, text.text);
    text.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = StoreScope.of(context).messages(widget.contact);
    return PageFrame(
      title: widget.contact,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text(
              'TODAY 14:30',
              style: TextStyle(color: muted, fontSize: 11, letterSpacing: 1.3),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scroll,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: message.mine
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!message.mine) ...[
                        const Avatar(size: 32),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 255),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: message.mine
                                ? purple
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(
                                message.mine ? 16 : 0,
                              ),
                              bottomRight: Radius.circular(
                                message.mine ? 0 : 16,
                              ),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.mine ? Colors.white : null,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: text,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => send(),
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Type something here…',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Send message',
                  onPressed: send,
                  icon: const Icon(Icons.send_rounded, color: purple),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Music',
    menu: true,
    actions: [
      IconButton(
        tooltip: 'Profile',
        onPressed: () => go(context, '/profile'),
        icon: const Icon(Icons.person_outline, color: muted),
      ),
    ],
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('For you', style: TextStyle(fontSize: 42)),
        const SizedBox(height: 28),
        SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GreyBox(
                  onTap: () => go(context, '/player', 0),
                  label: 'Recommended album',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GreyBox(
                        onTap: () => go(context, '/player', 1),
                        label: 'Album cover',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GreyBox(
                        onTap: () => go(context, '/player', 2),
                        label: 'Album cover',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionHeading('Playlists', onViewAll: () => go(context, '/player', 0)),
        SizedBox(
          height: 226,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) => SizedBox(
              width: 163,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreyBox(
                    height: 163,
                    onTap: () => go(context, '/player', index),
                    label: 'Playlist artwork',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    [
                      'Monday to Friday',
                      'Workout Musics',
                      'Morning Light',
                    ][index],
                  ),
                  const Text(
                    'Xiao Music',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SectionHeading('New songs'),
        for (final (index, song) in songs.indexed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Avatar(size: 48),
            title: Text(song),
            subtitle: Text(
              index == 0 ? 'Ed Sheeran' : 'NANCE',
              style: const TextStyle(color: purple),
            ),
            trailing: const Icon(Icons.play_arrow_rounded, color: muted),
            onTap: () => go(context, '/player', index),
          ),
      ],
    ),
  );
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, this.index = 0});
  final int index;
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late int index;
  bool playing = false, repeat = false;
  double position = 151;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void play() {
    setState(() => playing = !playing);
    timer?.cancel();
    if (playing) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          position++;
          if (position >= 292) {
            position = 0;
            if (!repeat) {
              playing = false;
              timer?.cancel();
            }
          }
        });
      });
    }
  }

  void skip(int delta) => setState(() {
    index = (index + delta) % songs.length;
    position = 0;
  });
  String time(double seconds) =>
      '${seconds ~/ 60}:${(seconds.toInt() % 60).toString().padLeft(2, '0')}';
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context), song = songs[index];
    return PageFrame(
      title: 'Now playing',
      actions: [
        IconButton(
          tooltip: 'Save song',
          onPressed: () => store.toggle(store.saved, song),
          icon: Icon(
            store.saved.contains(song) ? Icons.favorite : Icons.favorite_border,
            color: purple,
          ),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(song, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      index == 0 ? 'ED SHEERAN' : 'NANCE',
                      style: const TextStyle(fontSize: 13, color: muted),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Avatar(size: 240),
                ),
                const Text(
                  '● ○ ○ ○',
                  style: TextStyle(color: purple, fontSize: 10),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      time(position),
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                    Expanded(
                      child: Slider(
                        value: position,
                        max: 292,
                        onChanged: (value) => setState(() => position = value),
                      ),
                    ),
                    const Text(
                      '04:52',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      tooltip: 'Repeat',
                      onPressed: () => setState(() => repeat = !repeat),
                      icon: Icon(Icons.repeat, color: repeat ? purple : muted),
                    ),
                    IconButton(
                      tooltip: 'Previous song',
                      onPressed: () => skip(-1),
                      icon: const Icon(Icons.skip_previous, color: muted),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: FilledButton(
                        onPressed: play,
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        child: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Next song',
                      onPressed: () => skip(1),
                      icon: const Icon(Icons.skip_next, color: muted),
                    ),
                    IconButton(
                      tooltip: 'Playlist',
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        builder: (ctx) => SafeArea(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (final (i, title) in songs.indexed)
                                ListTile(
                                  title: Text(title),
                                  selected: i == index,
                                  onTap: () {
                                    setState(() {
                                      index = i;
                                      position = 0;
                                    });
                                    Navigator.pop(ctx);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.queue_music, color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Player preview · no audio source',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
