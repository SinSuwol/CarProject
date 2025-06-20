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

    // 🔹 상담글 목록 보기
    @GetMapping("/{username}")
    public String getList(@PathVariable("username") String username, Model model,HttpSession session) {
    	//로그인 여부 확인
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
    	
        List<NewCarCommDto> list = newcarCommService.getAllByUsername(username);
        model.addAttribute("list", list);
        model.addAttribute("username", username);
        return "newcar/list"; // 🔸 templates/newcar/list.html
    }

    // 🔹 상담글 등록 페이지
    @GetMapping("/{username}/form")
    public String showForm(@PathVariable("username") String username, Model model,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        model.addAttribute("dto", new NewCarCommDto());
        model.addAttribute("username", username);
        return "newcar/form"; // 🔸 templates/newcar/form.html
    }

    // 🔹 등록 처리
    @PostMapping("/{username}/form")
    public String create(@PathVariable("username") String username, @ModelAttribute NewCarCommDto dto,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        newcarCommService.create(username, dto);
        return "redirect:/newcar/" + username;
    }

    // 🔹 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        NewCarCommDto dto = newcarCommService.getById(id);
        model.addAttribute("dto", dto);
        return "newcar/edit"; // 🔸 templates/newcar/edit.html
    }

    // 🔹 수정 처리
    @PostMapping("/edit/{id}")
    public String update(@PathVariable("id") Long id, @ModelAttribute NewCarCommDto dto,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        newcarCommService.update(id, dto.getNcTitle(), dto.getNcContent());
        return "redirect:/newcar/" + dto.getUsername();
    }

    // 🔹 삭제
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id, @RequestParam("username") String username,HttpSession session) {
    	if(session.getAttribute("loginUser")==null) {
    		return "redirect:/login";
    	}
        newcarCommService.delete(id);
        return "redirect:/newcar/" + username;
    }
}
