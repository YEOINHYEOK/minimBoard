package com.example.board.dto;

import java.time.LocalDateTime;
import lombok.Getter;

@Getter
public class ApiResponse<T> {

    private final boolean       success;
    private final T             data;
    private final String        message;
    private final LocalDateTime timestamp;

    private ApiResponse(boolean success, T data, String message) {
        this.success   = success;
        this.data      = data;
        this.message   = message;
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