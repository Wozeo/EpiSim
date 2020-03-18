/*
 * Extentsion of EpiModel that allows initialization of city configuration
 *
 * Time Flow Model:
 *                
 * |     Phase 1     |         Phase 2          |  <- Phase Sequence
 *
 * |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |  9 |  <- Time Steps
 *                ^
 *                |
 *                e.g. currentTime  = timeStep*3; 
 *                e.g. currentPhase = Phase 1
 */
public class CityModel extends EpiModel {
  
  // Current phase of city
  private Phase currentPhase;
  
  // Current Phase duration
  private Time currentPhaseDuration;
  
  // City schedule
  private Schedule phaseSequence;
  
  // Person-place category association map
  private ChoiceModel behavior;
  
  // Person dictionary sorted by demographic
  private HashMap<Demographic, ArrayList<Person>> person;
  
  // Place dictionary sorted by land use
  private HashMap<LandUse, ArrayList<Place>> place;
  
  /**
   * Construct Simple Epidemiological Model
   */
  public CityModel() {
    super();
    this.currentPhase = Phase.SLEEP;
    this.currentPhaseDuration = new Time();
    this.phaseSequence = new Schedule();
    this.behavior = new ChoiceModel();
    
    person = new HashMap<Demographic, ArrayList<Person>>();
    for(Demographic d : Demographic.values()) {
      this.person.put(d, new ArrayList<Person>());
    }
    
    place = new HashMap<LandUse, ArrayList<Place>>();
    for(LandUse use : LandUse.values()) {
      this.place.put(use, new ArrayList<Place>());
    }
  }
  
  /**
   * Set the Schedule for hosts
   * 
   * @param s Schedule
   */
  public void setSchedule(Schedule s) {
    this.phaseSequence = s;
    this.setCurrentPhase();
  }
  
  /**
   * Get the Schedule for hosts
   */
  public Schedule getSchedule() {
    return this.phaseSequence;
  }
  
  /**
   * Set the Phase
   * 
   * @param p Phase
   */
  public void setCurrentPhase(Phase p) {
    this.currentPhase = p;
  }
  
  /**
   * Set the Phase Duration
   * 
   * @param duration Time
   */
  public void setCurrentPhaseDuration(Time duration) {
    this.currentPhaseDuration = duration;
  }
  
  /**
   * Set the behavior of population
   *
   * @param behavior ChoiceModel
   */
  public void setBehavior(ChoiceModel behavior) {
    this.behavior = behavior;
  }
  
  /**
   * Get the ChoiceModel
   *
   * @return behavior map
   */
  public ChoiceModel getBehavior() {
    return this.behavior;
  }
  
  /**
   * Get the Phase Duration
   *
   * @return current phase duration
   */
  public Time getCurrentPhaseDuration() {
    return this.currentPhaseDuration;
  }
  
  /**
   * Set the Phase via existing schedule and current time
   */
  public void setCurrentPhase() {
    if(this.phaseSequence != null) {
      Time currentTime = this.getCurrentTime();
      Schedule s = this.getSchedule();
      Phase currentPhase = s.getPhase(currentTime);
      Time currentPhaseDuration = s.getInterval(currentTime).getDuration();
      this.setCurrentPhase(currentPhase);
      this.setCurrentPhaseDuration(currentPhaseDuration);
    } else {
      println("Must initialize host schedule before setting Phase");
    }
  }
  
  /**
   * Get the Phase
   *
   * @return current phase
   */
  public Phase getCurrentPhase() {
    return this.currentPhase;
  }
  
  /**
   * Make a new default person with unique ID
   */
  public Person makePerson() {
    Person p = new Person();
    int new_uid = this.nextUID();
    p.setUID(new_uid);
    return p;
  }
  
  /**
   * Make a new default environment with unique ID
   */
  public Place makePlace() {
    Place p = new Place();
    int new_uid = this.nextUID();
    p.setUID(new_uid);
    return p;
  }
  
  /**
   * Add Person to City Model
   *
   * @param p person
   */
  public void addPerson(Person p) {
    
    // Add To Person Dictionary sorted by Demographic
    Demographic d = p.getDemographic();
    ArrayList<Person> list = this.person.get(d);
    if(list.contains(p)) {
      println(p + " already exists.");
    } else {
      list.add(p);
    }
    
    // Add place element to EpiModel extension
    this.addHost(p);
  }
  
  /**
   * Remove Person from City Model
   *
   * @param p person
   */
  public void removePerson(Person p) {
    
    // Remove from Person Dictionary sorted by Demographic
    Demographic d = p.getDemographic();
    ArrayList<Person> list = this.person.get(d);
    if(list.contains(p)) {
      list.remove(p);
    } else {
      println("No such Person exists.");
    }
    
    // Remove person element from EpiModel extension
    this.removeHost(p);
  }
  
  /**
   * Add Place to City Model
   *
   * @param l place
   */
  public void addPlace(Place l) {
    
    // Add to Place Dictionary sorted by Land Use
    LandUse use = l.getUse();
    ArrayList<Place> list = this.place.get(use);
    if(list.contains(l)) {
      println(l + " already exists.");
    } else {
      list.add(l);
    }
    
    // Add to ChoiceModel
    this.behavior.addPlace(l);
    
    // Add place element to EpiModel extension
    this.addEnvironment(l);
  }
  
  /**
   * Remove Place from City Model
   *
   * @param l place
   */
  public void removePlace(Place l) {
    
    // Remove from Place Dictionary sorted by Land Use
    LandUse use = l.getUse();
    ArrayList<Place> list = this.place.get(use);
    if(list.contains(l)) {
      list.remove(l);
    } else {
      println("No such Place exists.");
    }
    
    // Remove place element from EpiModel extension
    this.removeEnvironment(l);
  }
  
  /**
   * Add randomly placed Environments to Model within a specified rectangle
   *
   * @param amount
   * @param name_prefix
   * @param type
   * @param minSize
   * @param maxSize
   * @param minX
   * @param maxY
   */
  public void randomPlaces(int amount, String name_prefix, LandUse type, int x1, int y1, int x2, int y2, int minSize, int maxSize) {
    for(int i=0; i<amount; i++) {
      Place l = this.makePlace();
      l.setName(name_prefix + " " + l.getUID());
      l.setCoordinate(new Coordinate(random(x1, x2), random(y1, y2)));
      l.setUse(type);
      l.setSize(random(minSize, maxSize));
      
      // Add Place to EpiModel extension
      this.addPlace(l);
    }
  }
  
  /**
   * Adds hosts to model, initially located at their respective dwellings
   *
   * @param minAge
   * @param maxAge
   * @param adultAge
   * @param seniorAge
   * @param minDwellingSize smallest household size of a dwelling unit
   * @param maxDwellingSize largest household size of a dwelling unit
   */
  public void populate(int minAge, int maxAge, int adultAge, int seniorAge, Rate childResilience, Rate adultResilience, Rate seniorResilience, int minDwellingSize, int maxDwellingSize) {
    
    for(Place l : this.place.get(LandUse.DWELLING)) {
      int numTenants = (int) random(minDwellingSize, maxDwellingSize+1);
      for (int i=0; i<numTenants; i++) {
        
        // Create New Person using makePerson() (ensures proper UID instantiation)
        Person person = this.makePerson();
        person.setName("House of " + l.getUID() + ", " + person.getUID());
        
        // Set Age
        int age = (int) random(minAge, maxAge);
        person.setAge(age);
        
        // Set Demographic
        person.setDemographic(adultAge, seniorAge);
        
        // Set Pathogen Resilience
        switch(person.getDemographic()) {
          case CHILD:
            person.setResilience(childResilience);
            break;
          case ADULT:
            person.setResilience(adultResilience);
            break;
          case SENIOR:
            person.setResilience(seniorResilience);
            break;
        }
        
        // Set Current Environment
        person.setEnvironment(l);
        
        // Set Primary Place
        person.setPrimaryPlace(l);
        
        // Set Secondary Place
        Place secondaryPlace = this.behavior.getRandomPlace(person, PlaceCategory.SECONDARY);
        person.setSecondaryPlace(secondaryPlace);
        
        // Add Person to EpiModel extension
        this.addPerson(person);
      }
    }
  }
  
  /**
   * Add Infectious Agents to Model at one or more random patients "zero"
   *
   * @param pathogen
   * @param numHosts
   */
  public void patientZero(Pathogen pathogen, int numHosts) {
    
    //Adds new pathogen to model if first instance
    if(!this.getPathogens().contains(pathogen)) {
      this.addPathogen(pathogen);
    }
    
    for(int i=0; i<numHosts; i++) {
      ArrayList<Person> options = this.person.get(Demographic.ADULT);
      int randomIndex = (int) (Math.random() * (options.size() - 1));
      Person patientZero = options.get(randomIndex);
      
      this.infectHost(patientZero, pathogen);
      this.putAgent(patientZero, pathogen);
      
      // Set Initial time such that agent is already infectious
      PathogenEffect pE = patientZero.getStatus(pathogen);
      Time incubationDuration = pE.getIncubationDuration();
      Time negativeOne = new Time(-1, incubationDuration.getUnit());
      Time initialTime = incubationDuration.multiply(negativeOne);
      pE.setInitialTime(initialTime);
    }
  }
  
  /**
   * Force movement of all People to their primary Place
   */
  public void allToPrimary() {
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        p.moveToPrimary();
      }
    }
  }
  
  /**
   * Force movement of all People to their secondary Place
   */
  public void allToSecondary() {
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        p.moveToSecondary();
      }
    }
  }
  
  /**
   * Force movement of all People to their secondary Place
   */
  public void allToTertiary() {
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        p.moveTo(behavior.getRandomPlace(p, PlaceCategory.TERTIARY));
      }
    }
  }
  
  /**
   * Updating the Object model moves time forward by one time step 
   * and implements relevent agent behaviors.
   */
  @Override
  public void update() {
    
    // Set Time
    Time current = this.getCurrentTime();
    Time step = this.getTimeStep();
    this.setCurrentTime(current.add(step));
    
    // Base Encounters Per Step
    Time hoursPerStep = step.convert(TimeUnit.HOUR);
    
    // Set Phase
    this.setCurrentPhase();
    
    // Move People based on Behavior Model
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        behavior.apply(p, this.getCurrentPhase(), step);
      }
    }
    
    // Create Infectious Agents
    for(Host h : this.getHosts()) {
      for(Pathogen p : this.getPathogens()) {
        
        // Only add agent pathogens if host is infectious
        if(h.getStatus(p).infectious()) {
          
          // 0. Host has Agent Internal To Self
          //
          boolean hasAgent = false;
          for(Agent a : h.getAgents()) {
            if(a.getPathogen() == p) {
              hasAgent = true;
              break;
            }
          }
          if(!hasAgent) {
            this.putAgent(h, p);
          }
          
          // 1. Transmit agent from Host to Environment
          //    DepositeRate ~ attackRate * time
          //
          Environment e = h.getEnvironment();
          double depositRate = p.getAttackRate().toDouble() * hoursPerStep.getAmount();
          if(Math.random() < depositRate) {
            this.putAgent(e, p);
          }
          
          // 2. Transmit pathogen from Host to Host
          //    EncounterRate ~ attackRate * time * people / area
          //
          if(e instanceof Place) {
            Place l = (Place) e;
            double encounterRate = p.getAttackRate().toDouble() * hoursPerStep.getAmount() * l.getDensity();
            for(Host h2 : e.getHosts()) {
              if(Math.random() < encounterRate) {
                this.infectHost(h2, p);
              }
            }
          }
        }
      }
    }
    
    // 3. Transmit infectious agents from Environment to Host
    //    TransmissionRate ~ attackRate * time / area
    //
    int numAgents = this.getAgents().size();
    for(int i=0; i<numAgents; i++) {
      Agent a = this.getAgents().get(i);
      if(a.alive()) {
        Pathogen p = a.getPathogen();
        Element vessel = a.getVessel();
        
        
        if (vessel instanceof Place) {
          Place l = (Place) vessel;
          Environment e = (Environment) vessel;
          double transmissionRate = p.getAttackRate().toDouble() * hoursPerStep.getAmount() / l.getSize();
          for(Host h : e.getHosts()) {
            if(Math.random() < transmissionRate) 
              this.infectHost(h, p);
          }
        }
      }
    }
    
    // Update Host Compartment status
    for(Host h : this.getHosts()) {
      boolean treated = true;
      h.update(current, treated);
    }
    
    // Update and Clean
    for(int i=this.getAgents().size()-1; i>=0; i--) {
      Agent a = this.getAgents().get(i);
      a.update(step);
      if(!a.alive()) {
        this.removeAgent(a);
      }
    }
  }
}
