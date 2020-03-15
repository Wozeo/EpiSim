/** 
  * Planetary Insight Center 
  * Agent Based Simulation of Epidemic
  * Ira Winder, jiw@mit.edu
  *
  * Object Map Legend:
  *   - Class() dependency
  *   * Enum dependency
  *   @ Interface
  * 
  * Object Map (Updated 2020.03.13):
  *
  * @ Model
  * @ Simulation
  *    - Time()
  *    @ Model()
  * @ ViewModel
  *    @Model()
  * - Processing Main()
  *    - CityModel()
  *    - CityView()
  *    - Sim()
  * - EpiModel() implements @Model
  *     - Time()
  *     - Pathogen()
  *         * PathogenType
  *     - Agent() extends Element()
  *         - Pathogen()
  *         - Time()
  *         - Element()
  *         * Compartment
  *     - Environment() extends Element()
  *         - Agent()
  *         - Host()
  *     - Host() extends Element()
  *         - Agent()
  *         - Environment()
  *         * Compartment 
  * - CityModel() extends EpiModel()
  *     - Time()
  *     - Schedule()
  *     - BehaviorMap()
  *     - Person() extends Host()
  *         - Place()
  *         * Demographic
  *     - Place() extends Environment()
  *         * LandUse
  *     * Phase
  * - Sim() implements @Simulation
  *    - Time()
  *    @ Model()
  * - View() implements @ViewModel
  *     *ViewParameter
  * - EpiView() extends View()
  *     - EpiModel()
  *     * PersonViewMode
  *     * PlaceViewMode
  * - CityView() extends EpiView()
  *     - CityModel()
  * - Element()
  *     - Coordinate()
  * - Schedule()
  *     - Time()
  *     - TimeInterval()
  *     * TimeUnit
  *     * Phase
  * - BehaviorMap()
  *     - Person()
  *     - Place()
  *     * PlaceCategory
  *     * Demographic
  *     * LandUse
  * - Coordinate()
  * - Time()
  *     * TimeUnit
  * - TimeInterval()
  *     - Time()
  *     * TimeUnit
  */

// Object Model of Epidemic
private CityModel epidemic;

// Visualization Model for Object Model
private CityView viz;

// Auto-run model
private boolean autoRun;

/**
 * setup() runs once at the very beginning
 */
public void setup() {
  
  // Windowed Application Size (pixels)
  size(1200, 1000);
  
  // Force Framerate (frames per second)
  frameRate(10);
  
  // Initialize "Back-End" Object Model
  epidemic = new CityModel();
  configModel();
  
  // Initialize "Front-End" View Model
  viz = new CityView(epidemic);
  configView();
  
  // Initialize auto-run
  autoRun = false;
  
  // Draw Visualization for first frame only
  viz.preDraw(epidemic);
  viz.draw(epidemic);
}

/**
 * draw() runs on an infinite loop after setup() is finished
 */
public void draw() {
  if(autoRun) {
    epidemic.update();
    viz.draw(epidemic);
    //text("Framerate: " + frameRate, width - 225, height - 75);
  }
}

/**
 * keyPressed() runs whenever a key is pressed
 */
public void keyPressed() {
  switch(key) {
    
    // View Controls
    case '1':
      viz.switchToggle(ViewParameter.SHOW_PLACES);
      break;
    case '2':
      viz.switchToggle(ViewParameter.SHOW_PERSONS);
      break;
    case '3':
      viz.switchToggle(ViewParameter.SHOW_COMMUTES);
      break;
    case '4':
      viz.switchToggle(ViewParameter.SHOW_AGENTS);
      break;
    case 'n':
      switch(viz.getPathogenMode()) {
        case PATHOGEN:
          viz.nextPathogen();
          break;
        case PATHOGEN_TYPE:
          viz.nextPathogenType();
          break;
      }
      break;
    case 'q':
      viz.nextAgentMode();
      break;
    case 'e':
      viz.nextPersonMode();
      break;
    case 'w':
      viz.nextPlaceMode();
      viz.preDraw(epidemic);
      break;
    
    // Simulation Controls
    case 'r':
      epidemic = new CityModel();
      configModel();
      viz = new CityView(epidemic);
      configView();
      viz.preDraw(epidemic);
      break;
    case 'z':
      epidemic.allToPrimary();
      break;
    case 'x':
      epidemic.allToSecondary();
      break;
    case 'a': // autoplay
      autoRun = !autoRun;
      break;
    case 's': // step model forward by one tick
      epidemic.update();
      break;
  }
  viz.draw(epidemic);
}
