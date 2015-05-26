class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  Mover() {
    location = new PVector(0, -4.65, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0.14, 0);
  }
  
  void update() {
    location.add(velocity);
  }
  void display() {
    pushMatrix();
    fill(127, 127, 127);
    
    translate(location.x, location.y, location.z);
    sphere(ballSize);
    fill(255, 255, 255);
    popMatrix();
  }
  void checkEdges() {
    PVector gravityForce = new PVector(sin(rotationZ) * gravity.y, 0, -sin(rotationX) * gravity.y);
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    velocity.add(gravityForce);
    velocity.add(friction);
    
    location.add(velocity);
    
    if (location.x > boardSize/2){
      velocity.x = velocity.x * -1;
      location.x = boardSize/2;
      
      score = -velocity.mag();
      totalScore += score;
    }
    
    if (location.x < -boardSize/2){
      velocity.x = velocity.x * -1;
      location.x = -boardSize/2;
      
      score = -velocity.mag();
      totalScore += score;
    }
    
    if (location.z > boardSize/2){
      velocity.z = velocity.z * -1;
      location.z = boardSize/2;
      
      score = -velocity.mag();
      totalScore += score;
    }
    
    if (location.z < -boardSize/2){
      velocity.z = velocity.z * -1;
      location.z = -boardSize/2;
      
      score = -velocity.mag();
      totalScore += score;
    }
  }
  
  void checkCylinderCollision(){
    
     for (int i=0; i<cylinderList.size(); i++){
       PVector n = new PVector(location.x, 0, location.z);
       n.sub(new PVector(cylinderList.get(i).x, 0, cylinderList.get(i).y));
       
       if (n.mag() < cylinderBaseSize + ballSize){ // collision
         
         score = velocity.mag();
         totalScore += score;
       
         n.normalize();
         PVector temp = n.get();
         temp.mult(2);
         temp.mult(velocity.dot(n));
         velocity.sub(temp);
         
         PVector n2;
         do {
           location.add(velocity); // detach the ball
           
            n2 = new PVector(location.x, 0, location.z);
            n2.sub(new PVector(cylinderList.get(i).x, 0, cylinderList.get(i).y));
         } while (n2.mag() < cylinderBaseSize + ballSize); // if still in cylinder, detach the ball
         
         cylinderList.remove(i);
       }
       
        
     }
    
  }
}

