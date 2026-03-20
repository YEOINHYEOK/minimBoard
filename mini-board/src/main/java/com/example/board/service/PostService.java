package com.example.board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.mapper.PostMapper;

import lombok.RequiredArgsConstructor;



@Service
@RequiredArgsConstructor
public class PostService {

    
    private final PostMapper postMapper;
    
    
    
    public void postInsert(PostRequestDto post) {
        postMapper.postInsert(post);
    }



	public List<PostResponseDto> getAllPost() {

		return postMapper.getAllPost();
	}



	public List<PostResponseDto> getFindPost(Integer id) {
		return postMapper.getFindPost(id);
	}

	public void updatePost(Integer id, PostRequestDto post) {
		 postMapper.updatePost(id, post);
	}



	public void deletePost(Integer id) {
		postMapper.deletePost(id);
		
	}

	public void insertComment(Integer id, PostRequestDto post) {
		postMapper.insertComment(id, post);
		
	}

	public void deleteComment(Integer id) {
		postMapper.deleteComment(id);
	}
	
	public void getPageList(int page) {
        int size = 10;
        int offset = (page - 1) * size;
        
        List<PostRequestDto> list = postMapper.getAllCount(size, offset);
        int totalCount = postMapper.getTotalCount();
        
    }
}
