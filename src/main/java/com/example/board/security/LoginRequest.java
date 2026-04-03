package com.example.board.security;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Schema(description = "로그인 요청 DTO")
public class LoginRequest {
	@NotBlank
	@Schema(description = "회원 ID")
	private String username;
	@NotBlank
	@Schema(description = "회원 비밀번호")
	private String password;
}