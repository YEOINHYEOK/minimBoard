package com.example.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PostSearchRequest {
	private String keyword;
	private String searchType;
	private int page;
	private int size;
	private String sortColumn;
	private String sortOrder;

	public int getOffset() {
		return (page - 1) * size;
	}
}
