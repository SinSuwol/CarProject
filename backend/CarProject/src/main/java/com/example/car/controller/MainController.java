package com.example.car.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {
		
	//얘는 그냥 test용으로 만든 컨트롤러와 메서드
	@GetMapping("/")
	public String root() {
		return "index";
	}
}
