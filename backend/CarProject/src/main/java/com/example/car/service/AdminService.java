package com.example.car.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.car.dto.AdminDashboardDto;
import com.example.car.dto.NewCarCommDto;
import com.example.car.dto.RentCommDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final ChatService chatService;  // 채팅 알림 수용
    private final NewCarCommService newCarCommService;
    private final RentCommService rentCommService;

    public AdminDashboardDto getDashboardData() {
        AdminDashboardDto dto = new AdminDashboardDto();
        dto.setChatAlertCount(chatService.getUnreadMessageCount());  // 예: 미확인 채팅 메시지 수
        int newCarCount = newCarCommService.countAll();
        int rentCount = rentCommService.countAll();
        dto.setNewCarConsultCount(newCarCount);
        dto.setRentConsultCount(rentCount);
        dto.setTotalConsultCount(newCarCount + rentCount);
        return dto;
    }

    public List<NewCarCommDto> getAllNewCarConsults() {
        return newCarCommService.getAll();
    }

    public List<RentCommDto> getAllRentConsults() {
        return rentCommService.getAll();
    }
}

