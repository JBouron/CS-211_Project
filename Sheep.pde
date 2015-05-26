
public class Sheep{
   boolean sheep_is_alive;
   PVector sheep_position;
   float sheep_height;
   float sheep_orientation;
   
    private  int max_jump_number = 15;
    private  float jump_duration = 500;
    private float jump_max_height = 1.2;
    
    private float jump_orientation = 0.0f;
    
    private int jump_count = 0;
    private boolean is_jumping = false;
    private long jump_begin_time = 0;
    
    private float sheep_speed = 0.05f;
    
    private float max_x = 0.0f;
    private float max_y = 0.0f;
    private float min_x = 0.0f;
    private float min_y = 0.0f;
    
  
  public Sheep(PVector init_pos, float boardSize){
     sheep_position = init_pos;
     sheep_is_alive = true;
     sheep_height = 0.0f;
     sheep_orientation = 0.0f;
     max_x = boardSize/2;
     max_y = boardSize/2;
     min_x = -1*max_x; // Car la board est carrée
      min_y = -1*max_y; 
  } 
  
  public void Sheep_move(){
    checkBallCollision();
      checkCylinderCollision();
    if (sheep_is_alive){
       if (!is_jumping){
          is_jumping = true;
           jump_begin_time = millis();
           jump_count ++;
       }
       
       long difftime = millis() - jump_begin_time;
       if (difftime >= jump_duration){
         is_jumping = false;
         sheep_height = 0.0f;
         jump_count ++;
       }
       else{
           if (difftime <= jump_duration/2){
             sheep_height = map(difftime, 0, jump_duration/2, 0, jump_max_height);
           }
           else{
               sheep_height = map(difftime, jump_duration/2, jump_duration, jump_max_height, 0);
           } 
       }
       
       sheep_position.x -= sheep_speed * cos(sheep_orientation);
       sheep_position.y -= sheep_speed * sin(sheep_orientation);
       
       if (sheep_position.x < min_x) sheep_position.x = min_x;
       else if (sheep_position.x > max_x) sheep_position.x = max_x;
       
       if (sheep_position.y < min_y) sheep_position.y = min_y;
       else if (sheep_position.y > max_y) sheep_position.y = max_y;
       
       
       if (jump_count >= max_jump_number){
         jump_count = 0 ;
         is_jumping = false;
         sheep_height = 0.0f;
         sheep_orientation = random(0, 2*PI);
       }
    }
    else{
        sheep_height = 0;
    }
    
  }
  
  private void checkBallCollision(){
      float dist = (sheep_position.x - ball.location.x)*(sheep_position.x - ball.location.x) + (sheep_position.y - ball.location.z)*(sheep_position.z - ball.location.z);
        if (dist < ballSize*ballSize){
           sheep_is_alive = false;  
      }
  }
  
  private void checkCylinderCollision(){
      for (int i=0; i<cylinderList.size(); i++){
          float dist = sheep_position.dist(cylinderList.get(i));
         if (dist < cylinderBaseSize) {
             sheep_orientation += PI;
         }
      }
  }
}

