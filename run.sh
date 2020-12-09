#!/bin/sh
GRAFANA="grafana-csc-4710"
PORT="3000"

ping $GRAFANA -c 3

echo "Loading Grafana customization...."

echo "Creating MYSQL datasource..."
curl -s -X POST -H "Content-Type: application/json" --data @create-mysql-ds.json "http://admin:admin@$GRAFANA:$PORT/api/datasources"
echo ""

echo "Loading dashboards..."
curl -s -X POST -H "Content-Type: application/json" --data @Driver.json "http://admin:admin@$GRAFANA:$PORT/api/dashboards/db"
curl -s -X POST -H "Content-Type: application/json" --data @Manager.json "http://admin:admin@$GRAFANA:$PORT/api/dashboards/db"

echo "Setting user preferences..."
curl -s -X POST -H "Content-Type: application/json" "http://admin:admin@$GRAFANA:$PORT/api/user/stars/dashboard/1"
echo ""

curl -s -X PUT -H "Content-Type: application/json" --data @user-preferences.json "http://admin:admin@$GRAFANA:$PORT/api/user/preferences"
echo ""

echo "Done."
echo "Access now http://$GRAFANA:$PORT"
