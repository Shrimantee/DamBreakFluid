class Particle {
  PVector pos;
  PVector vel;
  PVector pos_prev;
  ArrayList<Particle> neighbors;
  float density;
  float density_neighbor;
  float pressure;
  float pressure_neighbor;
  PVector dx;
  boolean isBoundary;


  Particle(float x, float y,float z, boolean r) {
    pos = new PVector(x, y,z);
    vel = new PVector();
    neighbors = new ArrayList<Particle>();
    density = 0;
    density_neighbor = 0;
    dx = new PVector(0, 0);
    isBoundary = r;
  }

  void render() {

    translate(pos.x, pos.y,pos.z);

    noStroke();

    if(!isBoundary){
      fill(175 + pressure*1000, 255, 255,80+pressure*1000);
    box(5);

    }
    else{
      fill(150, 255, 255);
      box(15);
    }

    translate(-pos.x, -pos.y,-pos.z);

  }

  void find_neighbors(Grid g) {
    Field f = g.get_Field(pos.x, pos.y);
    if (f != null) {
      neighbors = f.particles;
    }
  }
}
