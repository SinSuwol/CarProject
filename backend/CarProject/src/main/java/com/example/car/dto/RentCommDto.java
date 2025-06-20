package com.example.car.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RentCommDto {
    private Long rtId;
    private String username;
    private String rtTitle;
    private String rtContent;
    private LocalDateTime rtRegdate;
    private LocalDateTime rtModdate;
}
