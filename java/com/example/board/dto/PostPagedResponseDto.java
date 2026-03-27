package com.example.board.dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class PostPagedResponseDto {
    private List<PostResponseDto> list;
    private int totalCount;             
    private int totalPages;            
    private int currentPage;           
}