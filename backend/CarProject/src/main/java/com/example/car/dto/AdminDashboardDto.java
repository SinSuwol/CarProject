package com.example.car.dto;

import lombok.Data;

@Data
public class AdminDashboardDto {
    private int chatAlertCount;       // 실시간 상담 알림 수
    private int totalConsultCount;    // 전체 상담 개수
    private int newCarConsultCount;   // 신차 상담 개수
    private int rentConsultCount;     // 렌트 상담 개수
}
