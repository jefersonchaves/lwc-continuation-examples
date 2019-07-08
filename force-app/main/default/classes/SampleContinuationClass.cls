public with sharing class SampleContinuationClass {
  // Callout endpoint as a named credential URL
  private static final String NAMED_CREDENTIAL_LONG_RUNNING_SERVICE = 'callout:postman_echo';
  private static final String LONG_RUNNING_SERVICE_DELAY = '/delay/10';

  //#region Imperative
  
  // Action method
  @AuraEnabled(continuation=true)
  public static Object startRequestImperative() {
    // Create continuation. Argument is timeout in seconds.
    Continuation con = new Continuation(40);
    // Set callback method
    con.continuationMethod = 'processResponseImperative';
    // Create callout request
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    //req.setEndpoint(LONG_RUNNING_SERVICE_URL);
    req.setEndpoint(NAMED_CREDENTIAL_LONG_RUNNING_SERVICE + LONG_RUNNING_SERVICE_DELAY);
    // Add callout request to continuation
    con.addHttpRequest(req);
    // Return the continuation
    return con;
  }

  // Callback method
  @AuraEnabled
  public static Map<String, Object> processResponseImperative(
    List<String> labels,
    Object state
  ) {
    // Get the response by using the unique label
    HttpResponse response = Continuation.getResponse(labels[0]);
    // Set the result variable
    return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
  }

  //#endregion

  //#region Wire
  
  @AuraEnabled(continuation=true cacheable=true)
  public static Object startRequestWire() {
    // Create continuation. Argument is timeout in seconds.
    Continuation con = new Continuation(40);
    // Set callback method
    con.continuationMethod = 'processResponseWire';
    // Create callout request
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    //req.setEndpoint(LONG_RUNNING_SERVICE_URL);
    req.setEndpoint(NAMED_CREDENTIAL_LONG_RUNNING_SERVICE + LONG_RUNNING_SERVICE_DELAY);
    // Add callout request to continuation
    con.addHttpRequest(req);
    // Return the continuation
    return con;
  }

  // Callback method
  @AuraEnabled(cacheable=true)
  public static Map<String, Object> processResponseWire(
    List<String> labels,
    Object state
  ) {
    // Get the response by using the unique label
    HttpResponse response = Continuation.getResponse(labels[0]);
    // Set the result variable
    return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
  }

  //#endregion
}
