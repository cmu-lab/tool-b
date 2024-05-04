
int VIRTUAL_FRAME_RATE = 10;
int FRAME_RATE = 60;

String STATION_LIST_NAME = "stationList";

String DOWN_DATA_NAME = "weekday_down";
String UP_DATA_NAME = "weekday_up";


PFont font;

Clock clock;

Railway railway;

TX[] tx;
PImage txImage;

PImage map;

int counterMax;
int counter;


void setup() {
  size(480, 640);
  
  smooth();
  
  frameRate(FRAME_RATE);
  
  ellipseMode(CENTER);
  rectMode(CENTER);
  
  font = loadFont("../HGGothicE-48.vlw");
//  font = loadFont("../HGGothicE-24.vlw");
  
  clock = new Clock(50, 30, 4, 0);
//  clock = new Clock(50, 30, 6, 0);
  
  String[] stationList = loadStrings("../" + STATION_LIST_NAME + ".txt");
  for (int i = 0; i < stationList.length; i++) {
    stationList[i] = join(splitTokens(stationList[i], "\\n"), "");
  }
  
  railway = new Railway(stationList);
  
  String[] txDownData = loadStrings("../" + DOWN_DATA_NAME + ".txt");
  TX[] txDown = setTX(txDownData, true);
  
  String[] txUpData = loadStrings("../" + UP_DATA_NAME + ".txt");
  TX[] txUp = setTX(txUpData, false);
  
  tx = (TX[]) concat(txDown, txUp);
  
//  imageMode(CENTER);
  txImage = loadImage("../tx_s.jpg");
  
  map = loadImage("../TX_map.jpg");
  map.resize(width, height);
  
  counterMax = int(float(FRAME_RATE) / float(VIRTUAL_FRAME_RATE));
  if (counterMax < 1) {
    counterMax = 1;
  }
//  println("counterMax: " + str(counterMax));
  
  counter = 0;
}

void draw() {
  background(255);
  
  image(map, 0, 0);
  
  textAlign(CENTER, CENTER);
  
  counter++;
  if (counter == counterMax) {
    clock.forward();
    counter = 0;
  }
  clock.draw();
  
  textAlign(LEFT, CENTER);
  
  railway.draw();
  
  float currentMinute = float(clock.getTotalMinute()) + float(counter) / float(counterMax);
  for (int i = 0; i < tx.length; i++) {
    tx[i].draw(currentMinute);
  }
}


boolean drawStationNameFlag = true;

class Railway
{
  Station[] stations;
  
  Railway(String[] stationList) {
    stations = new Station[stationList.length];
    
    for (int i = 0; i < stations.length; i++) {
      String[] data = splitTokens(stationList[i], "\t");
      stations[i] = new Station(data[0], int(data[1]), int(data[2]));
    }
  }
  
  int getStationX(int stationIndex) {
    if (1 <= stationIndex && stationIndex <= 20) {
      return stations[stationIndex - 1].x;
    }
    
    return -1;
  }
  
  int getStationY(int stationIndex) {
    if (1 <= stationIndex && stationIndex <= 20) {
      return stations[stationIndex - 1].y;
    }
    
    return -1;
  }
  
  void draw() {
    textFont(font, 9);
    
    for (int i = 0; i < stations.length; i++) {
      if (i > 0) {
//        stroke(0);
        stroke(255, 200);
        noFill();
        
        line(stations[i - 1].x, stations[i - 1].y, stations[i].x, stations[i].y);
      }
      
      noStroke();
//      fill(0);
      fill(255, 200);
      
      ellipse(stations[i].x, stations[i].y, 5, 5);
      
      if (drawStationNameFlag) {
        text(stations[i].name, stations[i].x + 2, stations[i].y + 5);
      }
    }
  }
}

class Station
{
  String name;
  int x, y;
  
  Station(String inName, int inX, int inY) {
    name = inName;
    
    x = inX;
    y = inY;
  }
}


class Clock
{
  int x, y;
  int hour;
  int minute;
  
  Clock(int inX, int inY, int inHour, int inMinute) {
    x = inX;
    y = inY;
    
    hour = inHour;
    minute = inMinute;
  }
  
  int getTotalMinute() {
    int totalMinute = hour * 60 + minute;
    if (hour < 3) {
      totalMinute += 1440;
    }
    
    return totalMinute;
  }
  
  void forward() {
    minute++;
    if (minute >= 60) {
      minute = 0;
      
      hour++;
      if (hour >= 24) {
        hour = 0;
      }
    }
  }
  
  void draw() {
    noStroke();
    fill(255, 200);
    
    rect(x, y, 80, 40);
    
    textFont(font, 24);
    
    noStroke();
//    fill(255, 0, 0);
    fill(0);
    
    text(nf(hour, 2) + ":" + nf(minute, 2), x, y);
//    text(getTotalMinute(), x, y + 30);
  }
}


class TX
{
  int number;
  
  color rectColor;
  
  Stop[] stops;
  int stopIndex;
  
  boolean downFlag;
  
  int startTime, endTime;
  
  int x, y;
  
  int departureTime, arrivalTime;
  
  int[] distance;
  int distanceIndex;
  
  float speed;
  float currentDistance;
  
  int currentDepartureX, currentArrivalX;
  int currentDepartureY, currentArrivalY;
  
  int arrivalStationIndex;
  
  boolean resetFlag;
  
  
  TX(int inNumber, String inClass, Stop[] inStop, boolean inFlag) {
    number = inNumber;
    
    rectColor = color(0);
    if (inClass.equals("快速")) {
      rectColor = color(255, 0, 0);
    } else if (inClass.equals("通快")) {
      rectColor = color(0, 255, 0);
    } else if (inClass.equals("区快")) {
      rectColor = color(0, 0, 255);
    }
    
    stops = inStop;
    
    downFlag = inFlag;
    
    startTime = stops[0].arrivalTime;
    endTime = stops[stops.length - 1].departureTime;
    
    reset();
  }
  
  void setStatus() {
    if (stopIndex < stops.length - 1) {
      arrivalStationIndex = stops[stopIndex].stationNumber - 1;
      int departureStationIndex = stops[stopIndex + 1].stationNumber - 1;
      
      distance = new int[abs(departureStationIndex - arrivalStationIndex) + 1];
      distanceIndex = 1;
      
      int targetIndex = arrivalStationIndex;
      
      int x1 = railway.stations[targetIndex].x;
      int y1 = railway.stations[targetIndex].y;
      
      int x2, y2;
      
      distance[0] = 0;
      for (int i = 1; i < distance.length; i++) {
        if (downFlag) {
          targetIndex++;
        } else {
          targetIndex--;
        }
        
        x2 = railway.stations[targetIndex].x;
        y2 = railway.stations[targetIndex].y;
        
        distance[i] = distance[i - 1] + int(dist(x1, y1, x2, y2));
        
        x1 = x2;
        y1 = y2;
      }
      
      departureTime = stops[stopIndex].departureTime;
      arrivalTime = stops[stopIndex + 1].arrivalTime;
      
      speed = float(distance[distance.length - 1]) / float(arrivalTime - departureTime);
      currentDistance = 0;
      
      currentArrivalX = railway.stations[arrivalStationIndex].x;
      currentArrivalY = railway.stations[arrivalStationIndex].y;
      
      setPos();
    }
  }
  
  void setPos() {
    if (downFlag) {
      arrivalStationIndex++;
    } else {
      arrivalStationIndex--;
    }
    
    currentDepartureX = currentArrivalX;
    currentArrivalX = railway.stations[arrivalStationIndex].x;
    
    currentDepartureY = currentArrivalY;
    currentArrivalY = railway.stations[arrivalStationIndex].y;
  }
  
  void updateStatus(float currentMinute) {
    currentDistance = speed * (currentMinute - float(departureTime));
    
    if (currentDistance > distance[distanceIndex]) {
      if (distanceIndex < distance.length - 1) {
        distanceIndex++;
        setPos();
      }
    }
    
//    x = int(constrain2(map(currentMinute, departureTime, arrivalTime, departureX, arrivalX), departureX, arrivalX));
//    y = int(constrain2(map(currentMinute, departureTime, arrivalTime, departureY, arrivalY), departureY, arrivalY));
    x = int(constrain2(map(currentDistance, distance[distanceIndex - 1], distance[distanceIndex], currentDepartureX, currentArrivalX), currentDepartureX, currentArrivalX));
    y = int(constrain2(map(currentDistance, distance[distanceIndex - 1], distance[distanceIndex], currentDepartureY, currentArrivalY), currentDepartureY, currentArrivalY));
    
    if (currentMinute == arrivalTime) {
      stopIndex++;
      setStatus();
    }
  }
  
  void reset() {
    stopIndex = 0;
    setStatus();
    
    resetFlag = true;
  }
  
  void draw(float currentMinute) {
    if (startTime <= currentMinute && floor(currentMinute) <= endTime) {
      updateStatus(currentMinute);
      
      if (downFlag) {
        x += 10;
        y += 10;
      } else {
        x -= 10;
        y -= 10;
      }
      
//      image(txImage, x, y);
      
//      stroke(rectColor);
//      noFill();
      noStroke();
      fill(rectColor);
      
      rect(x, y, 10, 10);
      
      resetFlag = false;
    } else {
      if (!resetFlag) {
        reset();
      }
    }
  }
}

class Stop
{
  int stationNumber, arrivalTime, departureTime;
  
  Stop(int inStationNumber, int inArrivalTime, int inDepartureTime) {
    stationNumber = inStationNumber;
    
    arrivalTime = inArrivalTime;
    departureTime = inDepartureTime;
  }
}


int time(String timeString) {
  String[] timeStringArray = splitTokens(timeString, ":");
  
  int hour = int(timeStringArray[0]);
  if (hour < 3) {
    hour += 24;
  }
  
  int minute = int(timeStringArray[1]);
  
  return hour * 60 + minute;
}


TX[] setTX(String[] txData, boolean downFlag) {
  TX[] tx = new TX[txData.length];
  for (int i = 0; i < tx.length; i++) {
    String[] data = splitTokens(txData[i], "\t");
    
    int txNumber = int(data[0]);
    String txClass = data[1];
    
    Stop[] stops = new Stop[20];
    int stopNum = 0;
    for (int j = 1; j <= 20; j++) {
      int arraivalIndex = j * 2;
      int departureIndex = arraivalIndex + 1;
      
      if (data[arraivalIndex].equals("-")) {
        continue;
      }
      
      int stationNumber = 0;
      if (downFlag) {
        stationNumber = j;
      } else {
        stationNumber = 21 - j;
      }
      
      int arrivalTime = time(data[arraivalIndex]);
      int departureTime = time(data[departureIndex]);
      
      stops[stopNum] = new Stop(stationNumber, arrivalTime, departureTime);
      stopNum++;
    }
    
    tx[i] = new TX(txNumber, txClass, (Stop[]) subset(stops, 0, stopNum), downFlag);
  }
  
  return tx;
}


float constrain2(float input, float left, float right) {
  float output = input;
  if (left < right) {
    if (input < left) {
      output = left;
    } else if (right < input) {
      output = right;
    }
  } else {
    if (input > left) {
      output = left;
    } else if (right > input) {
      output = right;
    }
  }
  
  return output;
}

void keyPressed() {
    if(key == 'p' || key == 'P') {

        // 画面をpngファイルに保存
        save("screenshot.png"); 

    }
}
