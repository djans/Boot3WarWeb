package com.cogitosum;

import com.amazonaws.services.xray.AWSXRay;
import com.amazonaws.services.xray.model.Segment;
import jakarta.servlet.Filter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import com.amazonaws.xray.jakarta.servlet.AWSXRayServletFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Bean
    public FilterRegistrationBean<AWSXRayServletFilter> xrayFilter() {
        FilterRegistrationBean<AWSXRayServletFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new AWSXRayServletFilter("MySpringBootApp"));
        registration.addUrlPatterns("/*"); // Apply to all endpoints
        return registration;
    }
}

