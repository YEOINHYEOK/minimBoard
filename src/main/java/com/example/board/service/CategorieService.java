package com.example.board.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.board.dto.CategorieResponseDto;
import com.example.board.mapper.CategorieMapper;
import com.example.board.mapper.PostMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategorieService {
	private final CategorieMapper categoriemapper;

	public List<CategorieResponseDto> getSelectCategorie() {
		return categoriemapper.getSelectCategorie();
	}

}
