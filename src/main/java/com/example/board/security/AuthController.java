package com.example.board.security;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import com.example.board.dto.ApiResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

	private final AuthService authService;


	@Operation(summary = "로그인", description = "로그인을 정보를 전달하여 접속합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "로그인 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패", content = @Content)})
	@PostMapping("/login")
	public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
		return ResponseEntity.ok(authService.login(request));
	}

	@Operation(summary = "토큰 재발급", description = "Refresh Token을 이용해서 새로운 Access Token을 재발급 합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "토큰 재발급", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "유효하지 않은 리프레시 토큰", content = @Content)})
	@PostMapping("/refresh")
	public ResponseEntity<TokenResponse> refresh(@Valid @RequestBody RefreshRequest request) {
		return ResponseEntity.ok(authService.reissue(request.getRefreshToken()));
	}

	@Operation(summary = "로그아웃", description = "DB에 토큰을 제거하며 로그아웃을 시도합니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "204", description = "로그아웃 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class)))})
	@PostMapping("/logout")
	public ResponseEntity<Void> logout(@RequestHeader("Authorization") String bearerToken) {
		String accessToken = bearerToken.substring(7); // "Bearer " 제거
		authService.logout(accessToken);
		return ResponseEntity.noContent().build(); // 204
	}

	@Operation(summary = "토큰정보", description = "현재 로그인한 사용자의 정보를 가져옵니다.")
	@io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "정보 성공", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
			@io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 에러", content = @Content) })
	@GetMapping("/me")
	public ResponseEntity<UserInfoResponse> me(@AuthenticationPrincipal UserDetails userDetails) {
		return ResponseEntity.ok(authService.getUserInfo(userDetails.getUsername()));
	}
}