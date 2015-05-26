class CWComparator implements Comparator<PVector> {
  PVector center;
  public CWComparator(PVector center) {
    this.center = center;
  }
  @Override
    public int compare(PVector b, PVector d) {
    if (Math.atan2(b.y-center.y, b.x-center.x)<Math.atan2(d.y-center.y, d.x-center.x))
      return -1;
    else return 1;
  }
}

public List<PVector> sortCorners(List<PVector> quad) {
  // Sort corners so that they are ordered clockwise
  PVector a = quad.get(0);
  PVector b = quad.get(2);
  PVector center = new PVector((a.x+b.x)/2,(a.y+b.y)/2);
  Collections.sort(quad, new CWComparator(center));
  // TODO:
  // Re-order the corners so that the first one is the closest to the
  // origin (0,0) of the image.
  //
  // You can use Collections.rotate to shift the corners inside the quad.
  int shift = 0;
  float distance = 3.4028234663852886E38f; // float max value
  
  for (int i = 0; i < 4; i++){
    if (quad.get(i).x * quad.get(i).x + quad.get(i).y * quad.get(i).y < distance){
      shift = i;
      distance = quad.get(i).x * quad.get(i).x + quad.get(i).y * quad.get(i).y;
    }
  }
  
  
  Collections.rotate(quad, shift);
  
  return quad;
}

