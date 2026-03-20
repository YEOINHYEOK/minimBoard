package com.example.board.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.service.PostService;

import ch.qos.logback.core.model.Model;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/posts")
public class PostController {
	
	
	private final PostService postService;
	
	
	@PostMapping
    public void PostInsert(@RequestBody PostRequestDto post) {
        postService.postInsert(post);
        
    }
	
	@GetMapping
    public List<PostResponseDto> GetAllPost() {
        return postService.getAllPost();
    } 
	
	@GetMapping("/{id}")
	public List<PostResponseDto> GetFindPost(@PathVariable("id") Integer id){
		return postService.getFindPost(id);
		
	}
	
	@PutMapping("/{id}")
	public void UpdatePost(@PathVariable("id") Integer id, @RequestBody PostRequestDto post) {
		postService.updatePost(id, post);
	}
	
	@DeleteMapping("/{id}")
	public void DeletePost(@PathVariable("id") Integer id) {
		postService.deletePost(id);
	}
	
	@PostMapping("/{id}/comments")
    public void InsertComment(@PathVariable("id") Integer id, @RequestBody PostRequestDto post) {
        postService.insertComment(id, post);
    }
	
	@DeleteMapping("/comments/{id}")
	public void DeleteComment(@PathVariable("id") Integer id) {
		postService.deleteComment(id);
	}
	
}
