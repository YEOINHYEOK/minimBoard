package com.example.board.security;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.dto.UsersDto;

import java.util.Optional;

@Mapper
public interface MemberMapper {
	Optional<UsersDto> findByUsername(String username);
}