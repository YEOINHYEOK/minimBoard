package com.example.board.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;

@Getter
@Schema(description = "카테고리 목록 DTO")
public class CategorieResponseDto {
	@Schema(description = "카테고리 ID")
	private Integer id;
	@Schema(description = "카테고리 이름")
	private String name;
}
