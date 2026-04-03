package com.example.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

	@GetMapping("/")
	public String root() {
		return "redirect:/miniboard/login";
	}

	@GetMapping("/miniboard/login")
	public String login() {
		return "miniboard/login";
	}

	@GetMapping("/miniboard")
	public String list() {
		return "miniboard/list";
	}

	@GetMapping("/miniboard/{id}")
	public String post() {
		return "miniboard/post";
	}

	@GetMapping("/miniboard/write")
	public String write() {
		return "miniboard/write";
	}

	@GetMapping("/miniboard/user")
	public String user() {
		return "miniboard/user";
	}

	@GetMapping("/miniboard/stats")
	public String stats() {
		return "miniboard/stats";
	}
}
