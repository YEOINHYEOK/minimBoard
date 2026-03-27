package com.example.board.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentDto {
	private Integer id;
	private String content;
	private LocalDateTime createdAt;
	private String commentname;   
}
