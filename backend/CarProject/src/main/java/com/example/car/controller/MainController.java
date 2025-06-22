package com.example.car.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping({"/", "/index"})  
    public String root() {
        return "index";  // templates/index.html
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @GetMapping("/regist")
    public String registForm() {
        return "regist";
    }
    @GetMapping("/register")
    public String registerPage() {
        return "regist";  // templates/regist.html
    }

}
