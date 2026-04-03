package com.example.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.board.dto.CommentDto;
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

	public void postInsert(PostRequestDto post, String username) {
		Long userId = postMapper.userFind(username);
		post.setUserId(userId);
		postMapper.postInsert(post);
	}

	public PostPagedResponseDto getAllPost(int page, int size, String keyword, String sortColumn, String sortOrder) {
		int offset = (page - 1) * size;

		PostSearchRequest searchRequest = new PostSearchRequest();
		searchRequest.setPage(page);
		searchRequest.setSize(size);
		searchRequest.setKeyword(keyword);
		searchRequest.setSortColumn(sortColumn);
		searchRequest.setSortOrder(sortOrder);

		List<PostResponseDto> posts = postMapper.getAllPost(searchRequest);
		int totalCount = postMapper.getTotalCount(searchRequest);
		int totalPages = (int) Math.ceil((double) totalCount / size);

		return new PostPagedResponseDto(posts, totalCount, totalPages, page);
	}

	public PostResponseDto getFindPost(Integer id) {
		return postMapper.getFindPost(id);
	}

	public void updatePost(Integer id, PostRequestDto post, String username) {
		PostResponseDto postuser = postMapper.getFindPost(id);
		if (postuser.getUsername().equals(username)) {
			postMapper.updatePost(id, post);
		} else {
			throw new RuntimeException("본인만 수정할 수 있습니다.");
		}
	}

	public void deletePost(Integer id, String username) {
		PostResponseDto postuser = postMapper.getFindPost(id);
		if (postuser.getUsername().equals(username)) {
			postMapper.deletePost(id);
		} else {
			throw new RuntimeException("본인만 삭제할 수 있습니다.");
		}
	}

	public void insertComment(Long id, PostRequestDto post, String username) {
		Long userId = postMapper.userFind(username);
		post.setUserId(userId);
		postMapper.insertComment(id, post);
	}

	public void deleteComment(Integer id, String username) {
		CommentDto comment = postMapper.getFindComment(id);
		if (comment.getUsername().equals(username)) {
			postMapper.deleteComment(id);
		} else {
			throw new RuntimeException("본인만 삭제할 수 있습니다.");
		}
	}

	public void increaseViewCount(Integer id) {
		postMapper.increaseViewCount(id);
	}

	public Long userFind(String username) {
		return postMapper.userFind(username);
	}

	public CommentDto getFindComment(Integer id) {
		return postMapper.getFindComment(id);
	}

	public void deletePost(Integer id) {
		postMapper.deletePost(id);
	}

	public void deleteComment(Integer id) {
		postMapper.deleteComment(id);
	}

}