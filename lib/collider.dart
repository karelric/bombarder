import 'dart:html';

class Collider {
  double x, y, width, height;

  Collider({this.x = 0, this.y = 0, this.width = 0, this.height = 0});

  bool checkCollition(Collider collider) {
    return x < collider.x + collider.width &&
        x + width > collider.x &&
        y < collider.y + collider.height &&
        height + y > collider.y;
  }
}

extension DrawCollider on CanvasRenderingContext2D {
  void drawCollider(Collider collider) {
    save();
    strokeStyle = '#ff0000';
    strokeRect(collider.x, collider.y, collider.width, collider.height);
    restore();
  }
}
