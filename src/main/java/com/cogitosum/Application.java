package com.cogitosum;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        System.out.println("Arguments array is equal to " + java.util.Arrays.toString(args));
        System.setProperty("com.amazonaws.xray.emitters.daemonAddress","172.31.1.166");
        SpringApplication.run(Application.class);
    }
}
