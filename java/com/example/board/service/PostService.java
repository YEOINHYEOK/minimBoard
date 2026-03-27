package com.example.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.board.dto.PostPagedResponseDto;
import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.dto.PostSearchRequest;
import com.example.board.mapper.PostMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostMapper postMapper;

    public void postInsert(PostRequestDto post) {
        postMapper.postInsert(post);
    }

    public PostPagedResponseDto getAllPost(int page, int size,
            String keyword,
            String sortColumn, String sortOrder) {
	int offset = (page - 1) * size;
	
	PostSearchRequest searchRequest = new PostSearchRequest();
	searchRequest.setPage(page);
    searchRequest.setSize(size);
    searchRequest.setKeyword(keyword);
    searchRequest.setSortColumn(sortColumn); 
    searchRequest.setSortOrder(sortOrder);   
	
	List<PostResponseDto> posts = postMapper.getAllPost(searchRequest);
	int totalCount              = postMapper.getTotalCount(searchRequest);
	int totalPages              = (int) Math.ceil((double) totalCount / size);
	
	return new PostPagedResponseDto(posts, totalCount, totalPages, page);
	}

    public PostResponseDto getFindPost(Integer id) {
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

    public void increaseViewCount(Integer id) {
        postMapper.increaseViewCount(id);
    }
    
}