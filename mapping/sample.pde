//��������
void setup(){
  size(200,200); //�T�C�Y200x200�ɃZ�b�g
  background(255); //�w�i�F�𔒂ɃZ�b�g
  colorMode(RGB, 256); //�J���[���[�h��RGB 256�i�K�ɃZ�b�g
}

//���C�����[�v
void draw(){
  stroke( randomRGBColor()); //���̐F�������_���ɐݒ�
  int x = int(random(width));
  int y = int(random(height));
  rectLines(x, y, 30, 30); 
}

//��������֐��̒�`

void rectLines(int x, int y, int w, int h){
  line (  x,  y,x+w,  y);
  line (  x,  y,  x,y+h);
  line (x+w,  y,x+w,y+h);
  line (x, y+h, x+w, y+h);
}

color randomRGBColor(){
  color c = color(random(256), random(256), random(256), 30);
  return c;
}

 
