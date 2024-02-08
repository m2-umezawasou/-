// 関節の位置
float joint1_x = 250, joint1_y = 250, joint1_z = 0;
float joint2_x, joint2_y, joint2_z;

// 関節の長さ
float len1 = 100;
float len2 = 75;

// ボールの位置と速度
float ball_x, ball_y, ball_z;
float ball_vx, ball_vy, ball_vz;

// ボールが投げられたかどうかを示すフラグ
boolean isThrown = false;

// 箱の位置とサイズ
float box_x = 300;
float box_y = 400;
float box_z = 200;
float box_w = 100;
float box_h = 50;
float box_d = 50;

void setup() {
  size(500, 600, P3D);
  strokeWeight(10);
  
  // ボールの初期位置を設定
  ball_x = joint1_x;
  ball_y = joint1_y;
  ball_z = joint1_z;
}

void draw() {
  background(255);
  
  // マウスの位置に基づいて角度を計算
  float target_x = mouseX;
  float target_y = mouseY;
  float target_z = 0;
  
  float dx = target_x - joint1_x;
  float dy = target_y - joint1_y;
  float dz = target_z - joint1_z;
  float dist = sqrt(dx*dx + dy*dy + dz*dz);
  
  float a = (len1*len1 + dist*dist - len2*len2) / (2*len1*dist);
  float angle1 = atan2(dy, dx) - acos(a);
  
  joint2_x = joint1_x + len1*cos(angle1);
  joint2_y = joint1_y + len1*sin(angle1);
  joint2_z = joint1_z;
  
  // 関節を描画
  stroke(105, 105, 105); // 鉄の色に設定
  line(joint1_x, joint1_y, joint1_z, joint2_x, joint2_y, joint2_z);
  pushMatrix();
  translate(joint1_x, joint1_y, joint1_z);
  sphere(10);
  popMatrix();
  
  // マウスの位置に基づいて第二関節の角度を計算
  dx = target_x - joint2_x;
  dy = target_y - joint2_y;
  dz = target_z - joint2_z;
  float angle2 = atan2(dy, dx);
  
  float end_x = joint2_x + len2*cos(angle2);
  float end_y = joint2_y + len2*sin(angle2);
  float end_z = joint2_z;
  
  // 第二関節を描画
  stroke(105, 105, 105); // 鉄の色に設定
  line(joint2_x, joint2_y, joint2_z, end_x, end_y, end_z);
  pushMatrix();
  translate(joint2_x, joint2_y, joint2_z);
  sphere(10);
  popMatrix();
  
  // ボールが投げられていない場合、ボールの位置をアームの先端に設定
  if (!isThrown) {
    ball_x = end_x;
    ball_y = end_y;
    ball_z = end_z;
  }
  
  // ボールを描画
  pushMatrix();
  translate(ball_x, ball_y, ball_z);
  fill(random(255), random(255), random(255));
  sphere(10);
  popMatrix();
  
  // ボールが投げられている場合、ボールの速度に基づいて位置を更新
  if (isThrown) {
    ball_x += ball_vx;
    ball_y += ball_vy;
    ball_z += ball_vz;
    
    // 重力をシミュレート
    ball_vy += 0.1;
    
    // ボールが地面に当たった場合、反射をシミュレート
    if (ball_y > height) {
      ball_y = height;
      ball_vy *= -0.8;
    }
    
    // ボールが画面外に出た場合、ボールをリセット
    if (ball_x < 0 || ball_x > width || ball_y < 0 || ball_z < 0 || ball_z > width) {
      isThrown = false;
      ball_vx = 0;
      ball_vy = 0;
      ball_vz = 0;
    }
    
    // ボールが箱に入った場合、ボールをリセットするのではなく、ボールの位置を箱の中心に設定
    if (ball_x > box_x && ball_x < box_x + box_w && ball_y > box_y && ball_y < box_y + box_h && ball_z > box_z && ball_z < box_z + box_d) {
      isThrown = false;
      ball_vx = 0;
      ball_vy = 0;
      ball_vz = 0;
      
      // ボールの位置を箱の中心に設定
      ball_x = box_x + box_w / 2;
      ball_y = box_y + box_h / 2;
      ball_z = box_z + box_d / 2;
    }
  }
  
  // 箱を描画
  pushMatrix();
  translate(box_x, box_y, box_z);
  fill(random(255), random(255), random(255));
  box(box_w, box_h, box_d);
  popMatrix();
}

void mousePressed() {
  // マウスがクリックされたとき、ボールを投げる
  isThrown = true;
  
  // ボールの初速度を設定
  ball_vx = (mouseX - pmouseX) * 0.5;
  ball_vy = (mouseY - pmouseY) * 0.5;
  ball_vz = random(-5, 5);
}
