
import 'package:material_ui/material_ui.dart';

class RPSCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(10, 13);
    path.cubicTo(10, 8.58172, 13.5817, 5, 18, 5);
    path.lineTo(size.width - 18, 5); // Dynamically adjusted width
    path.cubicTo(
        size.width - 13.5817, 5, size.width - 10, 8.58172, size.width - 10, 13);
    path.lineTo(size.width - 10, 167.734);
    path.cubicTo(size.width - 10, 168.05, size.width - 10.26, 168.303,
        size.width - 10.576, 168.303);
    path.cubicTo(size.width - 23.613, 168.303, size.width - 34.183, 179.303,
        size.width - 34.183, 192.873);
    path.cubicTo(size.width - 34.183, 206.443, size.width - 23.613, 217.444,
        size.width - 10.576, 217.444);
    path.cubicTo(size.width - 10.26, 217.444, size.width - 10, 217.697,
        size.width - 10, 218.012);
    path.lineTo(
      size.width - 10,
      size.height - 8,
    );
    path.cubicTo(size.width - 10, size.height - 3.582, size.width - 13.582,
        size.height, size.width - 18, size.height);
    path.lineTo(18, size.height);
    path.cubicTo(
        13.582, size.height, 10, size.height - 3.582, 10, size.height - 8);
    path.lineTo(10, 218.012);
    path.cubicTo(10, 217.696, 10.26, 217.444, 10.576, 217.444);
    path.cubicTo(23.614, 217.444, 34.184, 206.443, 34.184, 192.873);
    path.cubicTo(34.184, 179.303, 23.614, 168.303, 10.576, 168.303);
    path.cubicTo(10.26, 168.303, 10, 168.05, 10, 167.734);
    path.lineTo(10, 13);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
