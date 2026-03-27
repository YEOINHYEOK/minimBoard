package security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Component
public class JwtTokenProvider {

    private final SecretKey secretKey;
    private final long accessTokenExpMs;
    private final long refreshTokenExpMs;

    private static final String ROLES_CLAIM = "roles";

    public JwtTokenProvider(
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.access-token-expiration-ms:900000}") long accessTokenExpMs,    // 기본 15분
            @Value("${jwt.refresh-token-expiration-ms:604800000}") long refreshTokenExpMs // 기본 7일
    ) {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTokenExpMs = accessTokenExpMs;
        this.refreshTokenExpMs = refreshTokenExpMs;
    }

    // ── Access Token 생성 ──────────────────────────────────────────────────────

    public String generateAccessToken(Authentication authentication) {
        return buildToken(authentication.getName(), getRoles(authentication), accessTokenExpMs);
    }

    // ── Refresh Token 생성 ─────────────────────────────────────────────────────

    public String generateRefreshToken(Authentication authentication) {
        return buildToken(authentication.getName(), getRoles(authentication), refreshTokenExpMs);
    }

    // ── 토큰 파싱 → Authentication 복원 ────────────────────────────────────────

    public Authentication getAuthentication(String token) {
        Claims claims = parseClaims(token);

        List<String> roles = claims.get(ROLES_CLAIM, List.class);
        List<SimpleGrantedAuthority> authorities = (roles == null ? List.<String>of() : roles)
                .stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

        User principal = new User(claims.getSubject(), "", authorities);
        return new UsernamePasswordAuthenticationToken(principal, token, authorities);
    }

    // ── 만료 검증 ──────────────────────────────────────────────────────────────

    public boolean validateToken(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (ExpiredJwtException e) {
            log.warn("JWT 만료: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            log.warn("지원하지 않는 JWT: {}", e.getMessage());
        } catch (MalformedJwtException e) {
            log.warn("잘못된 JWT 형식: {}", e.getMessage());
        } catch (SecurityException e) {
            log.warn("JWT 서명 불일치: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            log.warn("JWT 클레임이 비어있음: {}", e.getMessage());
        }
        return false;
    }

    public String getUsername(String token) {
        return parseClaims(token).getSubject();
    }

    public Date getExpiration(String token) {
        return parseClaims(token).getExpiration();
    }

    // ── 내부 헬퍼 ──────────────────────────────────────────────────────────────

    private String buildToken(String subject, List<String> roles, long expirationMs) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + expirationMs);

        return Jwts.builder()
                .subject(subject)
                .claim(ROLES_CLAIM, roles)
                .issuedAt(now)
                .expiration(expiry)
                .signWith(secretKey)
                .compact();
    }

    private Claims parseClaims(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    private List<String> getRoles(Authentication authentication) {
        return authentication.getAuthorities().stream()
                .map(grantedAuthority -> grantedAuthority.getAuthority())
                .collect(Collectors.toList());
    }
}
