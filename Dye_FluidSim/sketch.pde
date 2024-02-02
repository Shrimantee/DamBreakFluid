import processing.sound.*;
import controlP5.*;
import ddf.minim.*;

final int N = 300;
final int iter = 16;
final int SCALE =4;
float t=0;
Fluid fluid;
float theta;
Amplitude amp;
AudioIn in;
SoundFile file;

void settings() {
  size(N*SCALE, N*SCALE);
}
void setup() {

  fluid = new Fluid(0.4, 0, 0.000001);
  file = new SoundFile(this, "music.mp3");

  amp = new Amplitude(this); //creates a new Amplitude object
  in = new AudioIn(this, 0);
  in.start(); 
  //file.play(); 
  amp.input(in);
}
void mouseDragged(){
  int cx= mouseX/SCALE;
  int cy =mouseY/SCALE;
  //fluid.addDensity(,100);
  for (int i=-1; i<1; i++) {
    for (int j=-1; j<1; j++) {
      fluid.addDensity(cx+i, cy+j, random(100, 500));
    }
  }
  for(int i=0;i<2;i++){
  float angle=noise(t)*TWO_PI*2;
  PVector v=PVector.fromAngle(angle);
  v.mult(5);
  t+=0.1;
  //float amtX=map(noise(t),0,1,-1,1);
  //float amtY=map(noise(t+1000),0,1,-1,1);

  fluid.addVelocity(cx, cy, v.x, v.y);
  }
}
void draw() {
  background(0);
  
  //float a = ((amp.analyze()*4000) / (float) width) * 90f;
  //theta = radians(a);
  //int cx= int(a*width/SCALE);
  //int cy =int(0.5*height/SCALE);
  //for (int i=-1; i<1; i++) {
  //  for (int j=-1; j<1; j++) {
  //    fluid.addDensity(cx+i, cy+j, 500*a);
  //  }
  //}
  //for(int i=0;i<2;i++){
  //float angle=noise(t)*TWO_PI*2;
  //PVector v=PVector.fromAngle(angle);
  //v.mult((a*2));
  //t+=0.1;
  ////float amtX=map(noise(t),0,1,-1,1);
  ////float amtY=map(noise(t+1000),0,1,-1,1);

  //fluid.addVelocity(cx, cy, v.x, v.y);
  //}
  fluid.step();
  fluid.renderDensity();
  fluid.fadeDensity();
  saveFrame("frames/######.tiff");

}
