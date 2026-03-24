package com.example.board.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.board.dto.ApiResponse;
import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.service.PostService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/posts")
public class PostController {
	
	
	private final PostService postService;
	
	
	@PostMapping
	public ResponseEntity<ApiResponse<Void>> postInsert(@RequestBody PostRequestDto post) {
        postService.postInsert(post);
        return ResponseEntity.ok(ApiResponse.success(null, "게시글이 작성되었습니다."));
	}
	
    @GetMapping
    public ResponseEntity<ApiResponse<List<PostResponseDto>>> getAllPost() {
        List<PostResponseDto> posts = postService.getAllPost();
        return ResponseEntity.ok(ApiResponse.success(posts));
    }
	
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PostResponseDto>> getFindPost(@PathVariable Integer id) {
        postService.increaseViewCount(id);          // 조회수 증가
        PostResponseDto post = postService.getFindPost(id);
        return ResponseEntity.ok(ApiResponse.success(post));
    }
	
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> updatePost(
            @PathVariable Integer id,
            @RequestBody PostRequestDto post) {
        postService.updatePost(id, post);
        return ResponseEntity.ok(ApiResponse.success(null, "게시글이 수정되었습니다."));
    }
	
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletePost(@PathVariable Integer id) {
        postService.deletePost(id);
        return ResponseEntity.ok(ApiResponse.success(null, "게시글이 삭제되었습니다."));
    }
	
    @PostMapping("/{id}/comments")
    public ResponseEntity<ApiResponse<Void>> insertComment(@PathVariable Integer id, @RequestBody PostRequestDto post) {
        postService.insertComment(id, post);
        return ResponseEntity.ok(ApiResponse.success(null, "댓글이 작성되었습니다."));
    }
	
    @DeleteMapping("/comments/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteComment(@PathVariable Integer id) {
        postService.deleteComment(id);
        return ResponseEntity.ok(ApiResponse.success(null, "댓글이 삭제되었습니다."));
    }
    
	
}
