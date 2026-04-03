package com.example.board.dto;

import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "댓글 DTO")
public class CommentDto {
	@Schema(description = "댓글 ID")
	private Integer id;
	@Schema(description = "댓글 내용")
	private String content;
	@Schema(description = "생성일")
	private LocalDateTime createdAt;
	@Schema(description = "수정일")
	private String commentname;
	@Schema(description = "회원 아이디")
	private String username;
}
