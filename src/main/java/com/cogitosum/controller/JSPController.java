package com.cogitosum.controller;

import com.cogitosum.data.Course;
import com.cogitosum.data.CourseService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

@Controller
public class JSPController {

    private static final String LAMBDA_URL = "https://8jtg7qcsz8.execute-api.us-east-2.amazonaws.com/dev/courses";
    String[] ip;

    @Autowired
    private CourseService lambdaService;

    // Handle GET requests and display the list of books ....
    @GetMapping(path = "/test")
    public void test(Model model) throws JsonProcessingException {
        int startPortRange=2000;
        ip = new String[4];
        ip[0] = "127.0.0.1";
        ip[1] = "18.189.195.148";
        ip[2] = "172.31.1.166";
        ip[3] = "ip-172-31-1-166.us-east-2.compute.internal";
        ip[4] = "172.17.0.3";
        for (int i = 0; i < 4; i++) {
            System.out.println("Scanning IP Address: " + ip[i]);
            try {
                Socket ServerSok = new Socket(ip[i],2000);
                System.out.println("Port in use on : " + ip[i] );
                ServerSok.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            System.out.println("Port not in use: " + ip[i] );
        }
    }

    // Handle GET requests and display the list of books ....
    @GetMapping("/")
    public String viewBooks(Model model) throws JsonProcessingException {
        StringBuffer response = new StringBuffer();
        extracted(response);
        String parsedJson = parseJsonResponse(response.toString());
        model.addAttribute("books", parsedJson);
        return "examples/server_side";
    }

    @PostMapping(value = "/addBook", consumes = "application/x-www-form-urlencoded;charset=UTF-8")
    public String sendFormToLambda4(@ModelAttribute Course o) throws Exception {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");
        JSONObject jSonCourse = new JSONObject();
        jSonCourse.put("id", o.getId());
        jSonCourse.put("name", o.getName());
        jSonCourse.put("price", o.getPrice());
        HttpEntity<String> request = new HttpEntity<String>(jSonCourse.toString(), headers);
        restTemplate.postForObject(LAMBDA_URL, request, String.class);
        //StringBuffer response = new StringBuffer();
        //extracted(response);
        //String parsedJson = parseJsonResponse(response.toString());
        return "examples/done";
    }

    // Helper method to parse JSON response from the API
    private String parseJsonResponse(String response) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        List<Course> items = objectMapper.readValue(response, objectMapper.getTypeFactory().constructCollectionType(List.class, Course.class));

        List<List<String>> dataSet = new ArrayList<>();
        for (Course item : items) {
            List<String> row = new ArrayList<>();
            row.add("\"" + item.getId()+ "\"");
            row.add("\""+ item.getPrice() +"\"");
            row.add("\""+ item.getName()+"\"");
            dataSet.add(row);
        }
        return dataSet.toString();
    }

    private void extracted(StringBuffer response) {
        try {
            URL url = new URL(LAMBDA_URL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
