package security;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    // POST /api/auth/login — 인증 불필요
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    // POST /api/auth/refresh — 인증 불필요
    @PostMapping("/refresh")
    public ResponseEntity<TokenResponse> refresh(@Valid @RequestBody RefreshRequest request) {
        return ResponseEntity.ok(authService.reissue(request.refreshToken()));
    }

    // POST /api/auth/logout — 인증 필요
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(
            @RequestHeader("Authorization") String bearerToken) {
        String accessToken = bearerToken.substring(7); // "Bearer " 제거
        authService.logout(accessToken);
        return ResponseEntity.noContent().build(); // 204
    }

    // GET /api/auth/me — 인증 필요
    @GetMapping("/me")
    public ResponseEntity<UserInfoResponse> me(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(authService.getUserInfo(userDetails.getUsername()));
    }
}