#!/bin/bash -       
#description	:Локально запускаемый скрипт для выгрузки последних текстов iOS локализаций
#author		 	:Azamat Kalmurzayev
#usage		 	:bash ci_lokalise_update_submodule.sh
#===================================================================
​

# Prerequisites:
# - установленный lokalise CLI на машине
# - залогиненный github account на локальной машине
# - сообщить администратору Lokalise проекта свой github account
​
lokaliseTempFolder='.lokalise_temp'
lokaliseProjectName='AlfaMobile_Front-Localizable'
​
lokalise_cli --token $LOKALISE_TOKEN export $LOKALISE_PROJECT_ID --type strings --export_all 1 --export_empty base
if [ -z $lokaliseProjectName.zip ]
then
    echo "No $lokaliseProjectName.zip file found"
    exit 1
fi
echo "MainProject: Updating remotely localization submodule"
mkdir $lokaliseTempFolder
unzip -o $lokaliseProjectName.zip -d $lokaliseTempFolder
​
echo "Localization: copying & pushing upstream"
cp -r $lokaliseTempFolder/* .

git remote set-url origin https://alfawatson:$GH_TOKEN@github.com/alfawatson/alfamobile-localization-ios.git
git add -u
git commit -m "[ci skip] update iOS strings from Travis build stages"
git push origin HEAD || { echo "Failed to push upstream localization submodule"; exit 1; }
