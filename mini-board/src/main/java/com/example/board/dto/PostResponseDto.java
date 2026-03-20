package com.example.board.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;



@Getter
@Setter
public class PostResponseDto {
	private Integer id;
	private Integer categoryId;
	private Long title;
	private Integer view_count;
	private LocalDateTime createdAt; 
	private LocalDateTime updatedAt;
}
