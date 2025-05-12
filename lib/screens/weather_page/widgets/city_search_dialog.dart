import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../utils/constants.dart';

class CitySearchDialog extends StatefulWidget {
  final Function(String) onCitySelected;
  final String currentCity;

  const CitySearchDialog({
    Key? key,
    required this.onCitySelected,
    required this.currentCity,
  }) : super(key: key);

  @override
  State<CitySearchDialog> createState() => _CitySearchDialogState();
}

class _CitySearchDialogState extends State<CitySearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.currentCity;
    _filteredCities = AppConstants.popularCities;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = AppConstants.popularCities;
      } else {
        _filteredCities = AppConstants.popularCities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Calculate dialog dimensions based on screen orientation
  Map<String, dynamic> _calculateDialogDimensions(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    return {
      'dialogWidth': isLandscape ? screenWidth * 0.6 : screenWidth * 0.85,
      'dialogHeight': 450.0,
      'horizontalPadding': isLandscape ? 40.0 : 20.0,
      'verticalPadding': isLandscape ? 24.0 : 24.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Get dialog dimensions
    final dimensions = _calculateDialogDimensions(context);
    final dialogWidth = dimensions['dialogWidth'];
    final dialogHeight = dimensions['dialogHeight'];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: dimensions['horizontalPadding'],
        vertical: dimensions['verticalPadding'],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select City',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3.0,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for a city',
                      hintStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          _filterCities('');
                        },
                      ),
                    ),
                    onChanged: (value) {
                      _filterCities(value);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = _filteredCities[index];
                        final isCurrentCity = city == widget.currentCity;

                        return Container(
                          decoration: BoxDecoration(
                            border: index < _filteredCities.length - 1
                                ? Border(
                                    bottom: BorderSide(
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      width: 0.5,
                                    ),
                                  )
                                : null,
                          ),
                          child: ListTile(
                            title: Text(
                              city,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isCurrentCity
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0.5, 0.5),
                                    blurRadius: 1.0,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              widget.onCitySelected(city);
                              Navigator.pop(context);
                            },
                            trailing: isCurrentCity
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            widget.onCitySelected(_searchController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
