package com.example.board.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;

@Slf4j
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

	private final JwtTokenProvider jwtTokenProvider;

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		String path = request.getRequestURI();

		// 1. 로그인 관련 경로는 토큰 검사 없이 통과 (SecurityConfig와 일치시킴)
		if (path.equals("/miniboard/login") || path.startsWith("/api/auth/login")) {
			filterChain.doFilter(request, response);
			return;
		}

		// 2. 토큰 추출 (헤더 우선, 없으면 쿠키)
		String token = resolveToken(request);

		// 3. 토큰 유효성 검증 및 인증 객체 등록
		if (StringUtils.hasText(token) && jwtTokenProvider.validateToken(token)) {
			Authentication authentication = jwtTokenProvider.getAuthentication(token);
			SecurityContextHolder.getContext().setAuthentication(authentication);
			log.debug("인증 성공: {}, URI: {}", authentication.getName(), path);
		}

		filterChain.doFilter(request, response);
	}

	private String resolveToken(HttpServletRequest request) {
		// 방법 A: Authorization 헤더 확인 (Bearer )
		String bearerToken = request.getHeader("Authorization");
		if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
			return bearerToken.substring(7);
		}

		// 방법 B: 쿠키 확인 (브라우저 주소창 이동 시 사용)
		if (request.getCookies() != null) {
			return Arrays.stream(request.getCookies()).filter(cookie -> "accessToken".equals(cookie.getName()))
					.map(Cookie::getValue).findFirst().orElse(null);
		}

		return null;
	}
}