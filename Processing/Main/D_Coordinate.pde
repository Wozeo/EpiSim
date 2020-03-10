public class Coordinate {
  
  private double x, y, z;
  
  Coordinate() {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }
  
  Coordinate(double x, double y) {
    this.x = x;
    this.y = y;
    this.z = 0;
  }
  
  Coordinate(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public void setX(double x) {
    this.x = x;
  }
  
  public void setY(double y) {
    this.y = y;
  }
  
  public void setZ(double z) {
    this.z = z;
  }
  
  public double getX() {
    return this.x;
  }
  
  public double getY() {
    return this.y;
  }
  
  public double getZ() {
    return this.z;
  }
  
}
