import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/widgets/build_admin_menu_item.dart';

class BuildMenuItem extends StatelessWidget {
  final AdminMenuItem item;
  const BuildMenuItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get screen size for responsiveness
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth >= 768;
        final isMobile = screenWidth < 600;

        // Responsive padding
        final cardPadding = isMobile ? 12.0 : (isTablet ? 20.0 : 16.0);

        // Responsive icon size
        final iconPadding = isMobile ? 6.0 : 8.0;
        final iconSize = isMobile ? 20.0 : (isTablet ? 28.0 : 24.0);

        // Responsive text sizes
        final titleSize = isMobile ? 14.0 : (isTablet ? 18.0 : 16.0);
        final descriptionSize = isMobile ? 11.0 : (isTablet ? 14.0 : 12.0);

        // Responsive spacing
        final verticalSpacing = isMobile ? 12.0 : 16.0;
        final textSpacing = isMobile ? 2.0 : 4.0;

        // Responsive border radius
        final borderRadius = isMobile ? 12.0 : 16.0;

        return Material(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () => Navigator.pushNamed(context, item.route),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: isMobile ? 100 : (isTablet ? 140 : 120),
                maxHeight: isMobile ? 160 : (isTablet ? 200 : 180),
              ),
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: isMobile ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: textSpacing),
                        Expanded(
                          child: Text(
                            item.description,
                            style: TextStyle(
                              fontSize: descriptionSize,
                              color: Colors.grey[400],
                              height: 1.3,
                            ),
                            maxLines: isMobile ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}