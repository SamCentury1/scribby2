class Helpers {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


  String fixForCharacter(String s, String character) {
    List<String> strings = s.split(character);
    List<String> newList = [];
    for (String item in strings) {
      newList.add(capitalize(item));
    }
    String stringsCleaned = newList.join(character); 
    return stringsCleaned;
  }

  String capitalizeName(String s) {

    
    String stringWitoutSpaces = fixForCharacter(s," ");
    String stringWithoutDashes = fixForCharacter(stringWitoutSpaces, "-");
    String stringWithoutPeriods = fixForCharacter(stringWithoutDashes, ".");

    return stringWithoutPeriods;
  }

}