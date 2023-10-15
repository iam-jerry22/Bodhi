#!/bin/bash
sed 's/"//g' infra/output.conf | tee infra/output_converted.conf #to remove the inverted commas from the output file and save in output converted file
sed -i "" 's/ //g' infra/output_converted.conf #to remove the blank space from output converted file
cp -r templates/setup-template.conf deployment/configuration/setup.conf #copy setup_template file to setup.conf file

# Perform a simple recursive find-and-replace on all variables defined in setup.conf
export VARIABLE_FILE=infra/output_converted.conf # location of the setup config
export DESTINATION_FILE=deployment/configuration/setup.conf # folder where the distribution's YAML files are to be found


while IFS="=" read PLACEHOLDER VALUE # While loop that will perform simple parsing. On each line MY_VAR=123 will be read into PLACEHOLDER=MY_VAR, VALUE=123
do
  # recursively look for $PLACEHOLDER in all files in the $DESTINATION_FILE and replace it with $VALUE
  grep -rli ${PLACEHOLDER} ${DESTINATION_FILE} | xargs sed -i '' "s!${PLACEHOLDER}!${VALUE}!g" #perform recursive replace
done <${VARIABLE_FILE} # pass the setup config into the while loop
