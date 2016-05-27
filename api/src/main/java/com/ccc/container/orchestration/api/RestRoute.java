package com.ccc.container.orchestration.api;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.cdi.ContextName;
import org.apache.camel.util.InetAddressUtil;

/**
 * @author Mariano Gonzalez
 * @version 1.0.0
 */
@ContextName("RestCamelContext")
public class RestRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        // @formatter:off
        restConfiguration()
            .component("netty4-http")
            .host("0.0.0.0")
            .port(9090);

        rest("api")
            .get("/hello")
                .to("direct:hello")
            .get("/bye")
                .consumes("application/json")
                .to("direct:bye");

        from("direct:hello")
            .transform()
                .constant("Hello from: " + InetAddressUtil.getLocalHostName());
        // @formatter:on
    }
}


