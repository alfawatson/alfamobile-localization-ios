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
echo "Localization: export and unzip files"
./lokalise_cli --token $LOKALISE_TOKEN export $LOKALISE_PROJECT_ID --type strings --unzip_to . --export_all 1 --export_empty base
echo "Localization: copying & pushing upstream"
git remote set-url origin https://alfawatson:$GH_TOKEN@github.com/alfawatson/alfamobile-localization-ios.git
git add -u
git commit -m "[skip ci] update iOS strings from Travis build stages"
git push origin HEAD || { echo "Failed to push upstream localization submodule"; exit 1; }
