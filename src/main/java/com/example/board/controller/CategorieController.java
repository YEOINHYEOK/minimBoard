package com.example.board.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import com.example.board.dto.ApiResponse;
import com.example.board.dto.CategorieResponseDto;
import com.example.board.service.CategorieService;
import com.example.board.service.PostService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/categories")
public class CategorieController {

	private final CategorieService categorieservice;

	@Operation(summary = "카테고리 전체 조회", description = "게시판의 모든 카테고리 목록을 불러옵니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(schema = @Schema(implementation = CategorieResponseDto.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@GetMapping
	public ResponseEntity<ApiResponse<List<CategorieResponseDto>>> getSelectCategorie() {
		List<CategorieResponseDto> categories = categorieservice.getSelectCategorie();
		return ResponseEntity.ok(ApiResponse.success(categories));
	}
}
