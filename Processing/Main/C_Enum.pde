public enum LandUse {
  DWELLING, OFFICE, RETAIL, SCHOOL, OPENSPACE, HOSPITAL
}

public enum Demographic {
  CHILD, ADULT, SENIOR
}

public enum Compartment {
  SUSCEPTIBLE, EXPOSED, INFECTIOUS, RECOVERED, DEAD
}

public enum Symptom {
  FEVER, COUGH, SHORTNESS_OF_BREATH, FATIGUE, MUSCLE_ACHE, DIARRHEA
}

public enum PathogenType { 
  COVID_19, COMMON_COLD
}

public enum Day { 
  MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

public enum TimeUnit { 
  MILLISECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, YEAR;
}

public enum Phase {
  HOME, GO_WORK, WORK, WORK_LUNCH, LEISURE, GO_HOME, HOSPITAL
}

public enum PersonViewMode {
  DEMOGRAPHIC, COMPARTMENT
}

public enum PlaceViewMode {
  LANDUSE, DENSITY
}
