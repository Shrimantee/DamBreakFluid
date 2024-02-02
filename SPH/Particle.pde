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
      float hue = 145+pressure*100;
      float alph=170-pressure*100;
      if(pos.y<height/2.5)
      alph = 80;
      fill(hue, 255,255, alph);
    sphere(7);
    

    }
    else{
      fill(180, 255, 255);
    box(25);

    }

    translate(-pos.x, -pos.y,-pos.z);



  }


  void find_neighbors(Grid g) {
    Field f = g.get_Field(pos.x, pos.y,pos.z);
    if (f != null) {
      neighbors = f.particles;
    }
  }
}
