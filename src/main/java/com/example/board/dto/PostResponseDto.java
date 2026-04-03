package com.example.board.dto;

import java.time.LocalDateTime;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "게시글 정보 DTO")
public class PostResponseDto {
	@Schema(description = "게시글 ID")
	private Integer id;
	@Schema(description = "카테고리 ID")
	private Integer categoryId;
	@Schema(description = "카테고리 이름")
	private String categoryName;
	@Schema(description = "게시글 제목")
	private String title;
	@Schema(description = "게시글 내용")
	private String content;
	@Schema(description = "회원 아이디")
	private String username;
	@Schema(description = "조회수")
	private int viewCount;
	@Schema(description = "생성일")
	private LocalDateTime createdAt;
	@Schema(description = "수정일")
	private LocalDateTime updatedAt;
	@Schema(description = "댓글 정보 DTO")
	private List<CommentDto> comments;
}
