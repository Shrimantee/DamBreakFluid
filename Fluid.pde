class Fluid {
  ArrayList<Particle> particles;
  PVector g;
  float dt;
  float h; 
  float k;
  float k_neighbor;
  float density_0;
  Grid grid;
  float depth;
  Fluid(float dt, float h) {
    particles = new ArrayList<Particle>();
    g = new PVector(0, 1, 0);
    g.mult(dt);
    this.dt = dt;
    this.h = h;
    k = 0.004;
    k_neighbor = 0.014;
    density_0 =10;
    depth = width/2;
    grid = new Grid(width, height, depth, h);
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


    float wPressGradient = -45 / (PI * pow(h, 6));
    float wViscLaplacian = -1 * wPressGradient;



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
        PVector dist_ij_ = PVector.sub(p_neighbor.pos, p.pos);
        float dist_ij = dist_ij_.mag();
        float q = dist_ij / h;
        if (q < 1) {
          dist_ij_.normalize();
          PVector D = dist_ij_;
          D.mult( dt * dt * ( p.pressure * (1-q) + p.pressure_neighbor * (1-q) * (1-q) ) );
          D.mult( 0.5 );
          if (!p_neighbor.isBoundary) {
            p_neighbor.pos.add(D);
          }
          p.dx.sub(D);
        }
        PVector dist_ij__vel = PVector.sub(p_neighbor.vel, p.vel);
        float dist_ij_vel = dist_ij__vel.mag();
        q = dist_ij_vel / h;
        if (q<1) {
          dist_ij_.normalize();
          PVector D = dist_ij_;
          D.mult( dt * dt * ( p.pressure * (1-q) + p.pressure_neighbor * (1-q) * (1-q) ) );
          float diff = dist_ij -h;
          float l = diff*wViscLaplacian;
          D.mult( dt * dt * ( p.pressure * (1-q) + p.pressure_neighbor * (1-q) * (1-q) ) );
          D.mult( l );
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


    //collisions

    for (Particle p : particles) {
      if (p.pos.x < 0) p.pos.x = 0;
      if (p.pos.x > width) p.pos.x = width;
      if (p.pos.y < height/4) p.pos.y = height;
      if (p.pos.y > height) p.pos.y = height;
      if (p.pos.z < 0) p.pos.z = 0;
      if (p.pos.z > depth) p.pos.z = depth;
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
