package security;


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
@EnableMethodSecurity           // @PreAuthorize, @Secured 어노테이션 활성화
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;

    // ── 비밀번호 인코더 (BCrypt) ───────────────────────────────────────────────

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // ── AuthenticationManager 빈 등록 ─────────────────────────────────────────

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration authenticationConfiguration
    ) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    // ── Security 필터 체인 ────────────────────────────────────────────────────

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // 1. CSRF 비활성화 (Stateless JWT 방식)
            .csrf(AbstractHttpConfigurer::disable)

            // 2. 세션 사용 안 함 (Stateless)
            .sessionManagement(session ->
                    session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

            // 3. 기본 로그인 폼 및 HTTP Basic 비활성화
            .formLogin(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)

            // 4. URL별 접근 권한 설정
            .authorizeHttpRequests(auth -> auth

                // 인증 없이 허용 (공개 엔드포인트)
                .requestMatchers(
                        "/api/auth/login",
                        "/api/auth/reissue",
                        "/api/auth/signup"
                ).permitAll()

                // Swagger / API 문서 (개발 환경)
                .requestMatchers(
                        "/swagger-ui/**",
                        "/v3/api-docs/**",
                        "/swagger-resources/**"
                ).permitAll()

                // 정적 리소스
                .requestMatchers(HttpMethod.GET,
                        "/css/**", "/js/**", "/images/**", "/favicon.ico"
                ).permitAll()

                // ADMIN 역할만 접근
                .requestMatchers("/api/admin/**").hasRole("ADMIN")

                // 그 외 모든 요청은 인증 필요
                .anyRequest().authenticated()
            )

            // 5. JWT 필터를 UsernamePasswordAuthenticationFilter 앞에 삽입
            .addFilterBefore(
                    new JwtAuthenticationFilter(jwtTokenProvider),
                    UsernamePasswordAuthenticationFilter.class
            );

        return http.build();
    }
}
