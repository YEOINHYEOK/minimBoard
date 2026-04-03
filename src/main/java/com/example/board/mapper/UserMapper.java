package com.example.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.dto.PostSearchRequest;
import com.example.board.dto.StatsDto;
import com.example.board.dto.UsersDto;

import io.lettuce.core.dynamic.annotation.Param;

@Mapper
public interface UserMapper {

	void updateUser(@Param("id") Long id, @Param("users") UsersDto users);

	List<UsersDto> getAllUsers(PostSearchRequest searchRequest);

	int getTotalCount(PostSearchRequest searchRequest);

	StatsDto getStats();

}