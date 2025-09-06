import 'package:flutter/material.dart';
import 'package:project_5/data/dummy_data.dart';
import 'package:project_5/models/category.dart';
import 'package:project_5/models/meal.dart';
import 'package:project_5/screens/meals.dart';
import 'package:project_5/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// Explicit Animation
class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  // will have the value as soon as its  being used the first time
  // but not yet when the class is created
  late AnimationController _animationController;

  // if there will be multiple explicit animation controllers then
  // go for TickerProviderStateMixin instead of SingleTickerProviderStateMixin

  @override
  void initState() {
    super.initState();

    // animation will start from the value of 0 and end at 1
    // this process will take 300ms
    // 60 fps refresh rate
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals.where(
      (meal) => meal.categories.contains(category.id)
    ).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals
        )
      )
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    // child will not be re-built and re-evaluated
    // i.e. GridView will not be animated, while the Padding widget will
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              }
            )
        ]
      ),
      // builder: (context, child) => Padding(
      //   padding: EdgeInsets.only(
      //     top: 100 - _animationController.value * 100 // current value
      //   ),
      //   child: child // its the same child that we have declared above
      // )
      builder: (context, child) => SlideTransition(
        // position: _animationController.drive(
        //   Tween(
        //     begin: const Offset(0, 0.3),
        //     end: const Offset(0, 0)
        //   )
        // ),
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut
          )
        ),
        child: child
      )
    );
  }
}