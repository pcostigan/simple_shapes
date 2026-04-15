import 'package:flutter/material.dart';
import 'shapes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your custom shape theme
    const customShapeTheme = ShapeTheme(
      insideColor: Colors.lightBlueAccent,
      borderColor: Colors.blue,
      borderWidth: 2.0,
      radius: 0,
      shadowColor: Colors.black26,
      shadowOffset: Offset(2, 2),
      shadowBlurRadius: 4.0,
    );

    return ShapeThemeProvider(
      shapeTheme: customShapeTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shape Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Shape Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 30,
              children: [
                  Square(),
                  Triangle(),
                  Triangle.fromAngles(
                    width: 100,
                    lowerRightAngle: 20,
                    lowerLeftAngle: 100,
                  ),
                  Circle(),
                  Rhombus(),
                  Pentagon(),
                  Hexagon(),

                  Septagon(),
                  Octagon(),
                  Star(),
                  SizedBox(width: 10,),
                  Arrow(),
                  SizedBox(width: 10,),
                  Cross(),
                  Trapezoid(),
                  Diamond(),
                  Chevron(),

                  Ring(),
                  Heart(),
                  Badge1(),
                  Badge2(),
                  Badge3(),
                  MessageBubble(),
                  Ticket(),

                  Crescent(),
                  Wedge(startAngle: 0, stopAngle: 215,),
                  Gear(),
                  Teardrop(),
                  Triangle(),
                  Cross(
                    size: 100,
                    thickness: 22,
                    crossAt: 0.5,          // centred plus sign
                    insideColor: Colors.red,
                    borderColor: Colors.red.shade900,
                    borderWidth: 2,
                    radius: 10,            // rounds all 12 corners
                  ),
                  Pentagon(
                    size: 120,
                    insideColor: Colors.amber,
                    radius: 8,
                    childSizeFactor: 0.6,
                    shadowColor: Colors.transparent,
                    child: const Icon(Icons.star, color: Colors.white, size: 40),
                  ),
                  Heart(
                    size: 100,
                    insideColor: Colors.pink,
                    shadowColor: Colors.pink.withValues(alpha: 0.5),
                    shadowOffset: const Offset(4, 6),
                    shadowBlurRadius: 12,
                  ),
                  Star(
                    size: 100,
                    points: 20,
                    innerRadiusRatio: 0.4,
                    insideColor: Colors.yellow,
                    borderColor: Colors.orange,
                    rotation: 45,          // tilts to a four-pointed compass star
                  ),
                  Rhombus(
                    size: 80,
                    angle: 70,
                    insideColor: Colors.teal,
                  ),
                  MessageBubble(
                    width: 160,
                    height: 90,
                    insideColor: Colors.white,
                    borderColor: Colors.grey,
                    tailPosition: 0.65,    // bottom-right area
                    tailAngle: 210,        // points down-left
                    tailLength: 18,
                    radius: 14,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Hello!'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
