#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

RETURN_DATA(){
  MASS=$($PSQL "select atomic_mass from properties where atomic_number = $ATOM")
  MELTING=$($PSQL "select melting_point_celsius from properties where atomic_number = $ATOM")
  BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number = $ATOM")
  TYPE=$($PSQL "select type from types left join properties using(type_id) where atomic_number = $ATOM")
  echo "The element with atomic number $ATOM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
}

NOT_FOUND(){
echo "I could not find that element in the database."
}


if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1  =~ ^[0-9]+$ ]]
  then
    ATOM=$($PSQL "select atomic_number from elements where atomic_number = $1")
    if [[ -z $ATOM ]]
    then
      NOT_FOUND
    else
      SYMBOL=$($PSQL "select symbol from elements where atomic_number = $ATOM")
      NAME=$($PSQL "select name from elements where atomic_number = $ATOM")
      RETURN_DATA 
    fi
  else
      SYMBOL=$($PSQL "select symbol from elements where symbol = '$1'")
      if [[ -z $SYMBOL ]]
      then
        NAME=$($PSQL "select name from elements where name = '$1'")
        if [[ -z $NAME ]]
        then
          NOT_FOUND
        else
          SYMBOL=$($PSQL "select symbol from elements where name = '$NAME'")
          ATOM=$($PSQL "select atomic_number from elements where name = '$NAME'")
          RETURN_DATA 
        fi
      else
        NAME=$($PSQL "select name from elements where symbol = '$SYMBOL'")
        ATOM=$($PSQL "select atomic_number from elements where symbol = '$SYMBOL'")
        RETURN_DATA 
      fi
    fi
  fi



