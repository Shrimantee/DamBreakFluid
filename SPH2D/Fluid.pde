class Fluid {
  ArrayList<Particle> particles;
  PVector g;
  float dt;
  float h; // kernel radius for each particle
  float k;
  float k_neighbor;
  float density_0;
  Grid grid;

  Fluid(float dt, float h) {
    particles = new ArrayList<Particle>();
    g = new PVector(0, 0.01,0);
    g.mult(dt);
    this.dt = dt;
    this.h = h;
    k = 0.01;
    k_neighbor = 0.01;
    density_0 = 10;
    grid = new Grid(width, height, h);
  }

  void step() {
// Euler Integration
    grid.clear_grid();

    for (Particle p : particles) {
      if (!p.isBoundary) {
        p.vel.add(g);
      }
          p.pos_prev = p.pos.copy();
      p.pos.add(PVector.mult(p.vel, dt));
      grid.add_particle(p);
    }


    for (Particle p : particles) {
      p.find_neighbors(grid); 
      p.density = 0;
      p.density_neighbor = 0;

      for (Particle p_neighbor : p.neighbors) {
        if ((p_neighbor != p) ) {
          PVector dist_ij_ = PVector.sub(p_neighbor.pos, p.pos);
          float dist_ij = dist_ij_.mag();
          float q = dist_ij / h;
          if (q < 1) {
            float temp = 1-q;
            float pow = temp * temp;
            p.density += pow;
            pow *= temp;
            p.density_neighbor += pow;
          }
        }
      }

      p.pressure = k*(p.density - density_0);
      p.pressure_neighbor = k_neighbor * p.density_neighbor;

      p.dx.mult(0);
      for (Particle p_neighbor : p.neighbors) {
        PVector dist_ij_vec = PVector.sub(p_neighbor.pos, p.pos);
        float dist_ij = dist_ij_vec.mag();
        float q = dist_ij / h;
        if (q < 1) {
          dist_ij_vec.normalize();
          PVector D = dist_ij_vec;
          D.mult( dt * dt * ( p.pressure * (1-q) + p.pressure_neighbor * (1-q) * (1-q) ) );
          D.mult( 0.5 );
          if (!p_neighbor.isBoundary) {
            p_neighbor.pos.add(D);
          }
          p.dx.sub(D);
        }
      } 
      if (!p.isBoundary) {
        p.pos.add(p.dx);
      }
    } 
    for (Particle p : particles) {
      if (p.pos.x < 0) p.pos.x = 0;
      if (p.pos.x > width) p.pos.x = width;
      if (p.pos.y < 0) p.pos.y = 0;
      if (p.pos.y > height) p.pos.y = height;
    }

    for (Particle p : particles) {
      p.vel = PVector.sub(p.pos, p.pos_prev);
      p.vel.div(dt);
    }
  }

  void render() {
    for (Particle p : particles) {
      p.render();
    }
  }
}
