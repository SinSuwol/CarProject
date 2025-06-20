package com.example.car.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {
    private String username;
    private String password;
    private String email;
    private String name;
    private String phone;
    private String role; // ✅ 추가: 선택적으로 관리자 등록 시 사용
}
