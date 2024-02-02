/*References :
 
 Clavet et al (2005): “Particle-based Viscoelastic Fluid Simulation”
 
 Jančík P., Hyhlík T. (2018) : “Simulation of a 2D dam break problem using SPH method”
 */


import peasy.*;

PeasyCam cam;
Fluid fluid;
float kernel_radius = 45; 
float dt = 1;

float steps = 2;

float depth = width/2;

void setup() {
  size(1000, 800, P3D);
  //fullScreen();
  colorMode(HSB);

  fluid = new Fluid(dt, kernel_radius);
  cam = new PeasyCam(this, width/2, height/2, 0, 5000);
  cam.setMinimumDistance(1500);
  cam.setMaximumDistance(2000);
  cam.setYawRotationMode();   


  for (float x = width/2; x<width; x+=kernel_radius*0.25) {
    for (float y = height*0.4; y<(height); y+=kernel_radius*0.25) {
      for (float z = 100; z<200; z+=kernel_radius*0.1)

        fluid.particles.add(new Particle(x, y, z, false));
    }
  }
  for (float x=0; x < width; x+= kernel_radius * 0.1) {
    for (float z = 0; z<width; z+=kernel_radius*0.1)

      fluid.particles.add(new Particle(x, height, z, true));
  }
  for (float y=0; y < height; y+= kernel_radius * 0.1) {
    fluid.particles.add(new Particle(0, y, 0, true));
    fluid.particles.add(new Particle(width, y, 0, true));
    fluid.particles.add(new Particle(0, y, 500, true));

    fluid.particles.add(new Particle(width, y, 500, true));
  }

  println(fluid.particles.size());
}

void draw() {
  background(255);
  lights();
  //ambientLight(100, 255, 255);

  //rotateX(mouseY);
  //rotateY(-PI/8);
  if (mousePressed) {
    for (int i=1; i<25; i++) {
      fluid.particles.add(new Particle(mouseX + random(kernel_radius), mouseY + random(kernel_radius), depth/3+random(kernel_radius), false));
    }
  }


  for (int i=0; i<steps; i++) {
    fluid.step();
  }

  fluid.render();
  saveFrame("frames/######.tiff");
}
