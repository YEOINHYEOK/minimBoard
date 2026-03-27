package com.example.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PostRequestDto {
	private Integer categoryId;
    private Integer userId;
    private String title;
    private String content;
}
