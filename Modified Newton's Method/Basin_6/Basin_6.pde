class Complex{
    public float real,img;
    public Complex(float a,float b){
        real = a;
        img = b;
    }
    void num_mul(float x){ this.real *= x; this.img *= x; }
    Complex add(Complex x){ return new Complex(this.real+x.real,this.img+x.img); }
    Complex minus(Complex x){ return new Complex(this.real-x.real,this.img-x.img); }
    Complex product(Complex x){ return new Complex(this.real*x.real-this.img*x.img,this.img*x.real+this.real*x.img); }
    Complex divide(Complex x){
      float mod2 = x.real*x.real+x.img*x.img;
      Complex p = x; p.img *= -1;
      Complex t = this.product(p);
      t.real /= mod2;
      t.img /= mod2;
      return t;
    }
    float MOD(){ return sqrt(this.real*this.real+this.img*this.img); }
};

final int maxIterations = 100;
final float inf = 3500 , range = 2;

Complex N(Complex z){
  Complex z4 = z.product(z.product(z.product(z)));
  z4.real += 3.0;
  Complex x = z;
  x.num_mul(4.0);
  return x.divide(z4);
}

final Complex root1 = new Complex(1.0,0.0), //green
              root2 = new Complex(-1.0,0.0), // red
              root3 = new Complex(0,1.0), //blue
              root4 = new Complex(0,-1.0); //cyan

final float epsilon = 0.01;
        
boolean closeTo(Complex a,Complex b){
  float d = a.minus(b).MOD();
  return (d<=epsilon);
}

float Distance(Complex a,Complex b){
   Complex c = a.minus(b);
   return c.MOD();
}

void setup(){
  int bright = 0;
  
  size(650,650);
  surface.setTitle("Complex Fractals");
  surface.setResizable(false);
  
  colorMode(RGB, 1);
  pixelDensity(1);
  
  loadPixels();
  
  int t = millis();
  
  for(int i=0;i<650;i++){
    for(int j=0;j<650;j++){
      float a = map(i,0,650,-range,range),
            b = map(j,0,650,range,-range);
      Complex c2 = new Complex(a,b);
      int n = 0;
      boolean x = false, y = false, z = false, o = false;
      for(;n<maxIterations;n++){
         c2 = N(c2);
         if(closeTo(c2,root1)){
           x = true;
           break;
         }
         if(closeTo(c2,root2)){
           y = true;
           break;
         }
         if(closeTo(c2,root3)){
           z = true;
           break;
         }
         if(closeTo(c2,root4)){
           o = true;
           break;
         }
      }
      
      if(x) bright = color(0,255,0);
      else if(y) bright = color(255,0,0);
      else if(z) bright = color(0,0,255);
      else if(o) bright = color(0,255,255);

      pixels[i+j*650] = bright;
    }
  }
  
  int p = millis();
  println("Time required =",p-t,"ms");
  
  updatePixels();
  save("./Basin6.png");
}
