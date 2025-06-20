package com.example.car.dto;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RentCommDto {
    private Long rtId;
    private String username;
    private String rtTitle;
    private String rtContent;
    private LocalDateTime rtRegdate;
    private LocalDateTime rtModdate;
}
