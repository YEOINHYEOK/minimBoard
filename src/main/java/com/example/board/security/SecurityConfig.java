package com.example.board.security;

import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

	private final JwtTokenProvider jwtTokenProvider;

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
		return authConfig.getAuthenticationManager();
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http.csrf(AbstractHttpConfigurer::disable)
				.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
				.formLogin(AbstractHttpConfigurer::disable).httpBasic(AbstractHttpConfigurer::disable)
				.authorizeHttpRequests(auth -> auth
						// JSP 화면 포워딩 허용 (필수)
						.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()

						// 정적 리소스 & 공개 경로
						.requestMatchers("/", "/miniboard/**").permitAll()
						.requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()

						// 인증 API — 로그인·리프레시는 인증 불필요
						.requestMatchers("/api/auth/login", "/api/auth/refresh", "/api/auth/signup").permitAll()

						// 게시글 조회 — 비로그인 허용
						.requestMatchers(HttpMethod.GET, "/api/posts/**").permitAll()

						// 게시글 작성·수정·삭제 — 로그인 회원만 (ROLE_USER, ROLE_ADMIN)
						.requestMatchers(HttpMethod.POST, "/api/posts/**").hasAnyRole("USER", "ADMIN")
						.requestMatchers(HttpMethod.PUT, "/api/posts/**").hasAnyRole("USER", "ADMIN")
						.requestMatchers(HttpMethod.PATCH, "/api/posts/**").hasAnyRole("USER", "ADMIN")
						.requestMatchers(HttpMethod.DELETE, "/api/posts/**").hasAnyRole("USER", "ADMIN")

						// 관리자 API — ROLE_ADMIN 전용
						.requestMatchers("/api/admin/**").hasRole("ADMIN")
						
						.requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()

						// 그 외 인증 필요
						.anyRequest().authenticated())
				.addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider),
						UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}
}