/** 
 * Planetary Insight Center 
 * Agent Based Simulation of Epidemic
 * Ira Winder, jiw@mit.edu
 *
 * Epidemiological Model:
 *
 *   Pathogen: 
 *     The pathogen is the microorganism that actually causes the disease in question. 
 *     An pathogen could be some form of bacteria, virus, fungus, or parasite.
 *
 *   Agent:
 *     Agents are the vessels by which Pathogens spread. In a model there may be
 *     numerous Agents referencing the same generic Pathogen definition.
 *
 *   Host:  
 *     The agent infects the host, which is the organism that carries the disease. 
 *     A host doesn’t necessarily get sick; hosts can act as carriers for an agent 
 *     without displaying any outward symptoms of the disease. Hosts get sick or 
 *     carry an agent because some part of their physiology is hospitable or 
 *     attractive to the agent.
 *
 *   Compartment:  
 *     The Host's compartment with respect to a Pathogen 
 *     (Suceptible, Incubating, Infectious, Recovered, or Dead)
 *
 *     Compartmental models in epidemiology (Susceptible, Infectious, Carrier, Recovered):
 *       https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology
 *     Clade X Model (Susceptible, Incubating, Infectious (Mild or sever), Convalescent, Hospitalized, Recovered, Dead):
 *       http://www.centerforhealthsecurity.org/our-work/events/2018_clade_x_exercise/pdfs/Clade-X-model.pdf
 *     GLEAMviz Models:
 *       http://www.gleamviz.org/simulator/models/
 *
 *   Environment: 
 *     Outside factors can affect an epidemiologic outbreak as well; collectively 
 *     these are referred to as the environment. The environment includes any 
 *     factors that affect the spread of the disease but are not directly a part of 
 *     the agent or the host. For example, the temperature in a given location might 
 *     affect an agent’s ability to thrive, as might the quality of drinking water 
 *     or the accessibility of adequate medical facilities.
 *  
 *   Refer to Model of the Epidemiological Triangle:
 *   https://www.rivier.edu/academics/blog-posts/what-is-the-epidemiologic-triangle/
 *
 * Person Model: A Person is a human Host Element that may carry and/or transmit an Agent
 *
 *   Demographic:
 *     Host's attributes that affect its suceptibility to a Pathogen (e.g. Child, Adult, Senior)
 *
 *   Primary Place:
 *     The host's primary residence when they are not working or shopping. This often
 *     represents a dwelling with multiple household memebers
 *
 *   Secondary Place:  
 *     The Place where the host usually spends their time during the day. This is
 *     often at an office or employer for adults, or at school for children.
 *
 *   Tertiary Place: 
 *     All other Places that a host may spend their time throughout the day. This
 *     includes shopping, walking, commuting, dining, etc.
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
 *
 * TimeDistribution Model: 
 * Utility Class for Generating Time Values within a Gaussian Distribution
 *
 *                     1x Std. Dev.
 *
 * |                    |     |
 * |                  .-|-.   |
 * |                -   |  -  |
 * |               /    |    \|
 * |            _ |     |     | _
 * |         _    |     |     |    _ 
 * |__._._-_|_____|_____|_____|_____|_-_.__.__
 *                      ^
 *                   Average (mean)
 *
 * Object Map Legend:
 *   - Class() dependency
 *   * Enum dependency
 *   @ Interface
 * 
 * Object Map:
 *
 * @ Model
 * - Processing Main()
 *    - CityModel()
 *    - ResultSeries()
 *         - Time()
 *         - Result()
 *    - ResultView()
 *         - CityModel()
 *         - ResultSeries()
 *         - ResultSeries()
 *         - BarGraph()
 *         - GraphAxes()
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
 *         - PathogenEffect()
 *         - Agent()
 *         - Environment()
 *         * Compartment 
 * - CityModel() extends EpiModel()
 *     - Time()
 *     - Schedule()
 *     - ChoiceModel()
 *     - Person() extends Host()
 *         - Place()
 *         * Demographic
 *     - Place() extends Environment()
 *         * LandUse
 *     * Phase
 * - ChoiceModel()
 *     - Person()
 *     - Place()
 *     * PlaceCategory
 *     * Demographic
 *     * LandUse
 * - ViewModel() extends ViewAttributes()
 *     * ViewParameter
 * - EpiView() extends ViewModel()
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
 * - Coordinate()
 * - Time()
 *     * TimeUnit
 * - TimeInterval()
 *     - Time()
 *     * TimeUnit
 */

// Main canvas for drawing
var canvas;

// Best guess at typical scroll bar width (in pixels)
var SCROLL_BAR_WIDTH = 15;

// // In-memory Object Model of Epidemic in a City
// var epidemic = new CityModel();

// // Sequence of model results comprising a simulation over time
// var outcome = new ResultSeries();

// // Visualization Model for Epidemic Model, City Model, and Results
// var viz = new ResultView();
var viz;

var frameCounter;

/**
 * setup() runs once at the very beginning
 */
 function setup() {
	// Set canvas to fill web browser window
	let x = windowWidth - SCROLL_BAR_WIDTH;
	let y = windowHeight - SCROLL_BAR_WIDTH;
	canvas = createCanvas(x, y);
	canvas.position(SCROLL_BAR_WIDTH/2, SCROLL_BAR_WIDTH/2);

	test();
}

function windowResized() {
	let x = windowWidth - SCROLL_BAR_WIDTH;
	let y = windowHeight - SCROLL_BAR_WIDTH;
	resizeCanvas(x, y);
}

/**
 * draw() runs on an infinite loop after setup() is finished
 */
 function draw() {
 	ellipse(mouseX, mouseY, 50, 50);
 }

// Test Functions as I move them here:
function test() {
	console.log("test!");


	viz = new ViewAttributes();

	viz.setName(Demographic.CHILD, "Childish Gambino");
	let name = viz.getName(Demographic.CHILD);
	console.log(Demographic.CHILD, name);

	let colorIn = color(100);
	viz.setColor(Demographic.CHILD, colorIn);
	let colorOut = viz.getColor(Demographic.CHILD);
	console.log(colorOut);
	fill(colorOut);
	ellipse(100, 50, 50, 50);

	viz.setToggle(Demographic.CHILD, true);
	let toggle = viz.getToggle(Demographic.CHILD);
	console.log(toggle);

	viz.switchToggle(Demographic.CHILD);
	let toggleSwitched = viz.switchToggle(Demographic.CHILD);
	console.log(toggleSwitched);

	viz.setValue(Demographic.CHILD, 22.2);
	let value = viz.getValue(Demographic.CHILD);
	console.log(value);

	let mappedColor = viz.mapToGradient(25, 0, 100, 0, 90, 100, 255);
	fill(mappedColor);
	ellipse(50, 50, 50, 50);
}

/**
 * Structured list of view parameters such as colors, lables, values, etc
 */
function ViewAttributes() {
	// this.viewColor  = new HashMap<Enum, Integer>();
	// this.viewName   = new HashMap<Enum, String>();
	// this.viewValue  = new HashMap<Enum, Double>();
	// this.viewToggle = new HashMap<Enum, Boolean>();
	this.viewColor  = new Map();
	this.viewName   = new Map();
	this.viewValue  = new Map();
	this.viewToggle = new Map();

	/**
	* Add a color association to a specified Enum
	*
	* @param e Enum
	* @param col color
	*/
	this.setColor = function(e, col) {
		this.viewColor.set(e, col);
	}

	/**
	* Add a name association to a specified Enum
	*
	* @param e Enum
	* @param name String
	*/
	this.setName = function(e, name) {
		this.viewName.set(e, name);
	}

	/**
	* Add a size association to a specified Enum
	*
	* @param e Enum
	* @param size double
	*/
	this.setValue = function(e, size) {
		this.viewValue.set(e, size);
	}

	/**
	* Add a size association to a specified Enum
	*
	* @param e Enum
	* @param toggle double
	*/
	this.setToggle = function(e, toggle) {
		this.viewToggle.set(e, toggle);
	}

	/**
	* Get Color Associated with Enum
	*
	* @param e Enum
	* @return color
	*/
	this.getColor = function(e) {
		if(this.viewColor.has(e)) {
			return this.viewColor.get(e);
		} else {
	  		return color(0); // default black
		}
	}

	/**
	* Get Name Associated with Enum
	*
	* @param e Enum
	* @return name
	*/
    this.getName = function(e) {
   		if(this.viewName.has(e)) {
   			return this.viewName.get(e);
   		} else {
      		return ""; // default blank
  		}
	}

  	/**
   	 * Get Value Associated with Enum
   	 *
   	 * @param e Enum
   	 * @return size
   	 */
   	this.getValue = function(e) {
   		if(this.viewValue.has(e)) {
   			return this.viewValue.get(e);
   		} else {
    	  	return 0; // default blank
  		}
	}

	/**
	* Get Toggle Associated with Enum
	*
	* @param e Enum
	* @return toggle Boolean
	*/
	this.getToggle = function(e) {
   		if(this.viewToggle.has(e)) {
   			return this.viewToggle.get(e);
   		} else {
   			return false;
   		}
   	}

	/**
	* Switch Toggle Associated with Enum
	*
	* @param e Enum
	* @return new toggle status
	*/
	this.switchToggle = function(e) {
		if(this.viewToggle.has(e)) {
			let status = !this.viewToggle.get(e);
			this.viewToggle.set(e, status);
			return status;
		} 

		// Create a new toggle set to true if no toggle exists
		else {
			this.setToggle = setToggle(e, TRUE);
			return this.getToggle(e);
		}
	}

	/** 
	* Map a value to a specific color between two hues
	*
	* @param value
	* @param v1
	* @param v2
	* @param hue1
	* @param hue2
	* @param sat1
	* @param sat2
	*/
	this.mapToGradient = function(value, v1, v2, hue1, hue2, sat1, sat2) {

	   	let FULL = 255;
	   	let ratio = (value - v1) / (v2 - v1);

	   	let hue = int(hue1 + ratio * (hue2 - hue1));
	   	hue = abs(hue);
	   	hue = max(hue, hue1);
	   	hue = min(hue, hue2);

	   	let sat = int(sat1 + ratio * (sat2 - sat1));

	   	colorMode(HSB);
	   	let map = color(hue, sat, FULL - sat, FULL);
	   	colorMode(RGB);
	   	return map;
   	}

	/**
	* Draw a circle around a circular object at a specified location to show it's selected
	*
	* @param x
	* @param y
	* @param selectedDiamter Diameter of object you wish to select, in pixels
	*/
	this.drawSelection = function(x, y, selectedDiameter) {
		let selectionStroke   = int(this.getValue(ViewParameter.TEXT_FILL));
		let selectionAlpha    = int(this.getValue(ViewParameter.REDUCED_ALPHA));
		let selectionWeight   = int(this.getValue(ViewParameter.SELECTION_WEIGHT));
		let selectionDiameter = int(this.getValue(ViewParameter.SELECTION_SCALER) * selectedDiameter);

		strokeWeight(selectionWeight);
		stroke(selectionStroke, selectionAlpha);
		noFill();
		ellipse(int(x), int(y), selectionDiameter, selectionDiameter);
		strokeWeight(1); // back to default stroke weight
	}
}

// Enums
const LandUse = {
	DWELLING: 'DWELLING', 
	OFFICE: 'OFFICE', 
	RETAIL: 'RETAIL', 
	SCHOOL: 'SCHOOL', 
	PUBLIC: 'PUBLIC', 
	HOSPITAL: 'HOSPITAL'
}

const PlaceCategory = {
	PRIMARY: 'PRIMARY', 
	SECONDARY: 'SECONDARY', 
	TERTIARY: 'TERTIARY'
}

const Demographic = {
	CHILD: 'CHILD', 
	ADULT: 'ADULT', 
	SENIOR: 'SENIOR'
}

const Compartment = {
	SUSCEPTIBLE: 'SUSCEPTIBLE', 
	RECOVERED: 'RECOVERED', 
	INCUBATING: 'INCUBATING', 
	INFECTIOUS: 'INFECTIOUS',
	DEAD_TREATED: 'DEAD_TREATED',
	DEAD_UNTREATED: 'DEAD_UNTREATED'
}

const Symptom = {
	FEVER: 'FEVER', 
	COUGH: 'COUGH', 
	SHORTNESS_OF_BREATH: 'SHORTNESS_OF_BREATH', 
	FATIGUE: 'FATIGUE', 
	MUSCLE_ACHE: 'MUSCLE_ACHE', 
	DIARRHEA: 'DIARRHEA'
}

const PathogenType = { 
	RHINOVIRUS: 'RHINOVIRUS', 
	CORONAVIRUS: 'CORONAVIRUS',
	INFLUENZA: 'INFLUENZA'
  // Add more?
}

const Day = { 
	MONDAY: 'MONDAY', 
	TUESDAY: 'TUESDAY', 
	WEDNESDAY: 'WEDNESDAY', 
	THURSDAY: 'THURSDAY', 
	FRIDAY: 'FRIDAY', 
	SATURDAY: 'SATURDAY', 
	SUNDAY: 'SUNDAY'
}

const TimeUnit = { 
	MILLISECOND: 'MILLISECOND', 
	SECOND: 'SECOND', 
	MINUTE: 'MINUTE', 
	HOUR: 'HOUR', 
	DAY: 'DAY', 
	WEEK: 'WEEK', 
	MONTH: 'MONTH', 
	YEAR: 'YEAR'
}

const Phase = {
	SLEEP: 'SLEEP', 
	HOME: 'HOME', 
	GO_WORK: 'GO_WORK', 
	WORK: 'WORK', 
	WORK_LUNCH: 'WORK_LUNCH', 
	LEISURE: 'LEISURE', 
	GO_HOME: 'GO_HOME'
}

const AgentMode = {
	PATHOGEN: 'PATHOGEN', 
	PATHOGEN_TYPE: 'PATHOGEN_TYPE'
}
const PersonMode = {
	DEMOGRAPHIC: 'DEMOGRAPHIC', 
	COMPARTMENT: 'COMPARTMENT'
}

const PlaceMode = {
	LANDUSE: 'LANDUSE', 
	DENSITY: 'DENSITY'
}

const ViewParameter = {
	AUTO_RUN: 'AUTO_RUN',
	FRAMES_PER_SIMULATION: 'FRAMES_PER_SIMULATION',
	SHOW_PERSONS: 'SHOW_PERSONS',
	SHOW_COMMUTES: 'SHOW_COMMUTES',
	SHOW_PLACES: 'SHOW_PLACES',
	SHOW_AGENTS: 'SHOW_AGENTS',
	SHOW_FRAMERATE: 'SHOW_FRAMERATE',
	TEXT_HEIGHT: 'TEXT_HEIGHT', 
	TEXT_FILL: 'TEXT_FILL', 
	ENVIRONMENT_SCALER: 'ENVIRONMENT_SCALER',
	ENVIRONMENT_STROKE: 'ENVIRONMENT_STROKE', 
	ENVIRONMENT_DIAMETER: 'ENVIRONMENT_DIAMET∏ER', 
	ENVIRONMENT_ALPHA: 'ENVIRONMENT_ALPHA', 
	MIN_DENSITY: 'MIN_DENSITY',
	MAX_DENSITY: 'MAX_DENSITY',
	MIN_DENSITY_HUE: 'MIN_DENSITY_HUE',
	MAX_DENSITY_HUE: 'MAX_DENSITY_HUE', 
	MIN_DENSITY_SAT: 'MIN_DENSITY_SAT',
	MAX_DENSITY_SAT: 'MAX_DENSITY_SAT', 
	AGENT_WEIGHT: 'AGENT_WEIGHT', 
	AGENT_ALPHA: 'AGENT_ALPHA',
	AGENT_SCALER: 'AGENT_SCALER',
	HOST_DIAMETER: 'HOST_DIAMETER', 
	HOST_STROKE: 'HOST_STROKE', 
	HOST_ALPHA: 'HOST_ALPHA', 
	COMMUTE_STROKE: 'COMMUTE_STROKE',
	COMMUTE_WEIGHT: 'COMMUTE_WEIGHT',
	REDUCED_ALPHA: 'REDUCED_ALPHA',
	LEFT_PANEL_WIDTH: 'LEFT_PANEL_WIDTH',
	RIGHT_PANEL_WIDTH: 'RIGHT_PANEL_WIDTH',
	GENERAL_MARGIN: 'GENERAL_MARGIN',
	INFO_Y: 'INFO_Y',
	PATHOGEN_LEGEND_Y: 'PATHOGEN_LEGEND_Y',
	PERSON_LEGEND_Y: 'PERSON_LEGEND_Y',
	PLACE_LEGEND_Y: 'PLACE_LEGEND_Y',
	SELECTION_WEIGHT: 'SELECTION_WEIGHT',
	SELECTION_SCALER: 'SELECTION_SCALER',
	GRAPH_HEIGHT: 'GRAPH_HEIGHT',
	GRAPH_LABEL_Y: 'GRAPH_LABEL_Y',
	GRAPH_BAR_WIDTH: 'GRAPH_BAR_WIDTH',
	GRAPH_ALPHA: 'GRAPH_ALPHA',
	AXES_STROKE: 'AXES_STROKE'
}

const TimePlot = {
	COMPARTMENT: 'COMPARTMENT',
	HOSPITALIZED: 'HOSPITALIZED',
	ENCOUNTER: 'ENCOUNTER',
	SYMPTOM: 'SYMPTOM',
	TRIP: 'TRIP'
}