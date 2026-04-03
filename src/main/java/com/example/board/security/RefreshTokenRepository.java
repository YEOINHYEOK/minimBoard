package com.example.board.security;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class RefreshTokenRepository {

	private final RefreshTokenMapper refreshTokenMapper;

	public void save(Long userId, String refreshToken) {
		// 기존 토큰이 있으면 먼저 삭제 후 새로 저장 (UPSERT)
		refreshTokenMapper.deleteByUserId(userId);
		refreshTokenMapper.insert(userId, refreshToken);
	}

	public Optional<String> findByUserId(Long userId) {
		return refreshTokenMapper.findByUserId(userId);
	}

	public void deleteByUserId(Long userId) {
		refreshTokenMapper.deleteByUserId(userId);
	}
}