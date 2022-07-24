import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../local_storage.dart';
import '../bike/models.dart';
import '../bike/bike.dart';

class Settings extends StatelessWidget {
  const Settings({this.ios, super.key});

  final bool? ios;

  PreferredSizeWidget buildAppBar(BuildContext context) => ios == true
      ? CupertinoNavigationBar(
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          leading: Container(),
          middle: const Text('Settings'),
          trailing: _CloseButton(onPressed: () => Navigator.pop(context)),
        ) as PreferredSizeWidget
      : AppBar(
          title: const Text('Settings'),
        );

  logout(context) async {
    removeApiTokens();
    final navigator = Navigator.of(context);
    while (true) {
      final popped = await navigator.maybePop();
      if (!popped) {
        break;
      }
    }
    navigator.popAndPushNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      overlayStyle: SystemUiOverlayStyle.dark,
      body: Scaffold(
        appBar: buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              const _Section(
                title: 'Bike',
                children: [
                  BellSoundControl(),
                ],
              ),
              _Section(
                title: 'Account',
                children: [
                  ElevatedButton(
                      onPressed: () => logout(context),
                      child: const Text('Logout')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BellSoundControl extends StatelessWidget {
  const BellSoundControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            'Bell sound',
            style: TextStyle(fontSize: 16),
          ),
        ),
        CupertinoSlidingSegmentedControl(
          onValueChanged: (BellSound? value) => print(value),
          groupValue: BellSound.bell,
          children: bellSoundsToString.map((key, value) => MapEntry(
                key,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        bellIcon(key),
                        size: 18,
                      ),
                    ),
                    Text(value)
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(2),
        child: const Icon(Icons.close_rounded, size: 22),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.black26,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }
}
