package com.example.car.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.car.dto.RentCommDto;
import com.example.car.service.RentCommService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/rent")
@RequiredArgsConstructor
public class RentCommController {

    private final RentCommService rentCommService;

    // 🔹 상담 목록
    @GetMapping("/{username}")
    public String getList(@PathVariable("username") String username, Model model,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        List<RentCommDto> list = rentCommService.getAllByUsername(username);
        model.addAttribute("list", list);
        model.addAttribute("username", username);
        return "rent/list"; // ⬅ templates/rent/list.html
    }

    // 🔹 등록 폼
    @GetMapping("/{username}/form")
    public String showForm(@PathVariable("username") String username, Model model,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        model.addAttribute("dto", new RentCommDto());
        model.addAttribute("username", username);
        return "rent/form"; // ⬅ templates/rent/form.html
    }

    // 🔹 등록 처리
    @PostMapping("/{username}/form")
    public String create(@PathVariable("username") String username, @ModelAttribute RentCommDto dto,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        rentCommService.create(username, dto);
        return "redirect:/rent/" + username;
    }

    // 🔹 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        RentCommDto dto = rentCommService.getById(id);
        model.addAttribute("dto", dto);
        return "rent/edit"; // ⬅ templates/rent/edit.html
    }

    // 🔹 수정 처리
    @PostMapping("/edit/{id}")
    public String update(@PathVariable("id") Long id, @ModelAttribute RentCommDto dto,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        rentCommService.update(id, dto.getRtTitle(), dto.getRtContent());
        return "redirect:/rent/" + dto.getUsername();
    }

    // 🔹 삭제 처리
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id, @RequestParam("username") String username,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        rentCommService.delete(id);
        return "redirect:/rent/" + username;
    }
}
