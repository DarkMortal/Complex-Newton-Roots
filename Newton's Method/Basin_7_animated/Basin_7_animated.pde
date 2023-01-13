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
final float range = 2;

float factorX = 0, factorY = 0;
float startX = -range, startY = -range, endX = range, endY = range;

Complex N(Complex z){
  Complex z4 = z.product(z.product(z.product(z)));
  Complex z5 = z.product(z4);
  z4.num_mul(5.0);
  z5.num_mul(4.0);
  z4.real -= 1.0;
  return z5.divide(z4);
}

final Complex root1 = new Complex(0,0), //green
              root2 = new Complex(1.0,0), //blue
              root3 = new Complex(-1.0,0), //red
              root4 = new Complex(0,1.0), //yellow
              root5 = new Complex(0,-1.0); //pink

final float epsilon = 0.001;
        
boolean closeTo(Complex a,Complex b){
  float d = a.minus(b).MOD();
  return (d<=epsilon);
}

float Distance(Complex a,Complex b){
   Complex c = a.minus(b);
   return c.MOD();
}

void drawPlane(){
  float val = 0;
  loadPixels();
  
  for(int i=0;i<650;i++){
    for(int j=0;j<650;j++){
      float a = map(i,0+factorX,650+factorX,startX+factorX,endX+factorX),
            b = map(j,0+factorY,650+factorY,startY+factorY,endY+factorY);
      Complex c2 = new Complex(a,b);
      int n = 0;
      boolean x = false, y = false, z = false, p = false, q = false;
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
           p = true;
           break;
         }
         if(closeTo(c2,root5)){
           q = true;
           break;
         }
      }
            
      if(x) val = map(n,0,maxIterations,100,138); //green
      else if(y) val = map(n,0,maxIterations,227,213)*float(maxIterations-n)/float(maxIterations); //blue
      else if(z) val = map(n,0,maxIterations,255,300)*(float(n)/float(maxIterations)); //red
      else if(p) val = map(n,0,maxIterations,55,68)*float(maxIterations-n)/float(maxIterations); //yellow
      else if(q) val = map(n,0,maxIterations,295,310)*float(maxIterations-n)/float(maxIterations); //pink
      
      pixels[i+j*650] = color(val,92,88);
    }
  }

  updatePixels();
}

boolean mouseLocked = false;

void mousePressed() { mouseLocked = true; }
void mouseReleased() { mouseLocked = false; }

void mouseDragged() {
  if(mouseLocked) {
    float bx = pmouseX-mouseX;
    float by = pmouseY-mouseY;
    
    factorX += bx/100.0;
    factorY += by/100.0;
    
    //startX += bx; startY += by;
    //endX -= bx; endY -= by;
  }
}

void setup(){    
  size(650,650);
  surface.setTitle("Complex Fractals");
  surface.setResizable(false);
  
  colorMode(HSB, 360,100,100);
  pixelDensity(1);
  
  //drawPlane();
  
  //save("./Basin7.png");
}

void draw(){
  clear();
  drawPlane();
}

void keyReleased() {
  if (key == 's' || key == 'S') save("./IMG.png");
}
