# travel-agency
a demonstration for parallel ballerina services which is running with the version 2201.4.0
## Steps to execute
1. Start backend services
2. Start the /travel service
3. Execute the following command
   ```
   curl http://localhost:9090/travel/arrangeTour -H "Content-Type:application/json" -v -d '{"ArrivalDate":"12-03-2018", "DepartureDate":"13-04-2018", "From":"Colombo",
   "To":"Changi", "VehicleType":"Car", "Location":"Changi"}'
   ```
