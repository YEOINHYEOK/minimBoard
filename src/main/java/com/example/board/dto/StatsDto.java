package com.example.board.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "게시판 통계 DTO")
public class StatsDto {
	@Schema(description = "게시글 수")
	private long totalPosts;
	@Schema(description = "회원 수")
	private long totalUsers;
	@Schema(description = "댓글 수")
	private long totalComments;
}
