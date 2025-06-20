package com.example.car.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.car.dto.AdminDashboardDto;
import com.example.car.dto.NewCarCommDto;
import com.example.car.dto.RentCommDto;
import com.example.car.service.AdminService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    // 관리자 대시보드
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        AdminDashboardDto dashboard = adminService.getDashboardData();
        model.addAttribute("dashboard", dashboard);
        return "admin/dashboard";  // templates/admin/dashboard.html
    }

    // 전체 상담 내역 (신차 + 렌트)
    @GetMapping("/consults")
    public String allConsults(Model model) {
        List<NewCarCommDto> newCarList = adminService.getAllNewCarConsults();
        List<RentCommDto> rentList = adminService.getAllRentConsults();

        model.addAttribute("newCarList", newCarList);
        model.addAttribute("rentList", rentList);
        return "admin/consults";  // templates/admin/consults.html
    }

    // 신차 상담 내역
    @GetMapping("/newcar")
    public String newCarConsults(Model model) {
        model.addAttribute("list", adminService.getAllNewCarConsults());
        return "admin/newcar";  // templates/admin/newcar.html
    }

    // 렌트 상담 내역
    @GetMapping("/rent")
    public String rentConsults(Model model) {
        model.addAttribute("list", adminService.getAllRentConsults());
        return "admin/rent";  // templates/admin/rent.html
    }
}

