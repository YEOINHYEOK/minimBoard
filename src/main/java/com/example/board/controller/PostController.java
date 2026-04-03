package com.example.board.controller;

import org.springframework.security.core.Authentication;
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
import com.example.board.dto.PostPagedResponseDto;
import com.example.board.dto.PostRequestDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.dto.StatsDto;
import com.example.board.dto.CommentDto;
import com.example.board.service.PostService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/posts")
public class PostController {

	private final PostService postService;
	
	@Operation(summary = "게시글 작성", description = "게시글의 내용을 작성합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "게시글 작성 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "잘못된 요청", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@PostMapping
	public ResponseEntity<ApiResponse<Void>> postInsert(@RequestBody PostRequestDto post,
			Authentication authentication) {
		postService.postInsert(post, authentication.getName());
		return ResponseEntity.ok(ApiResponse.success(null, "게시글이 작성되었습니다."));
	}

	@Operation(summary = "게시글 목록 조회", description = "게시글 목록을 불러옵니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(schema = @Schema(implementation = PostResponseDto.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@GetMapping
	public ResponseEntity<ApiResponse<PostPagedResponseDto>> getAllPost(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "sortColumn", defaultValue = "id") String sortColumn,
			@RequestParam(value = "sortOrder", defaultValue = "desc") String sortOrder) {

		PostPagedResponseDto response = postService.getAllPost(page, size, keyword, sortColumn, sortOrder);
		return ResponseEntity.ok(ApiResponse.success(response));
	}

	@Operation(summary = "게시글 조회", description = "입력한 ID에 해당하는 게시글을 불러옵니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(schema = @Schema(implementation = PostResponseDto.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@GetMapping("/{id}")
	public ResponseEntity<ApiResponse<PostResponseDto>> getFindPost(@PathVariable Integer id) {
		postService.increaseViewCount(id);
		PostResponseDto post = postService.getFindPost(id);
		return ResponseEntity.ok(ApiResponse.success(post));
	}

	@Operation(summary = "게시글 내용 수정", description = "입력한 ID의 게시글의 내용을 수정합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "게시글 수정 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "잘못된 요청", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@PutMapping("/{id}")
	public ResponseEntity<ApiResponse<Void>> updatePost(@PathVariable Integer id, @RequestBody PostRequestDto post,
			Authentication authentication) {
		try {
			postService.updatePost(id, post, authentication.getName());
			return ResponseEntity.ok(ApiResponse.success(null, "게시글이 수정되었습니다."));
		} catch (RuntimeException e) {
			return ResponseEntity.status(403).body(ApiResponse.fail(e.getMessage()));
		}
	}

	@Operation(summary = "게시글 삭제", description = "입력한 ID와 같은 사용자가 해당하는 게시글을 삭제합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "삭제 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "삭제할 게시글을 찾을 수 없음", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@DeleteMapping("/{id}")
	public ResponseEntity<ApiResponse<Void>> deletePost(@PathVariable Integer id, Authentication authentication) {
		try {
			postService.deletePost(id, authentication.getName());
			return ResponseEntity.ok(ApiResponse.success(null, "게시글이 삭제되었습니다."));
		} catch (RuntimeException e) {
			return ResponseEntity.status(403).body(ApiResponse.fail(e.getMessage()));
		}
	}

	@Operation(summary = "댓글 작성", description = "입력한 ID의 게시글의 댓글을 작성합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "댓글 작성 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "잘못된 요청", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@PostMapping("/{id}/comments")
	public ResponseEntity<ApiResponse<Void>> insertComment(@PathVariable Long id, @RequestBody PostRequestDto post,
			Authentication authentication) {
		postService.insertComment(id, post, authentication.getName());
		return ResponseEntity.ok(ApiResponse.success(null, "댓글이 작성되었습니다."));
	}

	@Operation(summary = "댓글 삭제", description = "입력한 ID와 같은 사용자가 해당하는 댓글을 삭제합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "삭제 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "삭제할 댓글을 찾을 수 없음", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@DeleteMapping("/comments/{id}")
	public ResponseEntity<ApiResponse<Void>> deleteComment(@PathVariable Integer id, Authentication authentication) {
		try {
			postService.deleteComment(id, authentication.getName());
			return ResponseEntity.ok(ApiResponse.success(null, "댓글이 삭제되었습니다."));
		} catch (RuntimeException e) {
			return ResponseEntity.status(403).body(ApiResponse.fail(e.getMessage()));
		}
	}
}
