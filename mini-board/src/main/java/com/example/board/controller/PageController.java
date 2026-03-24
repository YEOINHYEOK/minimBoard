package com.example.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {
	
	@GetMapping("/posts")
    public String list() {
        return "post/list";
    }

    @GetMapping("/posts/{id}")
    public String detail() {
        return "post/detail";
    }
    
    @GetMapping("/posts/write")
    public String write() {
        return "post/write";
    }
}
