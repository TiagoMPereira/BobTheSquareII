class Bob {

  PVector local, velocity;
  int size;

  Bob() {
    local = new PVector (400, 250);
    velocity = new PVector(0, 3.5);
    size = 30;
  }

  void display() { //mostrando Bob
    fill(0, 69, 94);
    noStroke();
    rectMode(CENTER);
    rect(local.x, local.y, size, size);
  }

  void move() { //movendo Bob
    if (local.y-size/2>15 && local.y+size/2<height-15)
      local.add(velocity);
  }

  boolean colision(Wall wall) { //colisão com parede
    if ((this.local.x+this.size/2 >= wall.local.x && this.local.x-this.size/2 <= wall.local.x+wall.x && this.local.y-size/2>0 && this.local.y-size/2<15+wall.y && wall.r<=1.5)
      || (this.local.x+this.size/2 >= wall.local.x && this.local.x-this.size/2 <= wall.local.x+wall.x && this.local.y+size/2<height && this.local.y+size/2>height-(15+wall.y) && wall.r>1.5)) {
      return true;
    } else {
      return false;
    }
  }

  boolean pass(Wall wall) { //passar pela parede
    if (this.local.x+this.size/2 > wall.local.x+wall.x && wall.checked == false) {
      wall.checked = true;
      return true;
    } else
      return false;
  }

  boolean colideBorder(int bh) { //colisão com borda
    if (local.y-size/2<= bh|| local.y+size/2>=height-bh)
      return true;
    else
      return false;
  }

  boolean colisionStone(Stone st) { //colisão com pedra
    if (dist(this.local.x, this.local.y, st.local.x, st.local.y)<sqrt(2*(size/2)*(size/2))+st.r/2) {
      return true;
    } else {
      return false;
    }
  }

  boolean colisionCoin(Coin coin) { //colisão com moeda
    if (dist(this.local.x, this.local.y, coin.local.x, coin.local.y)<sqrt(2*(size/2)*(size/2))+coin.size/2) {
      return true;
    }
    return false;
  }
}
