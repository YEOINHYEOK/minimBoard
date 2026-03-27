package security;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshR refreshTokenRepository;
    private final MemberRepository memberRepository;

    // 로그인 → AT + RT 발급
    @Transactional
    public TokenResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.username(), request.password())
        );

        String accessToken  = jwtTokenProvider.generateAccessToken(authentication);
        String refreshToken = jwtTokenProvider.generateRefreshToken(authentication);

        refreshTokenRepository.save(authentication.getName(), refreshToken);

        return new TokenResponse(accessToken, refreshToken);
    }

    // RT 검증 → 새 AT + RT 재발급 (Refresh Token Rotation)
    @Transactional
    public TokenResponse reissue(String refreshToken) {
        if (!jwtTokenProvider.validateToken(refreshToken)) {
            throw new IllegalArgumentException("유효하지 않은 Refresh Token입니다.");
        }

        String username = jwtTokenProvider.getUsername(refreshToken);
        String saved = refreshTokenRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Refresh Token이 존재하지 않습니다."));

        if (!saved.equals(refreshToken)) {
            refreshTokenRepository.deleteByUsername(username); // 탈취 의심 → 전체 폐기
            throw new IllegalArgumentException("Refresh Token이 일치하지 않습니다.");
        }

        Authentication authentication = jwtTokenProvider.getAuthentication(refreshToken);
        String newAccessToken  = jwtTokenProvider.generateAccessToken(authentication);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(authentication);

        refreshTokenRepository.save(username, newRefreshToken);

        return new TokenResponse(newAccessToken, newRefreshToken);
    }

    // 로그아웃 → RT 삭제
    @Transactional
    public void logout(String accessToken) {
        if (!jwtTokenProvider.validateToken(accessToken)) {
            throw new IllegalArgumentException("유효하지 않은 Access Token입니다.");
        }
        refreshTokenRepository.deleteByUsername(jwtTokenProvider.getUsername(accessToken));
    }

    // 내 정보 조회
    @Transactional(readOnly = true)
    public UserInfoResponse getUserInfo(String username) {
        return memberRepository.findByUsername(username)
                .map(m -> new UserInfoResponse(m.getUsername(), m.getEmail(), m.getRole().name()))
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));
    }
}