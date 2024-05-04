
String[] STATION_LIST = {
  "秋葉原", 
  "新御徒町", 
  "浅草", 
  "南千住", 
  "北千住", 
  "青井", 
  "六町", 
  "八潮", 
  "三郷中央", 
  "南流山", 
  "流山\nセントラル\nパーク", 
  "流山\nおおたかの\n森", 
  "柏の葉\nキャンパス", 
  "柏たなか", 
  "守谷", 
  "みらい平", 
  "みどりの", 
  "万博記念\n公園", 
  "研究学園", 
  "つくば", 
};

String[][] TX_DATA = {
  {"5701", "15", "5:20", "5:21", "20", "5:36", "5:37"}, 
  {"5001", "1", "5:29", "5:30", "20", "6:27", "6:28"}, 
  {"5701", "15", "5:00", "5:01", "20", "5:15", "5:16"}, 
  {"5001", "1", "5:13", "5:14", "20", "5:59", "6:00"}, 
//  {"5033", "1", "14:21", "14:22", "20", "15:24", "15:25"}, 
//  {"5377", "1", "0:17", "0:18", "15", "0:58", "0:59"}, 
};


PFont font;

Clock clock;
Railway railway;
TX[] tx;

PImage txImage;


void setup() {
  size(1200, 675);
  
  smooth();
  
  frameRate(30);
  
  ellipseMode(CENTER);
  textAlign(CENTER, TOP);
  rectMode(CENTER);
  
  font = loadFont("../HGGothicE-48.vlw");
  
  clock = new Clock(50, 25, 4, 0);
  
  railway = new Railway(STATION_LIST);
  
  tx = new TX[TX_DATA.length];
  for (int i = 0; i < tx.length; i++) {
    int txNumber = int(TX_DATA[i][0]);
    
    int stopNum = floor((TX_DATA[i].length - 1) / 3);
    Stop[] stops = new Stop[stopNum];
    for (int j = 0; j < stopNum; j++) {
      int stationNumber = int(TX_DATA[i][j * 3 + 1]);
      int arrivalTime = time(TX_DATA[i][j * 3 + 2]);
      int departureTime = time(TX_DATA[i][j * 3 + 3]);
      
      stops[j] = new Stop(stationNumber, arrivalTime, departureTime);
    }
    
    tx[i] = new TX(txNumber, stops);
  }
  
  imageMode(CENTER);
  txImage = loadImage("../tx_s.jpg");
}

int COUNTER_MAX = 2;
int counter = 0;

void draw() {
  background(255);
  
  counter++;
  if (counter == COUNTER_MAX) {
    clock.forward();
    counter = 0;
  }
  clock.draw();
  
  railway.draw();
  
  float currentMinute = clock.getTotalMinute() + float(counter) / float(COUNTER_MAX);
  for (int i = 0; i < tx.length; i++) {
    tx[i].draw(currentMinute);
  }
}


int MARGIN = 30;

class Railway
{
  int trackStartX, trackEndX, trackY;
  Station[] stations;
  
  Railway(String[] stationList) {
    trackStartX = MARGIN;
    trackEndX = width - MARGIN;
    
    trackY = int(height * 0.5);
    
    stations = new Station[stationList.length];
    for (int i = 0; i < stations.length; i++) {
      stations[i] = new Station(stationList[i], int(map(i + 1, 1, 20, trackStartX, trackEndX)));
    }
  }
  
  int getStationX(int stationIndex) {
    if (1 <= stationIndex && stationIndex <= 20) {
      return stations[stationIndex - 1].x;
    }
    
    return -1;
  }
  
  void draw() {
    stroke(0);
    noFill();
    
    line(trackStartX, trackY, trackEndX, trackY);
    
    textFont(font, 10);
    
    noStroke();
    fill(0);
    
    for (int i = 0; i < stations.length; i++) {
      ellipse(stations[i].x, trackY, 5, 5);
      text(stations[i].name, stations[i].x, trackY + 20);
    }
  }
}

class Station
{
  String name;
  int x;
  
  Station(String inName, int inX) {
    name = inName;
    x = inX;
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
    textFont(font, 24);
    
    noStroke();
    fill(255, 0, 0);
    
    text(nf(hour, 2) + ":" + nf(minute, 2), x, y);
//    text(getTotalMinute(), x, y + 30);
  }
}


class TX
{
  int number;
  
  Stop[] stops;
  int stopIndex;
  
  int startTime, endTime;
  
  int currentX;
  
  int departureTime, arrivalTime;
  int departureX, arrivalX;
  
  
  TX(int inNumber, Stop[] inStop) {
    number = inNumber;
    
    stops = inStop;
    stopIndex = 0;
    
    startTime = stops[0].arrivalTime;
    endTime = stops[stops.length - 1].departureTime;
    
    setStatus();
  }
  
  void setStatus() {
    if (stopIndex < stops.length - 1) {
      departureTime = stops[stopIndex].departureTime;
      departureX = railway.stations[stops[stopIndex].stationNumber - 1].x;
      
      arrivalTime = stops[stopIndex + 1].arrivalTime;
      arrivalX = railway.stations[stops[stopIndex + 1].stationNumber - 1].x;
    }
  }
  
  void updateStatus(float currentMinute) {
    currentX = int(constrain(map(currentMinute, departureTime, arrivalTime, departureX, arrivalX), departureX, arrivalX));
    
    if (currentMinute == arrivalTime) {
      stopIndex++;
      setStatus();
    }
  }
  
  void draw(float currentMinute) {
    if (startTime <= currentMinute && floor(currentMinute) <= endTime) {
      updateStatus(currentMinute);
      
//      noStroke();
//      fill(125);
      
//      rect(currentX, height * 0.25, 30, 30);
      
      image(txImage, currentX, height * 0.3);
      
      stroke(0, 0, 100);
      noFill();
      
      rect(currentX, height * 0.3, 50, 50);
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

