package com.example.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;

@Mapper
public interface PostMapper {

	void postInsert(PostRequestDto post);

	List<PostResponseDto> getAllPost();

	List<PostResponseDto> getFindPost(Integer id);

	void updatePost(Integer id, PostRequestDto post);

	void deletePost(Integer id);

	void insertComment(Integer id, PostRequestDto post);

	void deleteComment(Integer id);

	List<PostRequestDto> getAllCount(int limit, int offset);

	int getTotalCount();
}
