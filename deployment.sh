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
    #$COMPOSER update && echo "Complete composer update"
fi

echo "Magento deploy"
echo "Deleting cache and view files"
rm -rf var/cache/* var/view_preprocessed/* var/page_cache/* pub/static/* generated/* && echo "magento temp files cleared"

$PHP $MAGENTO setup:upgrade &&
$PHP $MAGENTO cache:enable &&

$PHP $MAGENTO setup:di:compile &&
$PHP $MAGENTO setup:static-content:deploy $LANGUAGES -f &&
$PHP $MAGENTO indexer:reindex &&
$PHP $MAGENTO cache:clean &&
$PHP $MAGENTO maintenance:disable &&

echo "Deploy completed 🎉"
