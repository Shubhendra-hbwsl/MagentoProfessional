#!/bin/bash

LANGUAGES="en_US"

# production or developer
ENVIRONMENT="developer"

COMPOSER=$(which composer)
PHP=$(which php)
ROOT=$(pwd)
MAGENTO=$(pwd)'/bin/magento'

echo "Magento maintenance mode enable"
$PHP $MAGENTO maintenance:enable &&

# Merge the remote dev, check the merge returns a non-zero code for merge-errors
echo "Merging the changes into dev branch"
git pull origin production &&

echo "Composer"
if [ "$ENVIRONMENT" == "production" ]; then
    $COMPOSER install --no-dev
else
    echo "Running composer install"
    $COMPOSER update && echo "Complete composer update"
fi

echo "Magento deploy"
echo "Deleting cache and view files"
rm -rf var/cache/* var/view_preprocessed/* var/page_cache/* pub/static/* generated/* && echo "magento temp files cleared"

$PHP $MAGENTO setup:upgrade &&
$PHP $MAGENTO cache:enable &&


 if [ "$ENVIRONMENT" == "production" ]; then
     echo "Production deploy"
     $PHP $MAGENTO deploy:mode:set production --skip-compilation &&
     $PHP $MAGENTO config:set dev/js/move_script_to_bottom 1 &&
     $PHP $MAGENTO config:set dev/js/enable_js_bundling 0 &&
     $PHP $MAGENTO config:set dev/js/merge_files 1 &&
     $PHP $MAGENTO config:set dev/js/minify_files 0 &&
     $PHP $MAGENTO config:set design/head/default_robots 'NOINDEX,NOFOLLOW' &&
     $PHP $MAGENTO config:set google/analytics/active 1
 else
# # There seems to some problem with below code block, when uncommented it throws syntax error, fi unexpected token and no, fi is used correctly, this shows same error when below code block is pasted in 
# # composer if block
#
     echo "Development deploy"
     $PHP $MAGENTO deploy:mode:set developer &&
     $PHP $MAGENTO config:set dev/js/move_script_to_bottom 0 &&
     $PHP $MAGENTO config:set dev/js/enable_js_bundling 0 &&
     $PHP $MAGENTO config:set dev/js/merge_files 0 &&
     $PHP $MAGENTO config:set dev/js/minify_files 0 &&
     $PHP $MAGENTO config:set google/analytics/active 0 &&
     # $PHP $MAGENTO config:set design/head/default_robots 'NOINDEX,NOFOLLOW'
 fi

$PHP $MAGENTO setup:di:compile &&
$PHP $MAGENTO setup:static-content:deploy $LANGUAGES -f &&
$PHP $MAGENTO indexer:reindex &&
$PHP $MAGENTO cache:clean &&
$PHP $MAGENTO maintenance:disable &&

echo "Deploy completed 🎉"
