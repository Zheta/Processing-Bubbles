color GRADIENT_COLOR_1 = color(180, 160, 170);
color GRADIENT_COLOR_2 = color(245, 230, 230);

void display_gradient(int x, int y, float w, float h) {
  noFill();
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(GRADIENT_COLOR_1, GRADIENT_COLOR_2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
}
