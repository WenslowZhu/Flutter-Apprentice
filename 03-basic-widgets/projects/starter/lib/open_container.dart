// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

const String _loremIpsumParagraph =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'suspendisse in est. Ut ornare lectus sit amet. Eget nunc lobortis mattis '
    'aliquam faucibus purus in. Hendrerit gravida rutrum quisque non tellus '
    'orci ac auctor. Mattis aliquam faucibus purus in massa. Tellus rutrum '
    'tellus pellentesque eu tincidunt tortor. Nunc eget lorem dolor sed. Nulla '
    'at volutpat diam ut venenatis tellus in metus. Tellus  enim '
    'eu turpis. Pretium fusce id velit ut tortor. Adipiscing enim eu turpis '
    'egestas pretium. Quis varius quam quisque id. Blandit aliquam etiam erat '
    'velit scelerisque. In nisl nisi scelerisque eu. Semper risus in hendrerit '
    'gravida rutrum quisque. Suspendisse in est ante in nibh mauris cursus '
    'mattis molestie. Adipiscing elit duis tristique sollicitudin nibh sit '
    'amet commodo nulla. Pretium viverra suspendisse potenti nullam ac tortor '
    'vitae.\n'
    '\n'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'suspendisse in est. Ut ornare lectus sit amet. Eget nunc lobortis mattis '
    'aliquam faucibus purus in. Hendrerit gravida rutrum quisque non tellus '
    'orci ac auctor. Mattis aliquam faucibus purus in massa. Tellus rutrum '
    'tellus pellentesque eu tincidunt tortor. Nunc eget lorem dolor sed. Nulla '
    'at volutpat diam ut venenatis tellus in metus. Tellus cr enim '
    'eu turpis. Pretium fusce id velit ut tortor. Adipiscing enim eu turpis '
    'egestas pretium. Quis varius quam quisque id. Blandit aliquam etiam erat '
    'velit scelerisque. In nisl nisi scelerisque eu. Semper risus in hendrerit '
    'gravida rutrum quisque. Suspendisse in est ante in nibh mauris cursus '
    'mattis molestie. Adipiscing elit duis tristique sollicitudin nibh sit '
    'amet commodo nulla. Pretium viverra suspendisse potenti nullam ac tortor '
    'vitae';

const double _fabDimension = 56;

class OpenContainerTransformDemo extends StatefulWidget {
  const OpenContainerTransformDemo({Key? key}) : super(key: key);

  @override
  _OpenContainerTransformDemoState createState() =>
      _OpenContainerTransformDemoState();
}

class _OpenContainerTransformDemoState
    extends State<OpenContainerTransformDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  void _showSettingsBottomModalSheet(BuildContext context) {
    const localizations = 'GalleryLocalizations.of(context)';

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 125,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(2),
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    onPressed: (index) {
                      setModalState(() {
                        setState(() {
                          _transitionType = index == 0
                              ? ContainerTransitionType.fade
                              : ContainerTransitionType.fadeThrough;
                        });
                      });
                    },
                    isSelected: <bool>[
                      _transitionType == ContainerTransitionType.fade,
                      _transitionType == ContainerTransitionType.fadeThrough,
                    ],
                    children: [
                      const Text(
                        localizations,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          localizations,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = 'GalleryLocalizations.of(context)';
    final colorScheme = Theme.of(context).colorScheme;

    return Navigator(
      // Adding [ValueKey] to make sure that the widget gets rebuilt when
      // changing type.
      key: ValueKey(_transitionType),
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  Text(
                    localizations,
                  ),
                  Text(
                    '(${localizations})',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                  ),
                  onPressed: () {
                    _showSettingsBottomModalSheet(context);
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (context, openContainer) {
                    return _DetailsCard(openContainer: openContainer);
                  },
                ),
                const SizedBox(height: 16),
                _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (context, openContainer) {
                    return _DetailsListTile(openContainer: openContainer);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _OpenContainerWrapper(
                        transitionType: _transitionType,
                        closedBuilder: (context, openContainer) {
                          return _SmallDetailsCard(
                            openContainer: openContainer,
                            subtitle:
                                localizations,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: _OpenContainerWrapper(
                        transitionType: _transitionType,
                        closedBuilder: (context, openContainer) {
                          return _SmallDetailsCard(
                            openContainer: openContainer,
                            subtitle:
                                localizations,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _OpenContainerWrapper(
                        transitionType: _transitionType,
                        closedBuilder: (context, openContainer) {
                          return _SmallDetailsCard(
                            openContainer: openContainer,
                            subtitle: localizations,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: _OpenContainerWrapper(
                        transitionType: _transitionType,
                        closedBuilder: (context, openContainer) {
                          return _SmallDetailsCard(
                            openContainer: openContainer,
                            subtitle: localizations,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: _OpenContainerWrapper(
                        transitionType: _transitionType,
                        closedBuilder: (context, openContainer) {
                          return _SmallDetailsCard(
                            openContainer: openContainer,
                            subtitle: localizations
                                ,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ...List.generate(10, (index) {
                  return OpenContainer<bool>(
                    transitionType: _transitionType,
                    openBuilder: (context, openContainer) =>
                        const _DetailsPage(),
                    tappable: false,
                    closedShape: const RoundedRectangleBorder(),
                    closedElevation: 0,
                    closedBuilder: (context, openContainer) {
                      return ListTile(
                        leading: Icon(
                          Icons.book, color: Colors.white, size: 40
                          ),
                        onTap: openContainer,
                        title: Text(
                          localizations +
                              ' ${index + 1}',
                        ),
                        subtitle: Text(
                          localizations,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
            floatingActionButton: OpenContainer(
              transitionType: _transitionType,
              openBuilder: (context, openContainer) => const _DetailsPage(),
              closedElevation: 6,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_fabDimension / 2),
                ),
              ),
              closedColor: colorScheme.secondary,
              closedBuilder: (context, openContainer) {
                return SizedBox(
                  height: _fabDimension,
                  width: _fabDimension,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (context, openContainer) => const _DetailsPage(),
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.openContainer});

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    const localizations = 'trextfadfdsdfadfafdfadf';

    return _InkWellOverlay(
      openContainer: openContainer,
      height: 300,
      width: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.black38,
              child: Center(
                child: Icon(
                          Icons.book, color: Colors.red, size: 40
                          ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              localizations,
            ),
            subtitle: Text(
              localizations,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur '
              'adipiscing elit, sed do eiusmod tempor.',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Colors.black54,
                    inherit: false,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallDetailsCard extends StatelessWidget {
  const _SmallDetailsCard({
    required this.openContainer,
    required this.subtitle,
  });

  final VoidCallback openContainer;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _InkWellOverlay(
      openContainer: openContainer,
      height: 225,
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black38,
            height: 150,
            child: Center(
              child: Icon(
                          Icons.book, color: Colors.white, size: 40
                          ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GalleryLocalizations.of(context)',
                    style: textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    subtitle,
                    style: textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsListTile extends StatelessWidget {
  const _DetailsListTile({required this.openContainer});

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const height = 120.0;

    return _InkWellOverlay(
      openContainer: openContainer,
      height: height,
      width: 300,
      child: Row(
        children: [
          Container(
            color: Colors.black38,
            height: height,
            width: height,
            child: Center(
              child: Icon(
                          Icons.book, color: Colors.white, size: 40
                          ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GalleryLocalizations.of(context).demoMotionPlacehold',
                    style: textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur '
                    'adipiscing elit,',
                    style: textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    required this.openContainer,
    required this.width,
    required this.height,
    required this.child,
  });

  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage();

  @override
  Widget build(BuildContext context) {
    final localizations = 'GalleryLocalizations.of(context)';
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text(
          'demo',
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.red,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(70),
              child: Icon(
                          Icons.book, color: Colors.white, size: 40
                          ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations,
                  style: textTheme.headline5?.copyWith(
                    color: Colors.green,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _loremIpsumParagraph,
                  style: textTheme.bodyText2?.copyWith(
                    color: Colors.purple,
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

