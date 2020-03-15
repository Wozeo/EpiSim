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
  public CityView(CityModel model) {
    super(model);
    personMode = PersonMode.values()[0];
    placeMode = PlaceMode.values()[0];
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
    
    // Draw Pathogen Agents
    if(showAgents) {
      for(Agent a : model.getAgents()) {
        this.drawAgent(a);
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
              Pathogen pathogen = this.getCurrentPathogen();
              this.drawCompartment(p, pathogen);
            }
          }
          break;
      }
    }
    
    int leftMargin         = (int) this.getValue(ViewParameter.LEFT_MARGIN);
    int generalMargin      = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int infoY              = (int) this.getValue(ViewParameter.INFO_Y);
    int pathogenLegendY    = (int) this.getValue(ViewParameter.PATHOGEN_LEGEND_Y);
    int personLegendY      = (int) this.getValue(ViewParameter.PERSON_LEGEND_Y);
    int placeLegendY       = (int) this.getValue(ViewParameter.PLACE_LEGEND_Y);
    
    // Draw Information
    drawInfo(leftMargin, infoY, textFill);
    drawTime(model, leftMargin, height - generalMargin, textFill);
    
    // Draw Pathogen Legend
    switch(this.getPathogenMode()) {
      case PATHOGEN:
        drawPathogenLegend(leftMargin, pathogenLegendY, textFill, textHeight);
        break;
      case PATHOGEN_TYPE:
        drawPathogenTypeLegend(leftMargin, pathogenLegendY, textFill, textHeight);
        break;
    }
    
    // Draw Place Legend
    switch(this.getPlaceMode()) {
      case LANDUSE:
        drawLandUseLegend(leftMargin, personLegendY, textFill, textHeight);
        break;
      case DENSITY:
        drawDensityLegend(leftMargin, personLegendY, textFill, textHeight);
        break;
    }
    
    // Draw Person Legend
    switch(this.getPersonMode()) {
      case DEMOGRAPHIC:
        drawDemographicLegend(leftMargin, placeLegendY, textFill, textHeight);
        break;
      case COMPARTMENT:
        drawCompartmentLegend(leftMargin, placeLegendY, textFill, textHeight);
        break;
    }
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
    int size = PlaceMode.values().length;
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
   * Render a Single Land Use
   *
   * @param g PGraphics
   * @param l place
   */
  protected void drawLandUse(PGraphics g, Place l) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    double scaler = this.getValue(ViewParameter.PLACE_SCALER);
    int w = (int) ( Math.sqrt(l.getSize()) * scaler);
    
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
    double scaler = this.getValue(ViewParameter.PLACE_SCALER);
    int w = (int) ( Math.sqrt(l.getSize()) * scaler);
    
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
    double scaler = this.getValue(ViewParameter.PLACE_SCALER);
    int w = (int) ( Math.sqrt(l.getSize()) * scaler);
    
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
  private void drawInfo(int x, int y, color textFill) {
    fill(textFill);
    text(info, x, y);
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
    String legendName = this.getCurrentPathogen().getName() + " Status";
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
    double scaler = this.getValue(ViewParameter.PLACE_SCALER);
    int w = (int) (this.getValue(ViewParameter.PLACE_DIAMETER));
    
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
      l.setSize(Math.pow(2*w/scaler, 2));
      l.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawLandUse(l);
      
      // Draw Symbol Label
      String pName = this.getName(l.getUse());
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
  protected void drawDensityLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.placeMode);
    int w = (int) this.getValue(ViewParameter.PLACE_DIAMETER);
    double minDensity = this.getValue(ViewParameter.MIN_DENSITY);
    double maxDensity = 1.1*this.getValue(ViewParameter.MAX_DENSITY);
    int numRows = 6;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible place types
    int yOffset = textHeight/2;
    for (int i=0; i<numRows; i++) {
      yOffset += textHeight;
      int xP = int(x + w);
      int yP = int(y + yOffset - 0.25*textHeight);
      double density = minDensity + (maxDensity - minDensity) * i / (numRows - 1.0);
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
      rect(xP, yP, 2*w, 2*w);
      rectMode(CORNER);
      
      // Draw Symbol Label
      String dName = "" + (int) (density * 1000) + " ppl per 1000sm";
      fill(textFill);
      text(dName, x + 1.5*textHeight, y + yOffset);
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
}
