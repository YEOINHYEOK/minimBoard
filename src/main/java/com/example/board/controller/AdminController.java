package com.example.board.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.example.board.dto.ApiResponse;
import com.example.board.dto.CategorieResponseDto;
import com.example.board.dto.PostPagedResponseDto;
import com.example.board.dto.StatsDto;
import com.example.board.dto.UserPagedResponseDto;
import com.example.board.dto.UsersDto;
import com.example.board.service.PostService;
import com.example.board.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin")
public class AdminController {
	private final PostService postService;
	private final UserService userService;

	@Operation(summary = "회원 전체 조회", description = "게시판의 회원 목록을 불러옵니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(schema = @Schema(implementation = UsersDto.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@GetMapping("/users")
	public ResponseEntity<ApiResponse<UserPagedResponseDto>> selectUsers(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "sortColumn", defaultValue = "id") String sortColumn,
			@RequestParam(value = "sortOrder", defaultValue = "desc") String sortOrder) {

		UserPagedResponseDto response = userService.getAllUsers(page, size, keyword, sortColumn, sortOrder);

		return ResponseEntity.ok(ApiResponse.success(response));
	}

	@Operation(summary = "회원 권한 변경", description = "회원 정보의 권한을 사용자(USER) 또는 관리자(ADMIN)로 변경합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "권한 변경 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "잘못된 요청", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@PatchMapping("/users/{id}/role")
	public ResponseEntity<ApiResponse<Void>> patchUser(@PathVariable Long id, @RequestBody UsersDto users) {
		userService.patchUser(id, users);
		return ResponseEntity.ok(ApiResponse.success(null, "유저 수정되었습니다."));
	}

	@Operation(summary = "게시글 삭제", description = "입력한 ID에 해당하는 게시물을 삭제합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "삭제 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "삭제할 게시글을 찾을 수 없음", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@DeleteMapping("/posts/{id}")
	public ResponseEntity<ApiResponse<Void>> deletePost(@PathVariable Integer id) {
		postService.deletePost(id);
		return ResponseEntity.ok(ApiResponse.success(null, "게시글이 삭제되었습니다."));
	}

	@Operation(summary = "댓글 삭제", description = "입력한 ID에 해당하는 댓글을 삭제합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "삭제 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "삭제할 댓글을 찾을 수 없음", content = @Content),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@DeleteMapping("/comments/{id}")
	public ResponseEntity<ApiResponse<Void>> deleteComment(@PathVariable Integer id) {
		postService.deleteComment(id);
		return ResponseEntity.ok(ApiResponse.success(null, "댓글이 삭제되었습니다."));
	}

	@Operation(summary = "상태 정보 조회", description = "게시판의 회원, 게시물, 댓글의 수를 불러옵니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(schema = @Schema(implementation = StatsDto.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@GetMapping("/stats")
	public ResponseEntity<ApiResponse<StatsDto>> getStats() {
		StatsDto stats = userService.getStats();
		return ResponseEntity.ok(ApiResponse.success(stats));
	}
}
