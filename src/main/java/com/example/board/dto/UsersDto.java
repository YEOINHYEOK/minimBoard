package com.example.board.dto;

import java.time.LocalDateTime;

import com.example.board.security.Role;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "회원 DTO")
public class UsersDto {

	@Schema(description = "회원 ID")
	private Long id;
	@Schema(description = "회원 아이디")
	private String username;
	@Schema(description = "회원 비밀번호")
	private String password;
	@Schema(description = "회원 이메일")
	private String email;
	@Schema(description = "회원 권한")
	private Role role;
	@Schema(description = "생성일")
	private LocalDateTime createdAt;
	@Schema(description = "수정일")
	private LocalDateTime updatedAt;

}
