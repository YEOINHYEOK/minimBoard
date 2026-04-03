package com.example.board.security;

import lombok.Getter;

@Getter
public class UserInfoResponse {
	private final String username;
	private final String email;
	private final String role;

	public UserInfoResponse(String username, String email, String role) {
		this.username = username;
		this.email = email;
		this.role = role;
	}
}