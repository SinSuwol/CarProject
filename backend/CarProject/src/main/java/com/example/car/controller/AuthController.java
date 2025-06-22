package com.example.car.controller;

import com.example.car.auth.JWTUtil;
import com.example.car.dto.LoginDto;
import com.example.car.dto.UserDto;
import com.example.car.entity.Member;
import com.example.car.repository.MemberRepository;
import com.example.car.service.MemberService;
import com.sun.source.tree.MemberReferenceTree;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final MemberService memberService;
    private final JWTUtil jwtUtil;

    @PostMapping("/register")
    public String register(UserDto userDto) {
        memberService.register(userDto);
        return "success"; // JS에서 판단할 수 있게 문자열만 반환
    }

 // ✅ 이게 가장 깔끔
    @GetMapping("/check-username")
    public Map<String, Object> checkUsername(@RequestParam("username") String username) {
        boolean exists = memberService.isUsernameTaken(username);
        Map<String, Object> result = new HashMap<>();
        result.put("available", !exists);
        return result;
    }

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody LoginDto loginDto, HttpSession session) {
        Member member = memberService.login(loginDto.getUsername(), loginDto.getPassword());

        Map<String, Object> result = new HashMap<>();
        if (member == null) {
            result.put("success", false);
            result.put("message", "로그인 실패");
            return result;
        }

        //JWT 생성 (Access + Refresh)
        String accessToken = jwtUtil.createAccessToken(member.getUsername());
        String refreshToken = jwtUtil.createRefreshToken(member.getUsername());

        //세션 저장 (선택)
        session.setAttribute("loginUser", member);

        result.put("success", true);
        result.put("accessToken", accessToken);
        result.put("refreshToken", refreshToken);
        result.put("username", member.getUsername());
        result.put("role", member.getRole());
        return result;
    }
    //리프레시 토큰
    @PostMapping("/reissue")
    public Map<String, Object> reissue(@RequestHeader("Authorization") String refreshToken) {
        Map<String, Object> result = new HashMap<>();

        try {
            String username = jwtUtil.validateRefreshToken(refreshToken.substring(7));
            String newAccessToken = jwtUtil.createAccessToken(username);
            result.put("success", true);
            result.put("accessToken", newAccessToken);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Refresh 토큰이 유효하지 않습니다.");
        }

        return result;
    }

    //로그아웃
    @PostMapping("/logout")
    public Map<String, Object> logout(HttpSession session) {
        session.invalidate();  // 세션 파기

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "로그아웃 완료");
        return result;
    }
}
