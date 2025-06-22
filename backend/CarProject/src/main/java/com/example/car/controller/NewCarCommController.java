package com.example.car.controller;

import com.example.car.dto.NewCarCommDto;
import com.example.car.service.NewCarCommService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/newcar")
@RequiredArgsConstructor
public class NewCarCommController {

    private final NewCarCommService newcarCommService;

    // ✅ 로그인 확인 공통 메서드
    private boolean isNotLoggedIn(HttpSession session) {
        return session.getAttribute("loginUser") == null;
    }

    // 🔹 상담글 목록 보기
    @GetMapping("/{username}")
    public String getList(@PathVariable("username") String username, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login";

        List<NewCarCommDto> list = newcarCommService.getAllByUsername(username);
        model.addAttribute("list", list);
        model.addAttribute("username", username);
        return "newcar/list";
    }

    // 🔹 상담글 등록 페이지
    @GetMapping("/{username}/form")
    public String showForm(@PathVariable("username") String username, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login";

        model.addAttribute("dto", new NewCarCommDto());
        model.addAttribute("username", username);
        return "newcar/form";
    }

    // 🔹 등록 처리
    @PostMapping("/{username}/form")
    public String create(@PathVariable("username") String username, @ModelAttribute NewCarCommDto dto, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login";

        newcarCommService.create(username, dto);
        return "redirect:/newcar/" + username;
    }

    // 🔹 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login";

        NewCarCommDto dto = newcarCommService.getById(id);
        model.addAttribute("dto", dto);
        return "newcar/edit";
    }

    // 🔹 수정 처리
    @PostMapping("/edit/{id}")
    public String update(@PathVariable("id") Long id, @ModelAttribute NewCarCommDto dto, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login";

        newcarCommService.update(id, dto.getNcTitle(), dto.getNcContent());
        return "redirect:/newcar/" + dto.getUsername();
    }

    // 🔹 삭제
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id, @RequestParam("username") String username, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login";

        newcarCommService.delete(id);
        return "redirect:/newcar/" + username;
    }
}
