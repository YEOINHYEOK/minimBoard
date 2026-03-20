package com.example.board.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data 
public class UserDto {
    private Integer id;
    private String username;
    private String password;
    private String email;
    private LocalDateTime createdAt; 
    private LocalDateTime updatedAt;
}