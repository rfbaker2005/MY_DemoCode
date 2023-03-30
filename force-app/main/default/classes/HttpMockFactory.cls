/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This class provides a factory for REST callout mocking in unit testing environments.
 */
public class HttpMockFactory implements HttpCalloutMock {

    protected Integer code;
    protected String  status;
    protected String  body;

    protected Map<String, String> resHeaders;

    public HTTPMockFactory (Integer code, String status, String body, Map<String, String> resHeaders) {

        this.code       = code;
        this.status     = status;
        this.body       = body;
        this.resHeaders = resHeaders;
    }

    public HTTPResponse respond (HTTPRequest req) {

        HttpResponse res = new HttpResponse();

        for (String key : this.resHeaders.keySet()) {

            res.setHeader(key, this.resHeaders.get(key));
        }

        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);

        System.debug('HttpMockFactory.respond.01.1 body: ['+this.body+']');

        return res;
    }
}