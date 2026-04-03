package com.example.board.security;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Schema(description = "토큰 재발급 요청 DTO")
public class RefreshRequest {
	@NotBlank
	@Schema(description = "기존에 받은 토큰")
	private String refreshToken;
}