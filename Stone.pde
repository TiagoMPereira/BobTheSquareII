class Stone{
  
  PVector local, velocity;
  float y, r, speed, speedX;
  int cor;
  
  Stone(float i, float slowSpeed, float spX){
    speedX = spX;
    y = random(100, height-100);
    local = new PVector (width, y);
    speed = map(i,0.5,2,8,4);
    speed = speed*speedX/slowSpeed;
    velocity = new PVector (speed, 0);
    r = random (i*20, i*30);
    cor = int(random(100,200));
  }
  
  void display(){ //mostra pedra
    fill(cor,0,0);
    circle(local.x,local.y,r);
  }
  
  void move(){ //move pedra
    local.sub(velocity);
  }
  
}
