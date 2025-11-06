import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp>
    with SingleTickerProviderStateMixin {
  bool isDark = true;
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightBg = const Color(0xFFF6F9FC);
    final lightCard = Colors.white.withOpacity(0.9);
    final darkBg = const Color(0xFF071026);
    final darkCard = const Color(0xFF0D1B2A).withOpacity(0.65);

    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo, brightness: Brightness.light),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      scaffoldBackgroundColor: lightBg,
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigoAccent, brightness: Brightness.dark),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: darkBg,
    );

    return MaterialApp(
      title: 'Rishi Chintakindi — Portfolio',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDark: isDark,
        onToggleTheme: () => setState(() => isDark = !isDark),
        entrance: _entranceController,
        lightCardColor: lightCard,
        darkCardColor: darkCard,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final AnimationController entrance;
  final Color lightCardColor;
  final Color darkCardColor;

  const HomePage(
      {Key? key,
      required this.isDark,
      required this.onToggleTheme,
      required this.entrance,
      required this.lightCardColor,
      required this.darkCardColor})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late final AnimationController _staggerController;
  bool drawerOpen = false;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final offset =
        box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
    final scrollOffset =
        _scrollController.offset + offset.dy - 100; // add small padding

    _scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    if (drawerOpen) {
      setState(() => drawerOpen = false);
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final cardColor =
        widget.isDark ? widget.darkCardColor : widget.lightCardColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Rishi Chintakindi',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: isWide
            ? [
                TextButton(
                    onPressed: () => _scrollToSection(_experienceKey),
                    child: const Text('Experience')),
                TextButton(
                    onPressed: () => _scrollToSection(_projectsKey),
                    child: const Text('Projects')),
                TextButton(
                    onPressed: () => _scrollToSection(_skillsKey),
                    child: const Text('Skills')),
                TextButton(
                    onPressed: () => _scrollToSection(_educationKey),
                    child: const Text('Education')),
                TextButton(
                    onPressed: () => _scrollToSection(_contactKey),
                    child: const Text('Contact')),
                IconButton(
                  tooltip: widget.isDark ? 'Switch to Light' : 'Switch to Dark',
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: widget.isDark
                        ? const Icon(Icons.dark_mode, key: ValueKey('dark'))
                        : const Icon(Icons.light_mode, key: ValueKey('light')),
                  ),
                  onPressed: widget.onToggleTheme,
                ),
                const SizedBox(width: 8)
              ]
            : [
                IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: widget.isDark
                        ? const Icon(Icons.dark_mode, key: ValueKey('dark2'))
                        : const Icon(Icons.light_mode, key: ValueKey('light2')),
                  ),
                  onPressed: widget.onToggleTheme,
                ),
                Builder(builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        setState(() => drawerOpen = true);
                        Scaffold.of(context).openEndDrawer();
                      });
                })
              ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ListTile(
                  title: const Text('Experience'),
                  onTap: () => _scrollToSection(_experienceKey)),
              ListTile(
                  title: const Text('Projects'),
                  onTap: () => _scrollToSection(_projectsKey)),
              ListTile(
                  title: const Text('Skills'),
                  onTap: () => _scrollToSection(_skillsKey)),
              ListTile(
                  title: const Text('Education'),
                  onTap: () => _scrollToSection(_educationKey)),
              ListTile(
                  title: const Text('Contact'),
                  onTap: () => _scrollToSection(_contactKey)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: IgnorePointer(
                  ignoring: true,
                  child: _AnimatedBackground(
                      isDark: widget.isDark, controller: widget.entrance))),
          SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              final horizontalPadding =
                  constraints.maxWidth > 900 ? 80.0 : 20.0;
              return Scrollbar(
                controller: _scrollController,
                radius: const Radius.circular(12),
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: 28),
                  children: [
                    AnimatedBuilder(
                      animation: widget.entrance,
                      builder: (context, child) {
                        final t =
                            Curves.easeOut.transform(widget.entrance.value);
                        return Transform.translate(
                            offset: Offset(0, (1 - t) * 18),
                            child: Opacity(opacity: t, child: child));
                      },
                      child: _HeroCard(
                        onContactTap: () => _scrollToSection(_contactKey),
                        onLaunch: _launch,
                        cardColor: cardColor,
                        isDark: widget.isDark,
                        isWide: constraints.maxWidth > 700,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _Section(
                        key: _experienceKey,
                        title: 'Experience',
                        child: _ExperienceList(cardColor: cardColor)),
                    const SizedBox(height: 18),
                    _Section(
                        key: _projectsKey,
                        title: 'Projects',
                        child: _ProjectsGrid(cardColor: cardColor)),
                    const SizedBox(height: 18),
                    _Section(
                        key: _skillsKey,
                        title: 'Skills',
                        child: _SkillTags(isDark: widget.isDark)),
                    const SizedBox(height: 18),
                    _Section(
                        key: _educationKey,
                        title: 'Education',
                        child: _EducationList(cardColor: cardColor)),
                    const SizedBox(height: 18),
                    _Section(
                        key: _contactKey,
                        title: 'Contact',
                        child: _ContactPanel(
                            onLaunch: _launch, cardColor: cardColor)),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _scrollToSection(_contactKey),
        label: const Text('Built by Flutter'),
        icon: const Icon(Icons.flutter_dash),
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  final bool isDark;
  final AnimationController controller;
  const _AnimatedBackground(
      {Key? key, required this.isDark, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = isDark ? const Color(0xFF071026) : const Color(0xFFF6F9FC);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [base, const Color(0xFF071833), const Color(0xFF04121D)]
              : [base, const Color(0xFFEFF5FB), const Color(0xFFDDEAF6)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              top: -80,
              left: -40,
              child: _Blob(size: 220, opacity: isDark ? 0.12 : 0.16)),
          Positioned(
              bottom: -60,
              right: -60,
              child: _Blob(size: 260, opacity: isDark ? 0.08 : 0.14)),
          IgnorePointer(
              child: CustomPaint(
                  size: Size.infinite, painter: _GridPainter(isDark: isDark))),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final double opacity;
  const _Blob({Key? key, required this.size, this.opacity = 0.12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Colors.indigo.withOpacity(0.9), Colors.transparent]),
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isDark;
  _GridPainter({required this.isDark});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.01)
          : Colors.black.withOpacity(0.02)
      ..strokeWidth = 1;
    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final double radius;
  const _GlassContainer(
      {required this.child,
      required this.color,
      this.padding = const EdgeInsets.all(12),
      this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: isDark ? 6 : 8, sigmaY: isDark ? 6 : 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.03 : 0.06)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _HeroCard extends StatefulWidget {
  final VoidCallback onContactTap;
  final Future<void> Function(String) onLaunch;
  final Color cardColor;
  final bool isDark;
  final bool isWide;
  const _HeroCard(
      {Key? key,
      required this.onContactTap,
      required this.onLaunch,
      required this.cardColor,
      required this.isDark,
      required this.isWide})
      : super(key: key);

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool hoveringAvatar = false;

  @override
  void initState() {
    super.initState();
    _pulse =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = 'Rishi Chintakindi';
    final title = 'Flutter Developer';
    final bio =
        'Computer Science grad focused on building cross-platform apps & trying to venture into new tech';
    final isDark = widget.isDark;
    final hoverScale = isDark ? 1.05 : 1.12;
    final hoverDuration = isDark ? 180 : 160;

    return _GlassContainer(
      color: widget.cardColor,
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 700 || !widget.isWide;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            narrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => hoveringAvatar = true),
                          onExit: (_) => setState(() => hoveringAvatar = false),
                          child: ScaleTransition(
                            scale: Tween(begin: 0.98, end: 1.02).animate(
                                CurvedAnimation(
                                    parent: _pulse, curve: Curves.easeInOut)),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: hoverDuration),
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.indigo.shade400,
                                  Colors.indigo.shade200
                                ]),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  if (hoveringAvatar)
                                    BoxShadow(
                                        color: isDark
                                            ? Colors.indigoAccent
                                                .withOpacity(0.32)
                                            : Colors.indigo.withOpacity(0.18),
                                        blurRadius: 24,
                                        spreadRadius: 2)
                                ],
                              ),
                              child: Center(
                                  child: Text('RC',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ],
                  )
                : Row(
                    children: [
                      MouseRegion(
                        onEnter: (_) => setState(() => hoveringAvatar = true),
                        onExit: (_) => setState(() => hoveringAvatar = false),
                        child: ScaleTransition(
                          scale: Tween(begin: 0.98, end: 1.02).animate(
                              CurvedAnimation(
                                  parent: _pulse, curve: Curves.easeInOut)),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: hoverDuration),
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.indigo.shade400,
                                Colors.indigo.shade200
                              ]),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                if (hoveringAvatar)
                                  BoxShadow(
                                      color: isDark
                                          ? Colors.indigoAccent
                                              .withOpacity(0.32)
                                          : Colors.indigo.withOpacity(0.18),
                                      blurRadius: 24,
                                      spreadRadius: 2)
                              ],
                            ),
                            child: Center(
                                child: Text('RC',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                            ]),
                      )
                    ],
                  ),
            const SizedBox(height: 12),
            Text(bio, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _AnimatedActionButton(
                  isDark: isDark,
                  label: 'GitHub',
                  icon: const Icon(Icons.code),
                  onPressed: () =>
                      widget.onLaunch('https://github.com/chkrishi'),
                ),
                _AnimatedOutlinedActionButton(
                  isDark: isDark,
                  label: 'LinkedIn',
                  icon: const Icon(Icons.person),
                  onPressed: () =>
                      widget.onLaunch('https://www.linkedin.com/in/chkrishi'),
                ),
                _AnimatedOutlinedActionButton(
                  isDark: isDark,
                  label: 'Kaggle',
                  icon: kIcon(val: 'K'),
                  onPressed: () => widget
                      .onLaunch('https://www.kaggle.com/rishichintakindi'),
                ),
                _AnimatedOutlinedActionButton(
                  isDark: isDark,
                  label: 'LeetCode',
                  icon: leetcodeTextIcon(),
                  onPressed: () =>
                      widget.onLaunch('https://www.leetcode.com/u/chkrishi'),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final bool isDark;
  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  const _AnimatedActionButton(
      {Key? key,
      required this.isDark,
      required this.label,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final scale = hovering ? (widget.isDark ? 1.04 : 1.12) : 1.0;
    final duration = Duration(milliseconds: widget.isDark ? 160 : 130);
    final glow = hovering
        ? (widget.isDark
            ? BoxShadow(
                color: Colors.indigoAccent.withOpacity(0.22),
                blurRadius: 20,
                offset: const Offset(0, 6))
            : BoxShadow(
                color: Colors.orange.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 8)))
        : null;
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: scale,
        duration: duration,
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(boxShadow: glow != null ? [glow] : []),
          child: ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: widget.icon,
            label: Text(widget.label),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedOutlinedActionButton extends StatefulWidget {
  final bool isDark;
  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  const _AnimatedOutlinedActionButton(
      {Key? key,
      required this.isDark,
      required this.label,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  State<_AnimatedOutlinedActionButton> createState() =>
      _AnimatedOutlinedActionButtonState();
}

class _AnimatedOutlinedActionButtonState
    extends State<_AnimatedOutlinedActionButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final scale = hovering ? (widget.isDark ? 1.03 : 1.1) : 1.0;
    final duration = Duration(milliseconds: widget.isDark ? 160 : 160);
    final glow = hovering
        ? (widget.isDark
            ? BoxShadow(
                color: Colors.indigoAccent.withOpacity(0.14),
                blurRadius: 18,
                offset: const Offset(0, 6))
            : BoxShadow(
                color: Colors.pink.withOpacity(0.12),
                blurRadius: 22,
                offset: const Offset(0, 8)))
        : null;
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: scale,
        duration: duration,
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(boxShadow: glow != null ? [glow] : []),
          child: OutlinedButton.icon(
            onPressed: widget.onPressed,
            icon: widget.icon,
            label: Text(widget.label),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold))),
      child
    ]);
  }
}

class _ExperienceList extends StatefulWidget {
  final Color cardColor;
  const _ExperienceList({Key? key, required this.cardColor}) : super(key: key);

  @override
  State<_ExperienceList> createState() => _ExperienceListState();
}

class _ExperienceListState extends State<_ExperienceList> {
  final experiences = [
    {
      'role': 'Flutter Intern',
      'company': 'Emudhra',
      'duration': 'Mar 2025 – Jul 2025',
      'bullets': [
        'Conducted project access reviews and implemented Riverpod for scalable and efficient state management',
        'Actively contributed to development and testing — addressing and solved authentication, notifications, routing, and internal audit issues',
        'item Fixed multiple bugs, enhanced performance, and ensured smoother user experience across modules'
      ]
    },
    {
      'role': 'SDE Intern',
      'company': 'Emudhra',
      'duration': 'Dec 2024 – Mar 2025',
      'bullets': [
        'Collaborated with team on resolving Audit Log and Hub Activity Log issues to enhance monitoring and traceability',
        'Worked on login and DSAR IP address issues, improving authentication flow and network reliability',
        'Contributed to PKI–DigiCert key management and related security activities to strengthen certificate-based authentication',
        'Supported ongoing internal audits by fixing log inconsistencies and ensuring compliance readiness'
      ]
    },
    {
      'role': 'Flutter Intern',
      'company': 'Fsalon',
      'duration': 'Jul 2024 – Sep 2024',
      'bullets': [
        'Implemented Firebase Authentication for secure user login and session management',
        'Utilized Riverpod for efficient state management and applied Clean Architecture principles for modular and maintainable code organization',
        'Focused primarily on frontend development, building new screens from the ground up and ensuring seamless UI functionality and performance',
        'Collaborated with the team to integrate APIs, test components, and maintain consistency across the app’s design and behavior'
      ]
    }
  ];

  late final List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List.generate(experiences.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(experiences.length, (i) {
        final data = experiences[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _GlassContainer(
            color: widget.cardColor,
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: () => setState(() => expanded[i] = !expanded[i]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${data['role']} — ${data['company']}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Icon(expanded[i]
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down)
                    ]),
              ),
              AnimatedCrossFade(
                firstChild: Container(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${data['duration']}' ?? '',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color)),
                        const SizedBox(height: 6),
                        ...List.generate(
                            (data['bullets'] as List).length,
                            (j) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Icon(
                                                Icons.arrow_right_rounded,
                                                size: 18)),
                                        Expanded(
                                            child: Text(
                                                (data['bullets'] as List)[j])),
                                      ]),
                                ))
                      ]),
                ),
                crossFadeState: expanded[i]
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 260),
              )
            ]),
          ),
        );
      }),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final Color cardColor;
  const _ProjectsGrid({required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'Live Face Recognition Attendance',
        'tech': 'Flutter · Firebase · ML Kit',
        'desc':
            'Automated attendance using live facial recognition and secure Firebase backend.',
        'link':
            'https://github.com/chkrishi/Attendance_using_Live_Face_Recognition'
      },
      {
        'title': 'Hostel System Management',
        'tech': 'Flutter · Firebase',
        'desc':
            'Cross-platform hostel management app with clean architecture and admin dashboards.',
        'link': 'https://github.com/chkrishi/Hostel_System_Management'
      },
    ];

    return Column(
      children: projects
          .map((p) => GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(['link'].toString());
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['title'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(p['tech'].toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(p['desc'].toString()),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () async {
                                  final uri = Uri.parse(p['link'].toString());

                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                                child: Text('View on GitHub',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))))
                      ]),
                ),
              ))
          .toList(),
    );
  }
}

class _SkillTags extends StatelessWidget {
  final bool isDark;
  const _SkillTags({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final groups = {
      'Programming Languages': [
        'Python',
        'C/C++',
        'Dart',
        'JavaScript',
        'HTML',
        'CSS'
      ],
      'Frameworks & Libraries': [
        'Flutter',
        'Riverpod',
        'MERN Stack',
        'Plotly',
        'OpenCV',
        'Keras',
        'Pandas',
        'NumPy',
        'Seaborn',
        'Matplotlib'
      ],
      'Databases': ['MySQL', 'MongoDB'],
      'APIs': ['Firebase', 'Supabase', 'Postman API', 'Node'],
      'Version Control': ['Git', 'GitHub']
    };

    final baseColor = isDark ? Colors.white24 : Colors.black12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.key,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Wrap(
                spacing: 10,
                runSpacing: 8,
                children: entry.value
                    .map((skill) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 14),
                          decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color:
                                      isDark ? Colors.white24 : Colors.black12,
                                  width: 1)),
                          child: Text(skill,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList())
          ]),
        );
      }).toList(),
    );
  }
}

class _GradientSkillChip extends StatefulWidget {
  final String label;
  final LinearGradient gradient;
  final bool isDark;
  const _GradientSkillChip(
      {Key? key,
      required this.label,
      required this.gradient,
      required this.isDark})
      : super(key: key);

  @override
  State<_GradientSkillChip> createState() => _GradientSkillChipState();
}

class _GradientSkillChipState extends State<_GradientSkillChip>
    with SingleTickerProviderStateMixin {
  bool hovering = false;
  bool tapped = false;
  late final AnimationController _underlineController;

  @override
  void initState() {
    super.initState();
    _underlineController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10));
  }

  @override
  void dispose() {
    _underlineController.dispose();
    super.dispose();
  }

  void _onEnter(bool h) {
    setState(() => hovering = h);
    if (h)
      _underlineController.forward();
    else
      _underlineController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final scale =
        hovering ? (widget.isDark ? 1.08 : 1.12) : (tapped ? 1.03 : 1.0);
    final glow = hovering
        ? (widget.isDark
            ? BoxShadow(
                color: widget.gradient.colors.last.withOpacity(0.26),
                blurRadius: 18,
                spreadRadius: 1)
            : BoxShadow(
                color: widget.gradient.colors.last.withOpacity(0.18),
                blurRadius: 22,
                spreadRadius: 2))
        : null;

    final underlineWidth = 60.0 * _underlineController.value;

    final child = AnimatedContainer(
      duration: Duration(milliseconds: widget.isDark ? 160 : 160),
      transform: Matrix4.identity()..scale(scale, scale),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: glow != null ? [glow] : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: (_underlineController.value),
              child: Container(
                height: 3,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          )
        ],
      ),
    );

    if (kIsWeb ||
        !defaultTargetPlatform.toString().contains('android') &&
            !defaultTargetPlatform.toString().contains('ios')) {
      return MouseRegion(
        onEnter: (_) => _onEnter(true),
        onExit: (_) => _onEnter(false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => tapped = true),
          onTapUp: (_) => setState(() => tapped = false),
          onTapCancel: () => setState(() => tapped = false),
          child: child,
        ),
      );
    } else {
      return GestureDetector(
        onTapDown: (_) {
          setState(() {
            tapped = true;
            _underlineController.forward();
          });
        },
        onTapUp: (_) {
          setState(() => tapped = false);
          Future.delayed(const Duration(milliseconds: 200),
              () => _underlineController.reverse());
        },
        onTapCancel: () {
          setState(() => tapped = false);
          _underlineController.reverse();
        },
        child: child,
      );
    }
  }
}

class _EducationList extends StatelessWidget {
  final Color cardColor;
  const _EducationList({Key? key, required this.cardColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final edu = [
      {
        'title': 'B.E — Computer Science          ',
        'inst': 'SCSVMV                                   ',
        'year': '2021 – 2025                      ',
        'grade': 'CGPA: 8.9 / 10                  '
      },
      {
        'title': 'Class 12 (State Board)          ',
        'inst': 'Sri Chaitanya College            ',
        'year': '2019 – 2021                      ',
        'grade': 'Percentage: 91.4%               '
      },
      {
        'title': 'Class 10 (CBSE)           ',
        'inst': 'Global Indian Internation School',
        'year': '2018 – 2019                 ',
        'grade': 'Percentage: 73.2%          '
      }
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: edu
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _GlassContainer(
                  color: cardColor,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e['title']!,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('${e['inst']} • ${e['year']}'),
                        const SizedBox(height: 6),
                        Text(e['grade']!)
                      ]),
                ),
              ))
          .toList(),
    );
  }
}

class _ContactPanel extends StatelessWidget {
  final Future<void> Function(String) onLaunch;
  final Color cardColor;
  const _ContactPanel(
      {Key? key, required this.onLaunch, required this.cardColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = 'chkrishi4@gmail.com';
    return _GlassContainer(
      color: cardColor,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Get in touch:',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(email),
        const SizedBox(height: 12),
        Row(children: [
          _SocialIconButton(
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              onTap: () => onLaunch('https://www.linkedin.com/in/chkrishi')),
          const SizedBox(width: 8),
          _SocialIconButton(
              icon: const FaIcon(FontAwesomeIcons.xTwitter),
              onTap: () => onLaunch('https://x.com/chkrishi')),
          const SizedBox(width: 8),
          _SocialIconButton(
              icon: const Icon(Icons.mail_outline),
              onTap: () => onLaunch('mailto:$email?subject=Hello%20Rishi')),
        ])
      ]),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onTap;
  const _SocialIconButton({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = hovering ? (isDark ? 1.08 : 1.12) : 1.0;
    final glow = hovering
        ? BoxShadow(
            color: isDark
                ? Colors.indigoAccent.withOpacity(0.18)
                : Colors.purple.withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 6))
        : null;
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
            boxShadow: glow != null ? [glow] : [],
            borderRadius: BorderRadius.circular(10)),
        child: Transform.scale(
            scale: scale,
            child: IconButton(onPressed: widget.onTap, icon: widget.icon)),
      ),
    );
  }
}

Widget leetcodeTextIcon({double size = 18, Color? color}) {
  return Container(
    width: size,
    height: size,
    decoration:
        BoxDecoration(color: color ?? Colors.orange, shape: BoxShape.circle),
    child: Center(
        child: Text('LC',
            style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.45,
                fontWeight: FontWeight.bold))),
  );
}

Widget kIcon({double size = 18, Color? color, required String val}) {
  return Container(
    width: size,
    height: size,
    decoration:
        BoxDecoration(color: color ?? Colors.blue, shape: BoxShape.circle),
    child: Center(
        child: Text(val,
            style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.55,
                fontWeight: FontWeight.bold))),
  );
}
