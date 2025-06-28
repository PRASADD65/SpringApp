package com.example.techeazydevops;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @GetMapping("/")
    public String hello() {
        return "Hello, Welcome to Spring Boot Assignment 4! You are watching this from a private git repo. Thank you !";
    }
}
