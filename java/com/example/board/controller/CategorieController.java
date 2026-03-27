package com.example.board.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.board.dto.ApiResponse;
import com.example.board.dto.CategorieResponseDto;
import com.example.board.service.CategorieService;
import com.example.board.service.PostService;

import lombok.RequiredArgsConstructor;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/categories")
public class CategorieController {
	
	private final CategorieService categorieservice;
	
	@GetMapping
	public ResponseEntity<ApiResponse<List<CategorieResponseDto>>> getSelectCategorie() {
		List<CategorieResponseDto> categories = categorieservice.getSelectCategorie();
		return ResponseEntity.ok(ApiResponse.success(categories));
	}
}
