package com.example.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.dto.CategorieResponseDto;

@Mapper
public interface CategorieMapper {

	public List<CategorieResponseDto> getSelectCategorie();

}
