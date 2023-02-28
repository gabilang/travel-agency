import ballerina/http;
import ballerina/log;
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;

// Service endpoint
listener http:Listener carEP = new (9093);

// Car rental service
service /car on carEP {

    // Resource 'driveSg', which checks about hotel 'DriveSg'
    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post driveSg(http:Caller caller, http:Request request) returns error? {
        http:Response response = new;
        json reqPayload = {};

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
        (json | error) vehicleType = reqPayload.VehicleType;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate is error || departureDate is error || vehicleType is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        }

        // Mock logic
        // Details of the vehicle
        json vehicleDetails = {
            "Company": "DriveSG",
            "VehicleType": <json>vehicleType,
            "FromDate": <json>arrivalDate,
            "ToDate": <json>departureDate,
            "PricePerDay": 5
        };
        // Response payload
        response.setJsonPayload(<@untainted>vehicleDetails);
        // Send the response to the caller
        error? res = caller->respond(response);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }

    // Resource 'dreamCar', which checks about hotel 'DreamCar'
    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post dreamCar(http:Caller caller, http:Request request) returns error? {
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
        (json | error) vehicleType = reqPayload.VehicleType;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate is error || departureDate is error || vehicleType is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        }

        // Mock logic
        // Details of the vehicle
        json vehicleDetails = {
            "Company": "DreamCar",
            "VehicleType": <json>vehicleType,
            "FromDate": <json>arrivalDate,
            "ToDate": <json>departureDate,
            "PricePerDay": 6
        };
        // Response payload
        response.setJsonPayload(<@untainted>vehicleDetails);
        // Send the response to the caller
        error? res = caller->respond(response);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }

    // Resource 'sixt', which checks about hotel 'Sixt'
    @http:ResourceConfig {
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function post sixt(http:Caller caller, http:Request request) returns error? {
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
        (json | error) vehicleType = reqPayload.VehicleType;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate is error || departureDate is error || vehicleType is error) {
            response.statusCode = 400;
            response.setJsonPayload({"Message": "Bad Request - Invalid Payload"});
            error? res = caller->respond(response);
            if (res is error) {
                log:printError("Error sending response.", res);
            }
            return;
        }

        // Mock logic
        // Details of the vehicle
        json vehicleDetails = {
            "Company": "Sixt",
            "VehicleType": <json>vehicleType,
            "FromDate": <json>arrivalDate,
            "ToDate": <json>departureDate,
            "PricePerDay": 7
        };
        // Response payload
        response.setJsonPayload(<@untainted>vehicleDetails);
        // Send the response to the caller
        error? res = caller->respond(response);
        if (res is error) {
            log:printError("Error sending response.", res);
        }
        return;
    }
}
