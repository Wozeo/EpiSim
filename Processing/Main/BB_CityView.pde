/**
 * City Visualization Model extending Epidemiological Object Model
 */
public class CityView extends EpiView {
  
  // Information text
  private String info;
  
  // Graphics (Pre-rendered)
  private PGraphics placeLayer;
  private PGraphics commuteLayer;
  
  // View Mode Setting
  private PersonMode personMode;
  private PlaceMode placeMode;
  
  /**
   * Construct EpiView Model
   */
  public CityView() {
    super();
    
    personMode = PersonMode.values()[0];
    placeMode = PlaceMode.values()[0];
  }
  
  /**
   * Set Person Mode in View Model
   *
   * @param pM PersonMode
   */
  public void setPersonMode(PersonMode pM) {
    this.personMode = pM;
  }
  
  /**
   * Set Place Mode in View Model
   *
   * @param pM PlaceMode
   */
  public void setPlaceMode(PlaceMode pM) {
    this.placeMode = pM;
  }
  
  /**
   * Get Person Mode in View Model
   */
  public PersonMode getPersonMode() {
    return this.personMode;
  }
  
  /**
   * Get Place Mode in View Model
   */
  public PlaceMode getPlaceMode() {
    return this.placeMode;
  }
  
  /**
   * Next Person Mode in View Model
   */
  public void nextPersonMode() {
    int ordinal = personMode.ordinal();
    int size = PersonMode.values().length;
    if(ordinal < size - 1) {
      personMode = PersonMode.values()[ordinal + 1];
    } else {
      personMode = PersonMode.values()[0];
    }
  }
  
  /**
   * Next Place Mode in View Model
   */
  public void nextPlaceMode() {
    int ordinal = placeMode.ordinal();
    int size = PathogenType.values().length;
    if(ordinal < size - 1) {
      placeMode = PlaceMode.values()[ordinal + 1];
    } else {
      placeMode = PlaceMode.values()[0];
    }
  }
  
  /**
   * Set Text in Info Pane
   *
   * @param info String
   */
  public void setInfo(String info) {
    this.info = info;
  }
  
  /**
   * Pre Draw Static Graphics Objects
   */
  public void preDraw(CityModel model) {
    this.renderPlaces(model);
    this.renderCommutes(model);
  }
  
  /**
   * Render static image of places to PGraphics object
   *
   * @param model CityModel
   */
  private void renderPlaces(CityModel model) {
    placeLayer = createGraphics(width, height);
    placeLayer.beginDraw();
    for(Environment e : model.getEnvironments()) {
      if(e instanceof Place) {
        Place p = (Place) e;
        this.drawLandUse(placeLayer, p);
      }
    }
    placeLayer.endDraw();
  }
  
  /**
   * Render static image of commutes to PGraphics object
   *
   * @param model CityModel
   */
  private void renderCommutes(CityModel model) {
    commuteLayer = createGraphics(width, height);
    commuteLayer.beginDraw();
    for(Host h : model.getHosts()) {
      if(h instanceof Person) {
        Person p = (Person) h;
        this.drawCommute(commuteLayer, p);
      }
    }
    commuteLayer.endDraw();
  }
  
  /**
   * Render ViewModel to Processing Canvas
   *
   * @param mode CityModel
   */
  public void draw(CityModel model) {
    background(255);
    
    boolean showCommutes = this.getToggle(ViewParameter.SHOW_COMMUTES);
    boolean showPlaces   = this.getToggle(ViewParameter.SHOW_PLACES);
    boolean showPersons  = this.getToggle(ViewParameter.SHOW_PERSONS);
    boolean showAgents   = this.getToggle(ViewParameter.SHOW_AGENTS);
    
    int textFill = (int) this.getValue(ViewParameter.TEXT_FILL);
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    
    // Draw Commutes
    if(showCommutes) {
      image(commuteLayer, 0, 0);
    }
    
    // Draw Places
    if(showPlaces) {
      switch(this.placeMode) {
        case LANDUSE:
          image(placeLayer, 0, 0);
          break;
        case DENSITY:
          for(Environment e : model.getEnvironments()) {
            if(e instanceof Place) {
              Place p = (Place) e;
              this.drawDensity(p);
            }
          }
          break;
      }
      
    }
    
    // Draw People
    if(showPersons) {
      switch(this.personMode) {
        case DEMOGRAPHIC:
          for(Host h : model.getHosts()) {
            if(h instanceof Person) {
              Person p = (Person) h;
              this.drawDemographic(p);
            }
          }
          break;
        case COMPARTMENT:
          for(Host h : model.getHosts()) {
            if(h instanceof Person) {
              Person p = (Person) h;
              Pathogen pathogen = getCurrentPathogen(model);
              this.drawCompartment(p, pathogen);
            }
          }
          break;
      }
    }
    
    // Draw Agents
    if(showAgents) {
      for(Agent a : model.getAgents()) {
        this.drawAgent(a);
      }
    }
    
    int X_INDENT = 50;
    
    // Draw Information
    drawInfo(X_INDENT, 100, 250, 800, textFill);
    drawTime(model, X_INDENT, height - 125, textFill);
    
    // Draw Legends
    drawPathogenLegend(model, X_INDENT, 400, textFill, textHeight);
    
    switch(this.placeMode) {
      case LANDUSE:
        drawLandUseLegend(X_INDENT, 500, textFill, textHeight);
        break;
      case DENSITY:
        //drawDensityLegend(X_INDENT, 500, textFill, textHeight);
        break;
    }
    
    switch(this.personMode) {
      case DEMOGRAPHIC:
        drawDemographicLegend(X_INDENT, 650, textFill, textHeight);
        break;
      case COMPARTMENT:
        drawCompartmentLegend(X_INDENT, 650, textFill, textHeight);
        break;
    }
  }
  
  /**
   * Render a Single Land Use
   *
   * @param g PGraphics
   * @param l place
   */
  protected void drawLandUse(PGraphics g, Place l) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    int w = (int) Math.sqrt(l.getSize());
    LandUse use = l.getUse();
    color viewFill = this.getColor(use);
    color viewStroke = this.getColor(ViewParameter.PLACE_STROKE);
    
    g.stroke(viewStroke);
    g.fill(viewFill);
    g.rectMode(CENTER);
    g.rect(x, y, w, w);
    g.rectMode(CORNER);
  }
  
  /**
   * Render a Single Land Use
   *
   * @param l place
   */
  protected void drawLandUse(Place l) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    int w = (int) Math.sqrt(l.getSize());
    LandUse use = l.getUse();
    color viewFill = this.getColor(use);
    color viewStroke = this.getColor(ViewParameter.PLACE_STROKE);
    
    stroke(viewStroke);
    fill(viewFill);
    rectMode(CENTER);
    rect(x, y, w, w);
    rectMode(CORNER);
  }
  
  /**
   * Render a Single Place Density
   *
   * @param l place
   */
  protected void drawDensity(Place l) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    int w = (int) Math.sqrt(l.getSize());
    
    double density = l.getDensity();
    double minVal = this.getValue(ViewParameter.MIN_DENSITY);
    double maxVal = this.getValue(ViewParameter.MAX_DENSITY);
    double minHue = this.getValue(ViewParameter.MIN_DENSITY_HUE);
    double maxHue = this.getValue(ViewParameter.MAX_DENSITY_HUE);
    color viewFill = this.mapToGradient(density, minVal, maxVal, minHue, maxHue);
    color viewStroke = this.getColor(ViewParameter.PLACE_STROKE);
    int alpha = (int) this.getValue(ViewParameter.PLACE_ALPHA);
    
    stroke(viewStroke);
    fill(viewFill, alpha);
    rectMode(CENTER);
    rect(x, y, w, w);
    rectMode(CORNER);
  }
  
  /**
   * Render a Single Person Demographic
   *
   * @param p person
   * @param pathogenson
   */
  protected void drawCompartment(Person p, Pathogen pathogen) {
    int x = (int) p.getCoordinate().getX();
    int y = (int) p.getCoordinate().getY();
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    Compartment c = p.getCompartment(pathogen);
    color viewFill = this.getColor(c);
    color viewStroke = this.getColor(ViewParameter.PERSON_STROKE);
    int alpha = (int) this.getValue(ViewParameter.PERSON_ALPHA);
    
    stroke(viewStroke);
    fill(viewFill, alpha);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
  }
  
  /**
   * Render a Single Person Demographic
   *
   * @param p person
   * @param pathogenson
   */
  protected void drawDemographic(Person p) {
    int x = (int) p.getCoordinate().getX();
    int y = (int) p.getCoordinate().getY();
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    Demographic d = p.getDemographic();
    color viewFill = this.getColor(d);
    color viewStroke = this.getColor(ViewParameter.PERSON_STROKE);
    int alpha = (int) this.getValue(ViewParameter.PERSON_ALPHA);
    
    stroke(viewStroke);
    fill(viewFill, alpha);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
  } 
  
  /**
   * Render a Single Person's Commute
   *
   * @param g PGraphics
   * @param p person
   */
  protected void drawCommute(PGraphics g, Person p) {
    int x1 = (int) p.getPrimaryPlace().getCoordinate().getX();
    int y1 = (int) p.getPrimaryPlace().getCoordinate().getY();
    int x2 = (int) p.getSecondaryPlace().getCoordinate().getX();
    int y2 = (int) p.getSecondaryPlace().getCoordinate().getY();
    color viewStroke = this.getColor(ViewParameter.COMMUTE_STROKE);
    
    g.stroke(viewStroke);
    g.line(x1, y1, x2, y2);
  }
  
  /**
   * Draw Application Info
   *
   * @param x
   * @param y
   * @param w
   * @param h
   * @param textFill color
   */
  private void drawInfo(int x, int y, int w, int h, color textFill) {
    fill(textFill);
    text(info, x, y, w, h);
  }
  
  /**
   * Render a Legend of Demographic Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawDemographicLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.personMode);
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    int yOffset = textHeight/2;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    for (Demographic d : Demographic.values()) {
      yOffset += textHeight;
      
      // Create a Straw-man Host for Lengend Item
      Person p = new Person();
      p.setDemographic(d);
      p.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawDemographic(p);
      
      // Draw Symbol Label
      String pName = this.getName(d);
      fill(textFill);
      text(pName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render a Legend of Person Compartment Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawCompartmentLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.getPathogenMode()) + " Status";
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    int yOffset = textHeight/2;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    for (Compartment c : Compartment.values()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Person p = new Person();
      Pathogen pathogen = new Pathogen();
      p.setCompartment(pathogen, c);
      p.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawCompartment(p, pathogen);
      
      // Draw Symbol Label
      String pName = this.getName(c);
      fill(textFill);
      text(pName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render a Legend of Place Land Use Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawLandUseLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.placeMode);
    int w = (int) this.getValue(ViewParameter.PLACE_DIAMETER);
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible place types
    int yOffset = textHeight/2;
    for (LandUse type : LandUse.values()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Place for Lengend Item
      Place l = new Place();
      l.setUse(type);
      l.setSize(Math.pow(2*w, 2));
      l.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawLandUse(l);
      
      // Draw Symbol Label
      String pName = this.getName(l.getUse());
      fill(textFill);
      text(pName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render Time and Phase Info
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawTime(CityModel model, int x, int y, color textFill) {
    
    int day = (int) model.getTime().convert(TimeUnit.DAY).getAmount();
    String clock = model.getTime().toClock();
    String dayOfWeek = model.getTime().toDayOfWeek();
    
    String text = 
      "Simulation Day: " + (day+1) + "\n" +
      "Day of Week: " + dayOfWeek + "\n" +
      "Simulation Time: " + clock + "\n" +
      "Current City Phase: " + model.getPhase();
    
    fill(textFill);
    text(text, x, y);
  }
  
  /** 
   * Map a value to a specific hue color along a gradient
   *
   * @param value
   * @param min
   * @param max
   * @param minHue
   * @param maxHue
   */
  public color mapToGradient(double value, double v1, double v2, double hue1, double hue2) {
    double ratio = (value - v1) / (v2 - v1);
    double hue = hue1 + ratio * (hue2 - hue1);
    println(hue);
    colorMode(HSB);
    color map = color((int) hue, 255, 255, 255);
    colorMode(RGB);
    return map;
    
  }
}
