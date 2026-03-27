package com.example.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {
	
	@GetMapping("/miniboard")
    public String list() {
        return "miniboard/list";
    }

    @GetMapping("/miniboard/{id}")
    public String detail() {
        return "miniboard/post";
    }
    
    @GetMapping("/miniboard/write")
    public String write() {
        return "miniboard/write";
    }
}
