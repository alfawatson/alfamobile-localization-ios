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
# TODO: when utilized on CI machine, extract to ENV VARS
lokToken='787fa5f994ceb8af0bbdbf5e60b39ce018050fdd'
frontProjectID='198617855d12e725266131.61448006'
apiProjectId='325570485d2ee5849e1a20.31367908'
lokaliseTempFolder='.lokalise_temp'
lokaliseProjectName='AlfaMobile_Front-Localizable'
​
lokalise --token $lokToken export $frontProjectID --type strings --export_all 1 --export_empty base
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
git add -u
git commit -m "[ci skip] update iOS strings from Travis build stages"
git push origin HEAD || { echo "Failed to push upstream localization submodule"; exit 1; }