import 'package:flutter/material.dart';

class MealPlanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your free daily recipe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      'https://www.eatingwell.com/thmb/088YHsNmHkUQ7iNGP4375MiAXOY=/1500x0/filters'
                          ':no_upscale():max_bytes(150000):strip_icc'
                          '()/article_7866255_foods-you-should-eat-every'
                          '-week-to-lose-weight_-04-d58e9c481bce4a29b47295baade4072d.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(label: Text('Breakfast')),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text('4.6'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Toast with Cream Chasse and Egg',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('10 min - 366 kcal'),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Log',style: TextStyle(fontSize: 18,
                                    color: Colors.grey,fontWeight: FontWeight.bold),),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Colors.red,
                              onPressed: () {},
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text('NEW RECIPE IN', style: TextStyle(color: Colors.grey)),
                  Text('4:41:12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 10),
                  Container(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF5AA189)),
                      child: Text('Try Plus+ free', style: TextStyle(color: Colors.white,fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
