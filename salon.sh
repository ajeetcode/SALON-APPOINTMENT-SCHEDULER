#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES_MENU(){

if [[ $1 ]]
then 
    echo -e "\n$1"
fi

AVAILABLE_SERVICES=$($PSQL "SELECT service_id,name FROM services")

echo -e "\nWhat service you want ?"
echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE
do 
    echo "$SERVICE_ID) $SERVICE"
done

}
SERVICES_MENU

echo -e "\nWhich service you want ?"
read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]$ ]]
then
   SERVICES_MENU "Please Enter a correct service number"
else
   echo -e "\nWhat is your phone number ?"
   read CUSTOMER_PHONE
   
fi

ALREADY_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
   

if [[ -z $ALREADY_CUSTOMER_NAME ]]
then 
    echo -e "\nWhat is your name ?"
    read CUSTOMER_NAME
    NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi

echo -e "\nAt What time you want the service ?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")


SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

