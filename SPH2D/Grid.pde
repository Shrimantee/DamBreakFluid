class Grid {
  Field[] fields;
  int maxX;
  int maxY;
  float h;
  
  Grid(float wd, float ht, float h) {
    this.h = h;
    maxX = ceil(wd/h);
    maxY = ceil(ht/h);
    fields = new Field[maxX * maxY];
    for (int i=0; i<fields.length; i++) {
      fields[i] = new Field();
    }
  }
  
  Field get_Field(float x, float y) {
    int curr_x = floor(x/h);
    int curr_y = floor(y/h);
    if ((curr_x >= 0) && (curr_x < maxX) && (curr_y >= 0) && (curr_y < maxY)) {
      int index = curr_x*maxY + curr_y;
      return fields[index];
    }
    else {
      return null;
    }
  }
  
  void add_particle(Particle p) {
    for ( int i=-1; i<2; i++ ) {
      for ( int j= -1; j<2; j++) {
        float x = p.pos.x + h*float(i);
        float y = p.pos.y + h*float(j);
        Field f = get_Field(x, y);
        if (f != null) {
          f.particles.add(p);
        }
      }
    }
  }
  
  void clear_grid() {
    for (Field f:fields) {
      f.particles.clear();
    }
  }
}

class Field {
  ArrayList<Particle> particles;
  
  Field() {
    particles = new ArrayList<Particle>();
  }
}
