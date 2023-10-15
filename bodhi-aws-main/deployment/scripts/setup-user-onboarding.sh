read -p 'FIRSTNAME_LASTNAME (Provide the first and last name like (example: rahul-roy)): ' FIRSTNAME_LASTNAME
read -p 'EMAIL_ID (Provide the email id): ' EMAIL_ID
read -p 'GITHUB (Provide the Github repository): ' GITHUB



cp -r ./scripts/firstname-lastname.yaml ./$FIRSTNAME_LASTNAME.yaml
sed -i '' -e 's/%FIRSTNAME_LASTNAME/'"$FIRSTNAME_LASTNAME"'/g;' ./$FIRSTNAME_LASTNAME.yaml 
sed -i '' -e 's/%EMAIL_ID/'"$EMAIL_ID"'/g;' ./$FIRSTNAME_LASTNAME.yaml 
cp -r  ./$FIRSTNAME_LASTNAME.yaml ./distribution-template/user-onboarding/profiles/$FIRSTNAME_LASTNAME.yaml
rm -rf $FIRSTNAME_LASTNAME.yaml
echo "User onboarded $FIRSTNAME_LASTNAME with $EMAIL_ID"
echo "  - profiles/$FIRSTNAME_LASTNAME.yaml" >> ./distribution-template/user-onboarding/kustomization.yaml
./setup-repo-mac.sh configuration/setup.conf
git add .
git commit -m "user-onboarding $FIRSTNAME_LASTNAME"
git push $GITHUB
argocd app sync user-onboarding 