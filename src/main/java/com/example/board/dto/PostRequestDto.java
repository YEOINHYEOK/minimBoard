package com.example.board.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "게시글 작성 요청 DTO")
public class PostRequestDto {
	@Schema(description = "카테고리 ID")
	private Integer categoryId;
	@Schema(description = "회원 ID")
	private Long userId;
	@Schema(description = "게시글 제목")
	private String title;
	@Schema(description = "게시글 내용")
	private String content;
}
