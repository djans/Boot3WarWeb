package com.cogitosum.data;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class CourseService {
    @Autowired
    private RestTemplate restTemplate;

    private static final String LAMBDA_API_GATEWAY_URL = "https://8jtg7qcsz8.execute-api.us-east-2.amazonaws.com/dev/courses";

    public void sendDataToLambda(Course course) {
        try {
            // Convert the Course object to JSON
            ObjectMapper objectMapper = new ObjectMapper();
            String jsonRequest = objectMapper.writeValueAsString(course);
            System.out.println("jsonRequest: " + jsonRequest);
            // Set up HTTP headers
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");

            // Create the request entity
            HttpEntity<String> requestEntity = new HttpEntity<>(jsonRequest, headers);
            System.out.println("requestEntity: " + requestEntity);
            // Send POST request to Lambda (via API Gateway)
            //String response =restTemplate.postForObject(LAMBDA_API_GATEWAY_URL, requestEntity, String.class);
            ResponseEntity<String> response = restTemplate.exchange(
                    LAMBDA_API_GATEWAY_URL,
                    HttpMethod.POST,
                    requestEntity,
                    String.class
            );

            // Return the response from the Lambda function
            System.out.println("response: " + response);
            //return response;

            //return response.getBody();
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
    }
}
