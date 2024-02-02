class Grid {
  Field[] fields;
  int maxX;
  int maxY;
  int maxZ;
  float h;
  
  Grid(float wd, float ht,float dp, float h) {
    this.h = h;
    maxX = ceil(wd/h);
    maxY = ceil(ht/h);
    maxZ = ceil(dp/h);
    fields = new Field[maxX * maxY*maxZ];
    for (int i=0; i<fields.length; i++) {
      fields[i] = new Field();
    }
  }
  
  Field get_Field(float x, float y, float z) {
    int curr_x = floor(x/h);
    int curr_y = floor(y/h);
    int curr_z = floor(z/h);
    if ((curr_x >= 0) && (curr_x < maxX) && (curr_y >= 0) && (curr_y < maxY) && (curr_z>=0) && (curr_z<maxZ)) {
      int index = curr_x*maxY*maxZ + curr_y*maxZ+curr_z;
      return fields[index];
    }
    else {
      return null;
    }
  }
  
  void add_particle(Particle p) {
    for ( int i=-1; i<3; i++ ) {
      for ( int j= -1; j<3; j++) {
        for( int k=-1;k<3; k++){
        float x = p.pos.x + h*float(i);
        float y = p.pos.y + h*float(j);
        float z = p.pos.z + h*float(k);
        Field f = get_Field(x, y,z);
        if (f != null) {
          f.particles.add(p);
        }
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
