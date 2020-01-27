class Wall {

  PVector local, velocity;
  float r,x,y, speedX;
  boolean checked;
  float coinY;

  Wall(float sizeY,int bh, float spX) {
    speedX = spX;
    r = random(1, 2);
    x = 50;
    y = random(100, sizeY);
    
    if (r<=1.5){
      local = new PVector(width, bh);
      coinY = bh+y+30;
    }
    else{
      local = new PVector(width, height-(bh+y));
      coinY = height-(bh+y+30);
    }
    velocity = new PVector(speedX, 0);
    checked = false;    
  }

  void display() { //mostrando paredes
    fill(200,200,250);
    if (r<=1.5) {
      rectMode(LEFT);
      rect(local.x, local.y, local.x+x, local.y+y);
    } else {
      rectMode(LEFT);
      rect(local.x, local.y, local.x+x, local.y+y);
    }
  }
  
  void move(){ //movendo paredes
    local.add(velocity);
  }
  
  void destroy(int i){ //destruindo paredes quando ultrapassarem a tela
    if(this.local.x+this.x < 0){
      wall.remove(i);
    }
  }
}
