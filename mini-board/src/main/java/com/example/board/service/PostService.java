package com.example.board.service;

import java.util.List;
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