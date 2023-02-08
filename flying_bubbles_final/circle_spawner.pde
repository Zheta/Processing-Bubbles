int current_circle = 0;
int current_rate = 1;

void circle_spawner (int rate_min, int rate_max, int limit) {
  if (frameCount % current_rate == 0) {
    if (circles.size() <= limit) {
      circles.add(new Random_Circle());
      current_rate = int(random(rate_min, rate_max));
      //println("current rate =" + current_rate);
    }
  }
}
