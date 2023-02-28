import ballerina/http;
import ballerina/log;
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;

// Service endpoint
listener http:Listener travelAgencyEP = new (9090);

// Client endpoint to communicate with Airline reservation service
http:Client airlineEP = check new ("http://localhost:9091/airline");

// Client endpoint to communicate with Hotel reservation service
http:Client hotelEP = check new ("http://localhost:9092/hotel");

// Client endpoint to communicate with Car rental service
http:Client carRentalEP = check new ("http://localhost:9093/car");

// Travel agency service to arrange a complete tour for a user
service /travel on travelAgencyEP {

    // Resource to arrange a tour
    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post arrangeTour(http:Caller caller, http:Request inRequest) returns error? {
        http:Response outResponse = new;
        map<json> inReqPayload = {};

        // Try parsing the JSON payload from the request
        var payload = inRequest.getJsonPayload();
        if (payload is error) {
            outResponse.statusCode = 400;
            outResponse.setJsonPayload({"Message": "Invalid payload - Not a valid JSON payload"});
            error? res = caller->respond(outResponse);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        } else {
            inReqPayload = <map<json>>payload;
        }

        json arrivalDate = inReqPayload["ArrivalDate"];
        json departureDate = inReqPayload["DepartureDate"];
        json fromPlace = inReqPayload["From"];
        json toPlace = inReqPayload["To"];
        json vehicleType = inReqPayload["VehicleType"];
        json location = inReqPayload["Location"];

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate == () || departureDate == () || fromPlace == () || toPlace == () ||
        vehicleType == () || location == ()) {
            outResponse.statusCode = 400;
            outResponse.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(outResponse);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        }

        // Out request payload for Airline reservation service
        json flightPayload = {
            "ArrivalDate": <json>arrivalDate,
            "DepartureDate": <json>departureDate,
            "From": <json>fromPlace,
            "To": <json>toPlace
        };
        // Out request payload for Hotel reservation service
        json hotelPayload = {"ArrivalDate": arrivalDate, "DepartureDate": departureDate, "Location": location};
        // Out request payload for Car rental service
        json vehiclePayload = {"ArrivalDate": arrivalDate, "DepartureDate": departureDate, "VehicleType": vehicleType};

        json jsonFlightResponse = {};
        json jsonVehicleResponse = {};
        json jsonHotelResponse = {};
        json miramarJsonResponse = {};
        json aqueenJsonResponse = {};
        json elizabethJsonResponse = {};
        json jsonFlightResponseEmirates = {};
        json jsonFlightResponseAsiana = {};
        json jsonFlightResponseQatar = {};

        // Airline reservation
        // Call Airline reservation service and consume different resources in parallel to check different airways
        // fork to run parallel workers and join the results
        fork {
            // Worker to communicate with airline 'Qatar Airways'
            worker qatarWorker returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>flightPayload);
                // Send a POST request to 'Qatar Airways' and get the results
                http:Response|http:ClientError respWorkerQuatar = airlineEP->post("/qatarAirways", outReq);
                // Reply to the join block from this worker - Send the response from 'Qatar Airways'
                if (respWorkerQuatar is http:Response) {
                    return respWorkerQuatar;
                }
                return;
            }

            // Worker to communicate with airline 'Asiana'
            worker asianaWorker returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>flightPayload);
                // Send a POST request to 'Asiana' and get the results
                http:Response|http:ClientError respWorkerAsiana = airlineEP->post("/asiana", outReq);
                // Reply to the join block from this worker - Send the response from 'Asiana'
                if (respWorkerAsiana is http:Response) {
                    return respWorkerAsiana;
                }
                return;
            }

            // Worker to communicate with airline 'Emirates'
            worker emiratesWorker returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>flightPayload);
                // Send a POST request to 'Emirates' and get the results
                http:Response|http:ClientError respWorkerEmirates = airlineEP->post("/emirates", outReq);
                // Reply to the join block from this worker - Send the response from 'Emirates'
                if (respWorkerEmirates is http:Response) {
                    return respWorkerEmirates;
                }
                return;
            }
        }

        // Wait until the responses received from all the workers running in parallel
        record {
            http:Response? qatarWorker;
            http:Response? asianaWorker;
            http:Response? emiratesWorker;
        } airlineResponses = wait {qatarWorker, asianaWorker, emiratesWorker};

        int qatarPrice = -1;
        int asianaPrice = -1;
        int emiratesPrice = -1;

        // Get the response and price for airline 'Qatar Airways'
        var resQatar = airlineResponses["qatarWorker"];
        if (resQatar is http:Response) {
            var flightResponseQutar = resQatar.getJsonPayload();
            if (flightResponseQutar is json) {
                jsonFlightResponseQatar = flightResponseQutar;
                var qatarResult = jsonFlightResponseQatar.Price;
                if (qatarResult is int) {
                    qatarPrice = qatarResult;
                }
            }
        }

        // Get the response and price for airline 'Asiana'
        var resAsiana = airlineResponses["asianaWorker"];
        if (resAsiana is http:Response) {
            var flightResponseAsia = resAsiana.getJsonPayload();
            if (flightResponseAsia is json) {
                jsonFlightResponseAsiana = flightResponseAsia;
                var asianaResult = jsonFlightResponseAsiana.Price;
                if (asianaResult is int) {
                    asianaPrice = asianaResult;
                }
            }
        }

        // Get the response and price for airline 'Emirates'
        var resEmirates = airlineResponses["emiratesWorker"];
        if (resEmirates is http:Response) {
            var flightResponseEmirates = resEmirates.getJsonPayload();
            if (flightResponseEmirates is json) {
                jsonFlightResponseEmirates = flightResponseEmirates;
                var emiratesResult = jsonFlightResponseEmirates.Price;
                if (emiratesResult is int) {
                    emiratesPrice = emiratesResult;
                }
            }
        }

        // Select the airline with the least price
        if (qatarPrice < asianaPrice) {
            if (qatarPrice < emiratesPrice) {
                jsonFlightResponse = jsonFlightResponseQatar;
            }
        } else {
            if (asianaPrice < emiratesPrice) {
                jsonFlightResponse = jsonFlightResponseAsiana;
            } else {
                jsonFlightResponse = jsonFlightResponseEmirates;
            }
        }

        // Hotel reservation
        // Call Hotel reservation service and consume different resources in parallel to check different hotels
        // fork to run parallel workers and join the results
        fork {
            // Worker to communicate with hotel 'Miramar'
            worker miramar returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>hotelPayload);
                // Send a POST request to 'Asiana' and get the results
                http:Response|http:ClientError respWorkerMiramar = hotelEP->post("/miramar", outReq);
                // Reply to the join block from this worker - Send the response from 'Asiana'
                if (respWorkerMiramar is http:Response) {
                    return respWorkerMiramar;
                }
                return;
            }

            // Worker to communicate with hotel 'Aqueen'
            worker aqueen returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>hotelPayload);
                // Send a POST request to 'Aqueen' and get the results
                http:Response|http:ClientError respWorkerAqueen = hotelEP->post("/aqueen", outReq);
                // Reply to the join block from this worker - Send the response from 'Aqueen'
                if (respWorkerAqueen is http:Response) {
                    return respWorkerAqueen;
                }
                return;
            }

            // Worker to communicate with hotel 'Elizabeth'
            worker elizabeth returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>hotelPayload);
                // Send a POST request to 'Elizabeth' and get the results
                http:Response|http:ClientError respWorkerElizabeth = hotelEP->post("/elizabeth", outReq);
                // Reply to the join block from this worker - Send the response from 'Elizabeth'
                if (respWorkerElizabeth is http:Response) {
                    return respWorkerElizabeth;
                }
                return;
            }
        }

        record {http:Response? miramar; http:Response? aqueen; http:Response? elizabeth;} hotelResponses =
        wait {miramar, aqueen, elizabeth};

        // Wait until the responses received from all the workers running in parallel
        int miramarDistance = -1;
        int aqueenDistance = -1;
        int elizabethDistance = -1;

        // Get the response and distance to the preferred location from the hotel 'Miramar'
        var responseMiramar = hotelResponses["miramar"];
        if (responseMiramar is http:Response) {
            var mirmarPayload = responseMiramar.getJsonPayload();
            if (mirmarPayload is json) {
                miramarJsonResponse = mirmarPayload;
                var miramarDistanceResult = miramarJsonResponse.DistanceToLocation;
                if (miramarDistanceResult is int) {
                    miramarDistance = miramarDistanceResult;
                }
            }
        }

        // Get the response and distance to the preferred location from the hotel 'Aqueen'
        var responseAqueen = hotelResponses["aqueen"];
        if (responseAqueen is http:Response) {
            var aqueenPayload = responseAqueen.getJsonPayload();
            if (aqueenPayload is json) {
                aqueenJsonResponse = aqueenPayload;
                var aqueenDistanceResult = aqueenJsonResponse.DistanceToLocation;
                if (aqueenDistanceResult is int) {
                    aqueenDistance = aqueenDistanceResult;
                }
            }
        }

        // Get the response and distance to the preferred location from the hotel 'Elizabeth'
        var responseElizabeth = hotelResponses["elizabeth"];
        if (responseElizabeth is http:Response) {
            var elizabethPayload = responseElizabeth.getJsonPayload();
            if (elizabethPayload is json) {
                elizabethJsonResponse = elizabethPayload;
                var elizabethDistanceResult = elizabethJsonResponse.DistanceToLocation;
                if (elizabethDistanceResult is int) {
                    elizabethDistance = elizabethDistanceResult;
                }
            }
        }

        // Select the hotel with the lowest distance
        if (miramarDistance < aqueenDistance) {
            if (miramarDistance < elizabethDistance) {
                jsonHotelResponse = miramarJsonResponse;
            }
        } else {
            if (aqueenDistance < elizabethDistance) {
                jsonHotelResponse = aqueenJsonResponse;
            }
            else {
                jsonHotelResponse = elizabethJsonResponse;
            }
        }


        // Car rental
        // Call Car rental service and consume different resources in parallel to check different companies
        // Fork to run parallel workers and join the results
        fork {
            // Worker to communicate with Company 'DriveSg'
            worker driveSg returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>vehiclePayload);
                // Send a POST request to 'DriveSg' and get the results
                http:Response|http:ClientError respWorkerDriveSg = carRentalEP->post("/driveSg", outReq);
                // Reply to the join block from this worker - Send the response from 'DriveSg'
                if (respWorkerDriveSg is http:Response) {
                    return respWorkerDriveSg;
                }
                return;
            }

            // Worker to communicate with Company 'DreamCar'
            worker dreamCar returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>vehiclePayload);
                // Send a POST request to 'DreamCar' and get the results
                http:Response|http:ClientError respWorkerDreamCar = carRentalEP->post("/dreamCar", outReq);
                if (respWorkerDreamCar is http:Response) {
                    // Reply to the join block from this worker - Send the response from 'DreamCar'
                    return respWorkerDreamCar;
                }
                return;
            }

            // Worker to communicate with Company 'Sixt'
            worker sixt returns http:Response? {
                http:Request outReq = new;
                // Out request payload
                outReq.setJsonPayload(<@untainted>vehiclePayload);
                // Send a POST request to 'Sixt' and get the results
                http:Response|http:ClientError respWorkerSixt = carRentalEP->post("/sixt", outReq);
                // Reply to the join block from this worker - Send the response from 'Sixt'
                if (respWorkerSixt is http:Response) {
                    return respWorkerSixt;
                }
                return;
            }
        }
        // Get the first responding worker
        http:Response? vehicleResponse = wait driveSg | dreamCar | sixt;
        if (vehicleResponse is http:Response) {
            var vehicleResponsePayload = vehicleResponse.getJsonPayload();
            if (vehicleResponsePayload is json) {
                jsonVehicleResponse = vehicleResponsePayload;
            }
        }

        // Construct the client response
        json clientResponse = {
            "Flight": jsonFlightResponse,
            "Hotel": jsonHotelResponse,
            "Vehicle": jsonVehicleResponse
        };

        // Response payload
        outResponse.setJsonPayload(<@untainted>clientResponse);
        // Send the response to the client
        error? res = caller->respond(outResponse);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }
}
