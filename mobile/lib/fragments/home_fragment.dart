import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../entity/consts.dart';
import '../pages/new_list_page.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with AutomaticKeepAliveClientMixin {
  // override `wantKeepAlive` as `true` to keep page alive
  @override
  bool get wantKeepAlive => true;

  // the shown date time.
  var dateTime = DateTime.now();

  // if the shown time is current time
  bool showCurrent = true;

  // if the shown time is in recent (1 hour)
  bool showRecent = true;

  // if GPS track enabled. this will be automatically turned off if not `showRecent`
  bool enableTrack = true;

  final _divider = const Divider(color: Colors.black12);

  @override
  void initState() {
    super.initState();
    Stream.periodic(const Duration(minutes: 1)).listen((event) {
      if (showCurrent) {
        setState(() {
          dateTime = DateTime.now();
        });
      }
    });
  }

  updateSwitcher() {
    final error =
        DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

    showRecent = error < 3600000; // 1 hour
    showCurrent = error < 60000; // 1 minute
  }

  Widget _dateWidget(BuildContext context) => Center(
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '日期',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                DateFormat('yyyy年M月d日').format(dateTime),
                style: const TextStyle(fontSize: 42),
              ),
            ],
          ),
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: dt1758,
                lastDate: DateTime.now());
            if (date != null) {
              setState(() {
                dateTime = DateTime(date.year, date.month, date.day,
                    dateTime.hour, dateTime.minute);
                updateSwitcher();
              });
            }
          },
        ),
      );

  Widget _timeWidget(BuildContext context) => Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: Column(
                    children: [
                      const Text(
                        '时间',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        DateFormat('HH:mm').format(dateTime),
                        style: const TextStyle(fontSize: 42),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(dateTime));
                    if (time != null) {
                      setState(() {
                        dateTime = DateTime(dateTime.year, dateTime.month,
                            dateTime.day, time.hour, time.minute);
                        updateSwitcher();
                      });
                    }
                  },
                ),
                _controlButton(),
              ],
            ),
          ),
          if (!showCurrent)
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    dateTime = DateTime.now();
                    updateSwitcher();
                  });
                },
                icon: const Icon(Icons.restore_rounded),
                iconSize: 36,
                color: Colors.blueGrey,
              ),
            ),
        ],
      );

  Widget _controlButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                dateTime = DateTime.fromMillisecondsSinceEpoch(
                    dateTime.millisecondsSinceEpoch - 60000); // 1 minute
                updateSwitcher();
              });
            },
            icon: const Icon(Icons.remove_circle_rounded),
            iconSize: 36,
            color: Colors.blueGrey,
          ),
          IconButton(
            onPressed: () {
              if (DateTime.now().millisecondsSinceEpoch -
                      dateTime.millisecondsSinceEpoch >=
                  60000) {
                // 1 minute
                setState(() {
                  dateTime = DateTime.fromMillisecondsSinceEpoch(
                      dateTime.millisecondsSinceEpoch + 60000); // 1 minute
                  updateSwitcher();
                });
              }
            },
            icon: const Icon(Icons.add_circle_rounded),
            iconSize: 36,
            color: Colors.blueGrey,
          ),
        ],
      );

  Widget _trackSwitch() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '开启轨迹记录',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            width: 16,
          ),
          Switch(
            value: enableTrack && showRecent,
            onChanged: (val) {
              if (showRecent) {
                setState(() {
                  enableTrack = val;
                });
              }
            },
          ),
        ],
      );

  Widget _buttons() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buttonNew(),
          const SizedBox(height: 16,),
          _buttonJoin(),
        ],
      );

  Widget _buttonNew() => ElevatedButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
        icon: showRecent
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SvgPicture.asset('assets/svg/binoculars.svg',
                    width: 40, height: 40, semanticsLabel: 'Acme Logo'),
              )
            : const Icon(
                Icons.edit_note_rounded,
                size: 48,
                color: Colors.white,
              ),
        label: Text(
          showRecent ? '去观鸟!' : '输入记录',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewListPage()));
        },
      );

  Widget _buttonJoin() => TextButton(
        onPressed: () {},
        child: const Text(
          '加入观鸟队伍',
          style: TextStyle(fontSize: 16),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(child: _dateWidget(context)),
          _divider,
          Expanded(child: _timeWidget(context)),
          _divider,
          _trackSwitch(),
          _divider,
          Expanded(child: _buttons()),
        ],
      ),
    );
  }
}
