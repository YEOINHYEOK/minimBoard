package com.example.board.dto;

import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;

@Getter
@Schema(description = "공통 응답 API DTO")
public class ApiResponse<T> {

	@Schema(description = "성공/실패 여부")
	private final boolean success;
	@Schema(description = "응답 데이터")
	private final T data;
	@Schema(description = "응답 메세지")
	private final String message;
	@Schema(description = "생성시간")
	private final LocalDateTime timestamp;

	private ApiResponse(boolean success, T data, String message) {
		this.success = success;
		this.data = data;
		this.message = message;
		this.timestamp = LocalDateTime.now();
	}

	public static <T> ApiResponse<T> success(T data, String message) {
		return new ApiResponse<>(true, data, message);
	}

	public static <T> ApiResponse<T> success(T data) {
		return new ApiResponse<>(true, data, "success");
	}

	public static <T> ApiResponse<T> fail(String message) {
		return new ApiResponse<>(false, null, message);
	}
}