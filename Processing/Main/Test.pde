void test() {
  
  int counter = 0;
  
  Place home = new Place();
  home.setUID(counter); counter++;
  home.setName("Ira' House");
  home.setUse(LandUse.DWELLING);
  home.setArea(100);
  
  Place work = new Place();
  work.setUID(counter); counter++;
  work.setName("EDGEof");
  work.setUse(LandUse.OFFICE);
  work.setArea(1000);
  
  Person adult = new Person();
  adult.setUID(counter); counter++;
  adult.setName("Ira");
  adult.setAge(32);
  adult.setPrimaryPlace(home);
  adult.setSecondaryPlace(work);
  
  Agent corona = new Agent();
  corona.setUID(counter); counter++;
  corona.setName("COVID-19");
  corona.setPathogen(Pathogen.COVID_19);
  
  println(home);
  println(work);
  println("---");
  
  println(adult);
  println("- Primary Loc: " + adult.getPrimaryPlace());
  println("- Secondary Loc: " + adult.getSecondaryPlace());
  println("---");
  
  println(corona);
  println("---");
  
  home.addElement(adult);
  
  println(home);
  for(Element e : home.getElements()) {
    println("- " + e);
  }
  println("---");
    
  home.addElement(adult); // test redundancy
  println("---");
  
  home.removeElement(adult);
  
  println(home);
  for(Element e : home.getElements()) {
    println("- " + e);
  }
  println("---");
  
  adult.addElement(corona);
  work.addElement(adult);
  work.addElement(corona);
  
  println(work);
  for(Element e : work.getElements()) {
    println("- " + e);
  }
  println("---");
  
    println(adult);
  for(Element e : adult.getElements()) {
    println("- " + e);
  }
  println("---");
  
  // create random object 
  Random ran = new Random(); 

  // generating next gaussian
  double nxt = ran.nextGaussian(); 

  // Printing the random Number 
  System.out.println("The next Gaussian value generated is : " + nxt); 
}
