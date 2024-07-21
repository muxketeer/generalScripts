#!/usr/bin/env bash


#REQUIRES ALL VARIABLE NAMES TO BE IN ALL CAPS

#create and parse variables as past to the given function. I.E.would be called via: myfunction myvariable="my variable value" nonOrderDependantVar="some value"
parseArgs(){
for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

}



#sets all the arguments back to having an empty value
de-parseArgs(){
for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

  unset "$KEY"
done

}


#private test function
__testVariables(){

    __parseArgs "$@"
    echo testVariable = "'$TEST_VARIABLE'"
    echo settings = $SETTINGS

    __de-parseArgs "$@"

}