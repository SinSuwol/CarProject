package com.example.car.controller;

import com.example.car.dto.RentCommDto;
import com.example.car.service.RentCommService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/rent")
@RequiredArgsConstructor
public class RentCommController {

    private final RentCommService rentCommService;

    // 🔹 상담 목록
    @GetMapping("/{username}")
    public String getList(@PathVariable("username") String username, Model model) {
        List<RentCommDto> list = rentCommService.getAllByUsername(username);
        model.addAttribute("list", list);
        model.addAttribute("username", username);
        return "rent/list"; // ⬅ templates/rent/list.html
    }

    // 🔹 등록 폼
    @GetMapping("/{username}/form")
    public String showForm(@PathVariable("username") String username, Model model) {
        model.addAttribute("dto", new RentCommDto());
        model.addAttribute("username", username);
        return "rent/form"; // ⬅ templates/rent/form.html
    }

    // 🔹 등록 처리
    @PostMapping("/{username}/form")
    public String create(@PathVariable("username") String username, @ModelAttribute RentCommDto dto) {
        rentCommService.create(username, dto);
        return "redirect:/rent/" + username;
    }

    // 🔹 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model) {
        RentCommDto dto = rentCommService.getById(id);
        model.addAttribute("dto", dto);
        return "rent/edit"; // ⬅ templates/rent/edit.html
    }

    // 🔹 수정 처리
    @PostMapping("/edit/{id}")
    public String update(@PathVariable("id") Long id, @ModelAttribute RentCommDto dto) {
        rentCommService.update(id, dto.getRtTitle(), dto.getRtContent());
        return "redirect:/rent/" + dto.getUsername();
    }

    // 🔹 삭제 처리
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id, @RequestParam String username) {
        rentCommService.delete(id);
        return "redirect:/rent/" + username;
    }
}
