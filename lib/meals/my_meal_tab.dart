import 'package:flutter/material.dart';

class MyMealsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Saved Meals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://cdn.britannica.com/36/123536-050-95CB0C6E/Variety-fruits-vegetables.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('Meal ${index + 1}'),
                    subtitle: Text('Details about meal ${index + 1}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
