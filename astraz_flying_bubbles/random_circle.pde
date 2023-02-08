// size ranges
int SIZE_RANGE_MIN = ((WINDOW_WIDTH + WINDOW_HEIGHT) / 2) / 125;
int SIZE_RANGE_MAX = ((WINDOW_WIDTH + WINDOW_HEIGHT) / 2) / 8;
int SIZE_RANGE_LOWER_MOD = ((WINDOW_WIDTH + WINDOW_HEIGHT) / 2) / 125;

// speed ranges
//float STARTING_SPEED = 0.4;
float SPEED_RANGE_X_MIN = 0.2;
float SPEED_RANGE_X_MAX = 2;
float SPEED_RANGE_Y_MIN = 0.2;
float SPEED_RANGE_Y_MAX = 2;

float VELOCITY_RANGE_MIN = -1.0;
float VELOCITY_RANGE_MAX = 1.0;

float GRAVITY = 9.8 / FRAME_RATE;

// color ranges
int COLOR_RANGE_MIN = 10;
int COLOR_RANGE_MAX = 255;

// spawn position ranges
float START_RANGE_X_MIN = -(WINDOW_WIDTH / 3.0);
float START_RANGE_X_MAX = (WINDOW_WIDTH / 1.4);
float START_RANGE_Y_MIN = -(WINDOW_HEIGHT / 3.0);
float START_RANGE_Y_MAX = (WINDOW_HEIGHT / 1.4);

// ground shadow, def: 
float G_SHADOW_X_OFFSET = 0.0;
float G_SHADOW_Y_OFFSET_MIN = 10.0;
float G_SHADOW_Y_OFFSET_MAX = 80.0;

// ground shadow color
color G_SHADOW_SHADE_MIN = color(210, 200, 220, 10);
color G_SHADOW_SHADE_MAX = color(200, 200, 230, 140);

// circle shadow color
color C_SHADOW_SHADE_MIN = color(6, 0, 4, 20);
color C_SHADOW_SHADE_MAX = color(4, 0, 8, 90);
int C_SHADOW_SHADE_MIN_ALPHA = 20;
int C_SHADOW_SHADE_MAX_ALPHA = 90;

// circle shadow multiplier values
float V1X = 1.781;
float V1Y = 1.625;

float CP21X = 1.618;
float CP21Y = 1.842;
float CP22X = 1.327;
float CP22Y = 2.0;
float V2X = 1.0;
float V2Y = 2.0;

float CP31X = 0.673;
float CP31Y = 2.0;
float CP32X = 0.382;
float CP32Y = 1.842;
float V3X = 0.219;
float V3Y = 1.625;

float CP41X = 0.478;
float CP41Y = 1.801;
float CP42X = 0.771;
float CP42Y = 1.861;
float V4X = 1.0;
float V4Y = 1.864;

float CP51X = 1.229;
float CP51Y = 1.861;
float CP52X = 1.522;
float CP52Y = 1.801;
float V5X = 1.781;
float V5Y = 1.625;


class Random_Circle {
  // generate random color
  color shade = color(random(COLOR_RANGE_MIN, COLOR_RANGE_MAX), random(COLOR_RANGE_MIN, COLOR_RANGE_MAX), random(COLOR_RANGE_MIN, COLOR_RANGE_MAX), 255);
  color c_shadow_shade_min = color(int(red(shade) / 30) + 4, int(green(shade) / 30), int(blue(shade) / 30), C_SHADOW_SHADE_MIN_ALPHA);
  color c_shadow_shade_max = color(int(red(shade) / 30), int(green(shade) / 30), int(blue(shade) / 30) + 4, C_SHADOW_SHADE_MAX_ALPHA);
  
  // generate random size
  float size = random(SIZE_RANGE_MIN, random(SIZE_RANGE_MIN + SIZE_RANGE_LOWER_MOD, SIZE_RANGE_MAX));
  float radius = size / 2;
  float random_mass = random(10, 100);
  
  // initialize starting position at X = 0 and Y = 0
  float x_position = 0;
  float y_position = 0;
  
  // initialize ground shadow position
  float g_shadow_x = 0;
  float g_shadow_y = 0;
  
  // initialize circle object shadow offset
  float c_shadow_x_offset = 0;
  float c_shadow_y_offset = 0;
  
  // initialize speeds
  float x_speed = 0;
  float y_speed = 0;
  float vertical_velocity = 0;
  float s_bounce_velocity = 0;
  
  // initialize timer
  int time_fallen = 0;
  
  // calculate starting shadow shape points
  float v1x_mod = radius * V1X;
  float v1y_mod = radius * V1Y;
  
  float cp21x_mod = radius * CP21X;
  float cp21y_mod = radius * CP21Y;
  float cp22x_mod = radius * CP22X;
  float cp22y_mod = radius * CP22Y;
  float v2x_mod = radius * V2X;
  float v2y_mod = radius * V2Y;
  
  float cp31x_mod = radius * CP31X;
  float cp31y_mod = radius * CP31Y;
  float cp32x_mod = radius * CP32X;
  float cp32y_mod = radius * CP32Y;
  float v3x_mod = radius * V3X;
  float v3y_mod = radius * V3Y;
  
  float cp41x_mod = radius * CP41X;
  float cp41y_mod = radius * CP41Y;
  float cp42x_mod = radius * CP42X;
  float cp42y_mod = radius * CP42Y;
  float v4x_mod = radius * V4X;
  float v4y_mod = radius * V4Y;
  
  float cp51x_mod = radius * CP51X;
  float cp51y_mod = radius * CP51Y;
  float cp52x_mod = radius * CP52X;
  float cp52y_mod = radius * CP52Y;
  float v5x_mod = radius * V5X;
  float v5y_mod = radius * V5Y;
  
  
  // circle spawn functions
  void set_speed() {
    // random speed
    x_speed = random(SPEED_RANGE_X_MIN, SPEED_RANGE_X_MAX);
    y_speed = random(SPEED_RANGE_Y_MIN, SPEED_RANGE_Y_MAX);
  }
  
  void set_vertical_velocity() {
    vertical_velocity = random(VELOCITY_RANGE_MIN, VELOCITY_RANGE_MAX);
  }

  void set_shadows() {
    // calculate starting ground shadow position
    g_shadow_x = x_position + G_SHADOW_X_OFFSET;
    g_shadow_y = y_position + random(G_SHADOW_Y_OFFSET_MIN, G_SHADOW_Y_OFFSET_MAX) + size;
    
    // calculate starting circle shadow position
    c_shadow_x_offset = x_position - radius;
    c_shadow_y_offset = y_position - radius;
  }
  
  // init
  Random_Circle () {
    // set starting position out of frame (and then far enough to hide shadow pop in)
    x_position -= radius + (SIZE_RANGE_MAX * 2);
    y_position -= radius + (SIZE_RANGE_MAX * 2);
    
    // 50/50 chance of circle spawning along X or Y
    //if (int(random(0, 2)) == 0) {
    //  x_position += random(START_RANGE_X_MIN, START_RANGE_X_MAX);
    //}
    //else {
    //  y_position += random(START_RANGE_Y_MIN, START_RANGE_Y_MAX);
    //}

    set_speed();
    set_vertical_velocity();
    set_shadows();
  }
  
  
  Random_Circle (float x_value, float y_value) {
    // set starting position
    x_position = x_value;
    y_position = y_value;

    set_speed();
    set_vertical_velocity();
    set_shadows();
  }
    
  
  // move circle
  void move() {
    mod_velocity();
    y_position += y_speed + vertical_velocity;
    x_position += x_speed;
    c_shadow_y_offset += y_speed + vertical_velocity;
    c_shadow_x_offset += x_speed;    
    g_shadow_y += y_speed;
    g_shadow_x = x_position - 0.1 * (g_shadow_y - (y_position + radius));
    
  }
  
  
  void mod_velocity() {
    if (y_position + radius >= g_shadow_y) {
      vertical_velocity = -1 - (0.01 * random_mass);
      time_fallen = 0;
      return;
    }
    vertical_velocity += 0.01 * ((GRAVITY * time_fallen) / random_mass);
    time_fallen += 1;
  }

  
  // draw ground shadow
  void display_g_shadow() {
    blendMode(MULTIPLY);
    noStroke();
    fill(lerpColor(G_SHADOW_SHADE_MAX, G_SHADOW_SHADE_MIN, norm((g_shadow_y - (y_position + radius)), 0, 150)));
    
    ellipseMode(CENTER);
    ellipse(g_shadow_x, g_shadow_y, lerp(size, size / 2, norm((g_shadow_y - (y_position + radius)), 0, 150)), lerp(radius, radius / 2, norm((g_shadow_y - (y_position + radius)), 0, 150)));
    
    //ellipse(g_shadow_x, g_shadow_y, size - max((size / 2), (g_shadow_y - ( (y_position + radius)))) , radius);
  }
  
  
  // draw circle
  void display() {
    blendMode(BLEND);
    //stroke(10);
    noStroke();
    fill(shade);
    ellipse(x_position, y_position, size, size);
  }
  
  
  // draw circle shadow
  void display_c_shadow() {
    noStroke();
    fill(lerpColor(c_shadow_shade_max, c_shadow_shade_min, norm((g_shadow_y - (y_position + radius)), -10, 200)));
    
    beginShape();
    vertex(c_shadow_x_offset + v1x_mod, c_shadow_y_offset + v1y_mod);
    bezierVertex(
    c_shadow_x_offset + cp21x_mod, c_shadow_y_offset + cp21y_mod,
    c_shadow_x_offset + cp22x_mod, c_shadow_y_offset + cp22y_mod,
    c_shadow_x_offset + v2x_mod, c_shadow_y_offset + v2y_mod
    );
    bezierVertex(
    c_shadow_x_offset + cp31x_mod, c_shadow_y_offset + cp31y_mod,
    c_shadow_x_offset + cp32x_mod, c_shadow_y_offset + cp32y_mod,
    c_shadow_x_offset + v3x_mod, c_shadow_y_offset + v3y_mod
    );
    bezierVertex(
    c_shadow_x_offset + cp41x_mod, c_shadow_y_offset + cp41y_mod,
    c_shadow_x_offset + cp42x_mod, c_shadow_y_offset + cp42y_mod,
    c_shadow_x_offset + v4x_mod, c_shadow_y_offset + v4y_mod
    );
    bezierVertex(
    c_shadow_x_offset + cp51x_mod, c_shadow_y_offset + cp51y_mod,
    c_shadow_x_offset + cp52x_mod, c_shadow_y_offset + cp52y_mod,
    c_shadow_x_offset + v5x_mod, c_shadow_y_offset + v5y_mod
    );
    endShape();
  }
  
  // check if offscreen
  boolean offscreen() {
    if (x_position >= WINDOW_WIDTH + (WINDOW_WIDTH * 0.4)) {
      return true;
    }
    else if (y_position >= WINDOW_HEIGHT + (WINDOW_HEIGHT * 0.4)) {
      return true;
    }
    else {
      return false;
    }
  }
}
