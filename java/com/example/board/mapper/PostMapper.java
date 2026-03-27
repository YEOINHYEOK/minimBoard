package com.example.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.dto.PostSearchRequest;

@Mapper
public interface PostMapper {

	void postInsert(PostRequestDto post);

	List<PostResponseDto> getAllPost(PostSearchRequest searchRequest);

	PostResponseDto getFindPost(@Param("id") Integer id);

	void updatePost(@Param("id") Integer id, @Param("post") PostRequestDto post);

	void deletePost(@Param("id") Integer id);

	void insertComment(@Param("id") Integer id, @Param("post") PostRequestDto post);

	void deleteComment(@Param("id") Integer id);

	List<PostResponseDto> getAllCount(@Param("limit") int limit, @Param("offset") int offset);

	int getTotalCount(PostSearchRequest searchRequest);

	void increaseViewCount(@Param("id") Integer id);
}
