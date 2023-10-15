#!/bin/bash

export DISTRIBUTION=distribution
rm -rf ${DISTRIBUTION}
cp -r distribution-template ${DISTRIBUTION}
#cp -r setup-root.conf configuration/setup-config.conf

# Perform a simple recursive find-and-replace on all variables defined in setup.conf
export SETUP_CONF_PATH=$1 # location of the setup config
export DISTRIBUTION_PATH=./${DISTRIBUTION} # folder where the distribution's YAML files are to be found


while IFS="=" read PLACEHOLDER VALUE # While loop that will perform simple parsing. On each line MY_VAR=123 will be read into PLACEHOLDER=MY_VAR, VALUE=123
do
  # recursively look for $PLACEHOLDER in all files in the $DISTRIBUTION_PATH and replace it with $VALUE
  VALUE=$(echo "${VALUE////$'\/'}") #escape forward slashes (need for sed to work correctly)
  grep -rli ${PLACEHOLDER} ${DISTRIBUTION_PATH}/* | xargs -I@ sed -i '' "s/${PLACEHOLDER}/${VALUE}/g" @ #perform recursive replace
done <${SETUP_CONF_PATH} # pass the setup config into the while loop
