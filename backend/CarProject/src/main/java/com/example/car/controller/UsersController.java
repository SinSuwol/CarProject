package com.example.car.controller;

import com.example.car.entity.Member;
import com.example.car.service.MemberService;
import com.example.car.service.NewCarCommService;
import com.example.car.service.RentCommService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
@CrossOrigin(origins = "*")
public class UsersController {

    private final MemberService memberService;
    private final NewCarCommService newCarCommService;
    private final RentCommService rentCommService;

    // ✅ 마이페이지 - API 또는 View 공용 처리
    @GetMapping("")
    public Object mypage(HttpServletRequest request, HttpSession session, Model model) {
        String accept = request.getHeader("Accept");

        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            // API 요청이면 JSON, 아니면 redirect
            if (accept != null && accept.contains("application/json")) {
                return ResponseEntity.status(401).body("로그인이 필요합니다.");
            }
            return "redirect:/login";
        }

        // API 요청인 경우 → JSON 응답
        if (accept != null && accept.contains("application/json")) {
            return Map.of(
                "username", loginUser.getUsername(),
                "email", loginUser.getEmail(),
                "role", loginUser.getRole()
            );
        }

        // 웹 요청인 경우 → Thymeleaf 렌더링
        Member refreshedUser = memberService.findByUsername(loginUser.getUsername());
        model.addAttribute("user", refreshedUser);
        model.addAttribute("newCarList", newCarCommService.getAllByUsername(refreshedUser.getUsername()));
        model.addAttribute("rentList", rentCommService.getAllByUsername(refreshedUser.getUsername()));

        return "mypage"; // → templates/users/mypage.html
    }

    // ✅ 회원 정보 수정
    @PostMapping("/update")
    public String updateUser(@ModelAttribute Member updatedMember, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        memberService.updateMemberInfo(
            loginUser.getUsername(),
            updatedMember.getEmail(),
            updatedMember.getPhone(),
            updatedMember.getPassword()
        );

        return "redirect:/mypage";
    }
}
