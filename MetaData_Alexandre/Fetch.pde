ArrayList<EventObject> events = new ArrayList<EventObject>();

Date starting_date = new Date();
long startingDateMillis;

void fetch() {
  JSONObject json;
  json = loadJSONObject("https://api.airtable.com/v0/"+baseID+"/"+tableName+"?api_key="+apiKey+"&sort%5B0%5D%5Bfield%5D=timestamp&sort%5B0%5D%5Bdirection%5D=asc");
  JSONArray values = json.getJSONArray("records");

  for (int i = 0; i < values.size(); i++) {
    JSONObject val = values.getJSONObject(i); 
    JSONObject fields = val.getJSONObject("fields");
    String createdTime = val.getString("createdTime");
    float lat = float(fields.getString("latitude"));
    float lon = float(fields.getString("longitude"));
    events.add(new EventObject(conv_datehourstring(createdTime), lat, lon));
  }

  for (int i = 0; i < events.size(); i++) {
    println(events.get(i).datetime);
  }
  println(events.size() + " records sucessfully fetched");
  starting_date = conv_datestring(date);
}


Date conv_datestring(String indate) {
  Date pdate = new Date();
  try {
    pdate = new SimpleDateFormat("dd/MM/yyyy").parse(indate);
  }
  catch (Exception e) {
  }

  return pdate;
}


Date conv_datehourstring(String indate) {
  Date pdate = new Date();
  try {
    pdate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(indate);
  }
  catch (Exception e) {
  }
  Long time = pdate.getTime();
  time +=(2*60*60*1000);

  return new Date(time);
}
