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
            .get("/crash").description("Endpoint for simulating a service unavailable (HTTP status 503)")
                .to("direct:crash")
            .get("/health-check")
                .to("direct:health-check");

        from("direct:hello")
            .transform()
                .constant("Hey hey hey from: " + InetAddressUtil.getLocalHostName());

        from("direct:by")
            .process(exchange -> System.exit(1));

        from("direct:health-check")
            .transform()
                .constant("Everything looks good");
        // @formatter:on
    }
}


