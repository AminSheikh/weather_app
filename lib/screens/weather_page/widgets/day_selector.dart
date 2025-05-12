import 'package:flutter/material.dart';
import 'day_item.dart';

class DaySelector extends StatelessWidget {
  final List<dynamic> days;
  final Function(int) onDaySelected;
  final int selectedIndex;
  final bool isLandscape;
  final List<String> iconUrls;

  const DaySelector({
    super.key,
    required this.days,
    required this.onDaySelected,
    required this.selectedIndex,
    required this.isLandscape,
    required this.iconUrls,
  });

  @override
  Widget build(BuildContext context) {
    if (isLandscape) {
      // Vertical list for landscape orientation
      return Container(
        width: double.infinity,
        color: Colors.transparent,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: days.length,
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: DayItem(
                day: day,
                isSelected: isSelected,
                onTap: () => onDaySelected(index),
                iconUrl: iconUrls[index],
                isHorizontal: true,
              ),
            );
          },
        ),
      );
    } else {
      // Horizontal list for portrait orientation
      return Container(
        height: 100,
        color: Colors.transparent,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: DayItem(
                day: day,
                isSelected: isSelected,
                onTap: () => onDaySelected(index),
                iconUrl: iconUrls[index],
                isHorizontal: false,
              ),
            );
          },
        ),
      );
    }
  }
}
