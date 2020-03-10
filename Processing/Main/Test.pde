void test() {
  
  int counter = 0;
  
  Environment home = new Environment();
  home.setUID(counter); counter++;
  home.setName("Ira' House");
  home.setType(EnvironmentType.DWELLING);
  home.setArea(100);
  
  Environment work = new Environment();
  work.setUID(counter); counter++;
  work.setName("EDGEof");
  work.setType(EnvironmentType.OFFICE);
  work.setArea(1000);
  
  Host adult = new Host();
  adult.setUID(counter); counter++;
  adult.setName("Ira");
  adult.setAge(32);
  adult.setPrimaryLocation(home);
  adult.setSecondaryLocation(work);
  
  Agent corona = new Agent();
  corona.setUID(counter); counter++;
  corona.setName("COVID-19");
  corona.setType(AgentType.COVID_19);
  
  println(home);
  println(work);
  println("---");
  
  println(adult);
  println("- Primary Loc: " + adult.getPrimaryLocation());
  println("- Secondary Loc: " + adult.getSecondaryLocation());
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
}
