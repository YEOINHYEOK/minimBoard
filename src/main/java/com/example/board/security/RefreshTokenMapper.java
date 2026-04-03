package com.example.board.security;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

@Mapper
public interface RefreshTokenMapper {

	void insert(@Param("userId") Long userId, @Param("token") String token);

	Optional<String> findByUserId(@Param("userId") Long userId);

	void deleteByUserId(@Param("userId") Long userId);
}