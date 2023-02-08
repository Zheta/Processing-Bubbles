int WINDOW_WIDTH = 1200;
int WINDOW_HEIGHT = 900;

int FRAME_RATE = 60;

int SPAWN_RATE_MIN = 5;
int SPAWN_RATE_MAX = 15;
int MAX_CIRCLES = 300;

int STARTING_CIRCLES = 160;
int STARTING_RANGE_X_MIN = -400;
int STARTING_RANGE_X_MAX = WINDOW_WIDTH + 20;
int STARTING_RANGE_Y_MIN = -400;
int STARTING_RANGE_Y_MAX = WINDOW_HEIGHT + 20;

// set false to stop the playback loop on launch
boolean RUN = true;

// set true to make the project clickable to pause/play on any frame 
boolean CLICKABLE = false;

// saves out a bunch of frames for a video (SLOW)
boolean MOVIE_MODE = false;


boolean clicked = false;

// create circle array with 0 entries
ArrayList<Random_Circle> circles = new ArrayList<Random_Circle>(300);

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup() {
  frameRate(FRAME_RATE);
  
  // spawn initial circles
  for (int i = 0; i < STARTING_CIRCLES; i = i + 1) {
    circles.add(new Random_Circle(random(STARTING_RANGE_X_MIN, STARTING_RANGE_X_MAX), random(STARTING_RANGE_Y_MIN, STARTING_RANGE_Y_MAX)));
  }
  
  if (RUN == false) {
    noLoop();
  }
}

// main loop
void draw() {
  display_gradient(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
  
  // spawn circles
  circle_spawner(SPAWN_RATE_MIN, SPAWN_RATE_MAX, MAX_CIRCLES);
  println(circles.size());

  // delete offscreen circles
  for (int i = circles.size() - 1; i >= 0; i--) {
    Random_Circle circle_id = circles.get(i);
    if (circle_id.offscreen()) {
      circles.remove(i);
    }
  }

  // move and display shadows for  all spawned circles
  for (Random_Circle circle_id : circles) {
    circle_id.move();
    circle_id.display_g_shadow();
  }
  
  // display bodies for all spawned circles
  for (Random_Circle circle_id : circles) {
    circle_id.display();
    circle_id.display_c_shadow();
  }
  
  if (MOVIE_MODE == true) {
  // save images for video file
    saveFrame();
  }
}

void mouseClicked() {
  if (CLICKABLE == true) {
    if (clicked == true) {
      loop();
      clicked = false;
    }
    else {
      noLoop();
      clicked = true;
    }
  }
}
