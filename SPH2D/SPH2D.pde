/*References :
 
 Clavet et al (2005): “Particle-based Viscoelastic Fluid Simulation”
 
 Jančík P., Hyhlík T. (2018) : “Simulation of a 2D dam break problem using SPH method”
 */

Fluid fluid;
float kernel_radius = 8;
float dt = 2;
float steps = 2;

void setup() {
  size(1000, 800, P3D);
  //fullScreen();
  colorMode(HSB);

  fluid = new Fluid(dt, kernel_radius);


  steps = 1;
  dt = 1;
  for (float x = width * 0.25; x<width*0.8; x+=kernel_radius*0.25) {
    for (float y = height * 0.7; y<(height * 0.9); y+=kernel_radius*0.25) {
      //for (float z = height * 0.2; z<100; z+=kernel_radius*0.25)

      fluid.particles.add(new Particle(x, y, 0, false));
    }
  }
  for (float x=0; x < width; x+= kernel_radius * 0.1) {
    fluid.particles.add(new Particle(x, height, 0, true));
  }
  for (float y=0; y < height; y+= kernel_radius * 0.1) {
    fluid.particles.add(new Particle(0, y, 0, true));
    fluid.particles.add(new Particle(width, y, 0, true));
  }    
  for (float y = 0; y < height; y+=kernel_radius*0.1) {
    float z = 0;
    fluid.particles.add(new Particle(width*0.2, y, z, true));
    fluid.particles.add(new Particle(width*0.2 + kernel_radius * 0.1, y, z, true));
    fluid.particles.add(new Particle(width*0.9, y, z, true));
    fluid.particles.add(new Particle(width*0.9 + kernel_radius * 0.1, y, z, true));
  }

  println(fluid.particles.size());
}

void draw() {
  background(20);
  lights();
  ambientLight(15, 255, 255);

  //rotateX(mouseY);
  //rotateY(mouseX);
  if (mousePressed) {
    for (int i=1; i<30; i++) {
      fluid.particles.add(new Particle(mouseX + random(kernel_radius), mouseY + random(kernel_radius), 0, false));
    }
  }


  for (int i=0; i<steps; i++) {
    fluid.step();
  }

  fluid.render();
  saveFrame("frames/######.tiff");
}
