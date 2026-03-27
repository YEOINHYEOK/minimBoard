package com.example.board.dto;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PostResponseDto {
    private Integer       id;
    private Integer       categoryId;
    private String        categoryName; 
    private String        title;      
    private String        content;       
    private String        username;    
    private int           viewCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<CommentDto> comments;
}
