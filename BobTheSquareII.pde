//ArrayList dos objetos utilizados
ArrayList<Wall> wall = new ArrayList<Wall>();
ArrayList<Coin> coin = new ArrayList<Coin>();
ArrayList<Stone> sStone = new ArrayList<Stone>();
ArrayList<Stone> bStone = new ArrayList<Stone>();

//jogador
Bob b = new Bob();

//variaveis booleanas de controle 
boolean game; //controle do jogo
boolean colide; //controle das colisões
boolean levelChange; //controle da troca de niveis
boolean increaseDifficulty; //controle da adição de obstáculos
boolean smallStone; //controle do lançamento de pequenas pedras
boolean bigStone; //controle do lançamento de grandes pedras
boolean fireBorder; //controle da borda flamejante
boolean colideBorder; //controle de colisões com a borda
boolean colideCoin; //controle de colisões com moedas

float s, ss, sb, sc; //contadores de segundos
float sizeY;
float coinY;
float stoneSlowSpeed;
float speedX;
float speedSX;
float scoreLevel;

int time;
int score;
int match;
int level;
int borderHeight;
int r, g, bl;
int scoreCoin;

void setup() {
  size(800, 500); //tamanho da tela
  game = false;
  s = 0;
  colide = false;
  match = 0;
  borderHeight = 15;
  scoreLevel = 8;

  r = 0;
  g = 69;
  bl = 94;
}

void mousePressed() {
  if (!game) {
    score = 0;
    if (match!=0) {
      for (int i=wall.size()-1; i>=0; i--) {
        wall.remove(i);
        println(i);
      }
    }
    b.local.x = width/2;
    b.local.y = height/2;

    smallStone = false;
    bigStone = false;
    fireBorder = false;
    colideBorder = false;
    colideCoin = false;
    levelChange = true;
    increaseDifficulty = false;

    time = 3;
    borderHeight = 15;
    match++;

    r = 0;
    g = 69;
    bl = 94;

    level = 0;
    coinY = 0;
    scoreCoin = 0;
    s = ss = sb = sc = 0;
    sizeY = 150;
    stoneSlowSpeed = 1;
    speedX = -3;
    speedSX = 1;
    b.velocity.y = 3.5;

    game = true;
  }
}

void keyPressed() {
  if (keyCode == 32) { //trocar orientação do movimento
    changeDirection();
    if (b.local.y-b.size/2 <= 15 || b.local.y+b.size/2 >= height-15) {
      b.local.add(b.velocity);
    }
  }
}

void changeDirection() {
  b.velocity.y *= -1;
}

void firstScene() { //cena inicial
  textAlign(CENTER);
  textSize(30);
  fill(200);
  text("TAP TO PLAY", width/2, height/2+45);
}

void gameOver() {

  // removendo objetos restantes
  for (int i=0; i<wall.size(); i++) {
    wall.remove(i);
  }
  for (int i=0; i<sStone.size(); i++) {
    sStone.remove(i);
  }
  for (int i=0; i<bStone.size(); i++) {
    bStone.remove(i);
  }
  for (int i=0; i<coin.size(); i++) {
    coin.remove(i);
  }
  //reorientanto o quadrado ao centro
  b.local.x = width/2;
  b.local.y = height/2;

  textAlign(CENTER);
  textSize(30);
  fill(200);
  text("GAME OVER", width/2, height/2+45);
  textSize(15);
  text("SCORE: "+score, width/2, height/2+75);
  text("R$: "+scoreCoin, width/2, height/2+100);

  colide = false;
  println(second()+" "+wall.size()+" "+sStone.size()+" "+bStone.size()+" "+coin.size()+" ");
}

void margin() { //desenhando bordas
  fill(r, g, bl);
  rectMode(LEFT);
  rect(0, 0, width, borderHeight);
  rect(0, height-borderHeight, width, height);
}

void buildWall() { //construindo paredes
  wall.add(new Wall(sizeY, borderHeight, speedX));
}

void wallController() { //controlando paredes
  if (wall.size()>0) {
    for (int i=0; i<wall.size(); i++) {
      wall.get(i).display(); //mostrando parede
      wall.get(i).move(); //movendo parede
      colide = b.colision(wall.get(i)); //verificando colisões 
      if (!colide && b.pass(wall.get(i)))
        score++; //ponto
      wall.get(i).destroy(i);
    }
  }
  if (colide) { //fim de jogo
    game = false;
  }
}

void createCoin() { //criando moedas
  coin.add(new Coin(borderHeight, sizeY, coinY, speedX));
}

void coinController() { //controlando moedas
  if (coin.size()>0) {
    for (int i=0; i<coin.size(); i++) {
      coin.get(i).display();
      coin.get(i).move();
      colideCoin = b.colisionCoin(coin.get(i)); //verificando colisões
      if (colideCoin) {
        score++;
        scoreCoin++;
        coin.remove(i);
      } else {
        coin.get(i).destroy(i);
      }
    }
  }
}

void checkLevel() { //trocando de niveis
  if (score%scoreLevel==0 && levelChange) {
    level++;
    levelChange = false;
    increaseDifficulty = true;
  } else if (score%scoreLevel!=0) {
    if (!levelChange)
      levelChange = true;
  }

  if (level!=1 && increaseDifficulty) {
    increaseDifficulty = false;
    switch(level) {
    case 2: //aumentando paredes
      sizeY = 200;
      break;
    case 3: //aumentando paredes e lançando pedras pequenas
      sizeY = 250;
      smallStone = true;
      break;
    case 4: //movendo moedas
      coinY = 1.5;
      break;
    case 5: //borda flamejante
      fireBorder = true;
      break;
    case 6:  //pedra grande, controla velocidade das paredes e moedas
      bigStone = true;
      speedX --;
      controlSpeed();
      break;
    case 7: //controla velocidade do Bob, aumenta borda, controla velocidade das paredes e moedas e diminui tempo das paredes e moedas
      if (b.velocity.y >0) {
        b.velocity.y ++;
      } else {
        b.velocity.y --;
      }
      borderHeight += 10;
      speedX --;
      speedSX ++;
      time --;
      controlSpeed();
      break;
    case 8: //movimenta moedas e controla velocidade das paredes e moedas
      coinY = 2;
      speedX --;
      break; 
    case 9: //aumenta bordas e controla velocidade das paredes e moedas
      borderHeight += 5;
      speedX --;
      time --;
      controlSpeed();
      break;
    case 10: //controla velocidade das pedras
      speedSX++;
      controlSpeed();
      break;
    }
  }
}

void controlSpeed() { //controla velocidade das paredes e moedas
  for (int i=0; i<wall.size(); i++) {
    wall.get(i).velocity.x = speedX;
  }
  for (int i=0; i<coin.size(); i++) {
    coin.get(i).velocity.x = speedX;
  }
}

void showScore() { //placar
  textAlign(CENTER);
  textSize(150);
  fill(10);
  text(score, width/2, height/2);
  textSize(15);
  fill(170);
  text("LEVEL: "+level, width-45, height-45);
}

void burn() { //borda flamejante
  g = bl = 0;
  r = 150;
  colideBorder = b.colideBorder(borderHeight);
  if (colideBorder) { //morre queimado
    game = false;
  }
}

void throwSS() { //controla pedra pequena
  if (second()%5==0 && second()!=ss) {
    sStone.add(new Stone(random(0.5, 1), stoneSlowSpeed, speedSX));
  }
  ss = second();

  if (sStone.size()>0) {
    for (int i=0; i<sStone.size(); i++) {
      sStone.get(i).display();
      sStone.get(i).move();
      colide = b.colisionStone(sStone.get(i)); //verificando colisões
      if (colide) {
        game = false;
        sStone.remove(i);
      } else if (sStone.get(i).local.x+sStone.get(i).r < 0) {
        sStone.remove(i);
      }
    }
  }
}

void throwBS() { //controla pedra grande
  if (second()%6==0 && second()!=sb) {
    bStone.add(new Stone(random(1, 2), stoneSlowSpeed, speedSX));
  }
  sb = second();

  if (bStone.size()>0) {
    for (int i=0; i<bStone.size(); i++) {
      bStone.get(i).display();
      bStone.get(i).move();
      colide = b.colisionStone(bStone.get(i)); //verificando colisões
      if (colide) {
        game = false;
        bStone.remove(i);
      } else if (bStone.get(i).local.x+bStone.get(i).r < 0) {
        bStone.remove(i);
      }
    }
  }
}

void draw() {
  background(0);
  if (game)
  {

    //placar
    showScore();

    //controlando Bob
    b.move();

    //criando moedas
    if (second()%(time+1)==0 && second()%time!=0 && second()!=sc) {
      createCoin();
    }
    sc = second();

    //controlando moedas
    coinController();

    //criando paredes
    if (second()%time==0 && second()!=s) {
      buildWall();
    }
    s = second();

    //controlando paredes
    wallController();

    //checar level
    checkLevel();

    //broda de fogo
    if (fireBorder)
      burn();

    //pequena pedra
    if (smallStone)
      throwSS();

    //grande pedra
    if (bigStone)
      throwBS();

  } else {
    if (match == 0)
      firstScene();
    else
      gameOver();
  }

  //printando informações
  if (wall.size()>0)
    println(second()+" "+wall.size()+" "+sStone.size()+" "+bStone.size()+" "+coin.size());

  b.display();
  //margem
  margin();
}
