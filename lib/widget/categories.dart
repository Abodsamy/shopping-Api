import 'package:flutter/material.dart';
import '../screen/category_screen.dart';

class Categories extends StatelessWidget {
  final String title;
  final String image;
  final String category;
  final VoidCallback onCartUpdated;

  const Categories({
    super.key,
    required this.title,
    required this.image,
    required this.category,
    required this.onCartUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryScreen(
                category: category,
                onCartUpdated: onCartUpdated,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 70,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
