import ballerina/http;
import ballerina/log;
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;

// Service endpoint
listener http:Listener airlineEP = new (9091);

// Airline reservation service
// @http:ServiceConfig {basePath: "/airline"}
service /airline on airlineEP {

    // Resource 'flightConcord', which checks about airline 'Qatar Airways'
    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post qatarAirways(http:Caller caller, http:Request request) returns error? {
        http:Response response = new;
        json reqPayload = {};

        // Try parsing the JSON payload from the request
        (json | error) payload = request.getJsonPayload();
        if (payload is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Invalid payload - Not a valid JSON payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
        } else {
            reqPayload = payload;
        }

        (json | error) arrivalDate = reqPayload.ArrivalDate;
        (json | error) departureDate = reqPayload.DepartureDate;
        (json | error) fromPlace = reqPayload.From;
        (json | error) toPlace = reqPayload.To;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate is error || departureDate is error || fromPlace is error || toPlace is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        }

        // Mock logic
        // Details of the airline
        json flightDetails = {
            "Airline": "Qatar Airways",
            "ArrivalDate": <json>arrivalDate,
            "ReturnDate": <json>departureDate,
            "From": <json>fromPlace,
            "To": <json>toPlace,
            "Price": 278
        };

        // Response payload
        response.setJsonPayload(<@untainted>flightDetails);
        // Send the response to the caller
        error? res = check caller->respond(response);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }

    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post asiana(http:Caller caller, http:Request request) returns error? {
        http:Response response = new;
        json reqPayload = {};

        // Try parsing the JSON payload from the request
        var payload = request.getJsonPayload();
        if (payload is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Invalid payload - Not a valid JSON payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        } else {
            reqPayload = payload;
        }

        (json | error) arrivalDate = reqPayload.ArrivalDate;
        (json | error) departureDate = reqPayload.DepartureDate;
        (json | error) fromPlace = reqPayload.From;
        (json | error) toPlace = reqPayload.To;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate is error || departureDate is error || fromPlace is error || toPlace is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        }

        // Mock logic
        // Details of the airline
        json flightDetails = {
            "Airline": "Asiana",
            "ArrivalDate": <json>arrivalDate,
            "ReturnDate": <json>departureDate,
            "From": <json>fromPlace,
            "To": <json>toPlace,
            "Price": 275
        };
        // Response payload
        response.setJsonPayload(<@untainted>flightDetails);
        // Send the response to the caller
        error? res = caller->respond(response);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }

    // Resource 'flightEmirates', which checks about airline 'Emirates'
    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post emirates(http:Caller caller, http:Request request) returns error? {
        http:Response response = new;
        json reqPayload = {};

        // Try parsing the JSON payload from the request
        var payload = request.getJsonPayload();
        if (payload is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Invalid payload - Not a valid JSON payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        } else {
            reqPayload = payload;
        }

        (json | error) arrivalDate = reqPayload.ArrivalDate;
        (json | error) departureDate = reqPayload.DepartureDate;
        (json | error) fromPlace = reqPayload.From;
        (json | error) toPlace = reqPayload.To;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate is error || departureDate is error || fromPlace is error || toPlace is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
        }

        // Mock logic
        // Details of the airline
        json flightDetails = {
            "Airline": "Emirates",
            "ArrivalDate": check arrivalDate,
            "ReturnDate": check departureDate,
            "From": check fromPlace,
            "To": check toPlace,
            "Price": 273
        };
        // Response payload
        response.setJsonPayload(<@untainted>flightDetails);
        // Send the response to the caller
        error? res = caller->respond(response);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }
}
