#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -A -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ [0-9]+ ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1;")
  else
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' or symbol = '$1';")
  fi
  
  if [[ -z $ELEMENT_INFO ]]
  then
    echo I could not find that element in the database.
  else
    IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< $ELEMENT_INFO
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
