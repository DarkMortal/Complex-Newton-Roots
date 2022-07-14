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
final float inf = 20 , range = 2;

Complex N(Complex z){
  Complex z2 = z.product(z);
  Complex z3 = z.product(z2);
  z3.num_mul(2.0);
  z2.num_mul(3.0);
  z2.real -= 1;
  return z3.divide(z2);
}

final Complex root1 = new Complex(0,0), //blue
              root2 = new Complex(1,0), //green
              root3 = new Complex(-1,0); //red

final float epsilon = 0.1;
        
boolean closeTo(Complex a,Complex b){
  float d = a.minus(b).MOD();
  return (d<=epsilon);
}

float Distance(Complex a,Complex b){
   Complex c = a.minus(b);
   return c.MOD();
}

void setup(){
  float val = 0;
  
  size(650,650);
  surface.setTitle("Complex Fractals");
  surface.setResizable(false);
  
  colorMode(HSB, 360,100,100);
  pixelDensity(1);
  
  loadPixels();
  
  int t = millis();
  
  for(int i=0;i<650;i++){
    for(int j=0;j<650;j++){
      float a = map(i,0,900,-0.55,-0.4),
            b = map(j,0,130,-0.05,-0.03);
      Complex c2 = new Complex(a,b);
      int n = 0;
      boolean x = false, y = false, z = false;
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
      }
      
      if(x) val = map(n,0,maxIterations,227,213)*float(maxIterations-n)/float(maxIterations); //blue
      else if(y) val = map(n,0,maxIterations,100,138); //green
      else if(z) val = map(n,0,maxIterations,255,300)*(float(n)/float(maxIterations)); //red

      pixels[i+j*650] = color(val,92,88);
    }
  }
  
  int p = millis();
  println("Time required =",p-t,"ms");
  
  updatePixels();
  save("./Basin3.png");
}
