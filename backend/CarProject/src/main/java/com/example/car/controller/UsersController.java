package com.example.car.controller;

import com.example.car.entity.Member;
import com.example.car.service.MemberService;
import com.example.car.service.NewCarCommService;
import com.example.car.service.RentCommService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
@CrossOrigin(origins = "*")
public class UsersController {

    private final MemberService memberService;
    private final NewCarCommService newCarCommService;
    private final RentCommService rentCommService;

    // ✅ 마이페이지 화면
    @GetMapping("")
    public String mypage(HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login";
        }

        // 최신 정보 다시 가져오기
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

        // 기존 username 기준으로 이메일/전화/비밀번호만 수정
        memberService.updateMemberInfo(
                loginUser.getUsername(),
                updatedMember.getEmail(),
                updatedMember.getPhone(),
                updatedMember.getPassword()
        );

        return "redirect:/mypage";
    }
}
