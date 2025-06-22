package com.example.car.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@CrossOrigin(origins = "*")
public class ChatPageController {

    // ✅ 일반 사용자 채팅 페이지
	@GetMapping("/chatroom/{username}")
	public String userChatroom(@PathVariable("username") String username, Model model) {
	    System.out.println("▶ ChatPage username = " + username);   // ← 서버 콘솔에 찍히는지 확인
	    model.addAttribute("username", username);
	    model.addAttribute("roomId", username + "_admin");
	    return "chatroom";
	}


    // ✅ 관리자 채팅 페이지: /admin/chatroom?target=user01
    @GetMapping("/admin/chatroom")
    public String adminChatroom(@RequestParam("target") String targetUsername, Model model) {
        model.addAttribute("username", "admin"); // 관리자는 고정
        model.addAttribute("roomId", targetUsername + "_admin");
        return "chatroom"; // 또는 별도 chat_admin.html 만들어도 됨
    }
}
