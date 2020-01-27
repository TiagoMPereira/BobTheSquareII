class Coin {
  PVector local, velocity;
  float space, size, y, speedY, border, speedX;

  Coin(float bh, float sizeY, float coinY, float spX) {
    speedX = spX;
    border = bh;
    speedY = random(0,coinY);
    velocity = new PVector (speedX, speedY);
    size = 15;
    y = random(border+sizeY+size, height - (border+sizeY+size));
    local = new PVector(width, y);
  }

  void display() { //mostra a moeda
    fill(250, 254, 99);
    ellipse(local.x, local.y, size, size);
  }

  void move() { //move a moeda
    local.add(velocity);
    if(local.y>=2*height/3 || local.y<=height/3){
      speedY*=-1;
      velocity.y = speedY;
    }
  }

  void destroy(int i) { //destroi moeda quando ultrapassa a tela
    if (this.local.x+this.size/2 < 0) {
      coin.remove(i);
    }
  }
}
