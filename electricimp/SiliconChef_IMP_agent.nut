function postStressed(data){
    //local url = "http://0.0.0.0:8080";      
    //local req = http.get(url, {"Content-Type":"application/json"}, json_body);     //add headers
    //local result = req.sendsync();         //send request
    //server.log(result.statuscode);      //sends status to uart. this can be removed if not desired
    local request = http.get("http://107.170.199.82");
    local response = request.sendsync();
    server.log(response);
    server.log("DOne")
}

device.on("stressed", postStressed);