package com.example.car.dto;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class NewCarCommDto {
    private Long ncId;
    private String username;
    private String ncTitle;
    private String ncContent;
    private LocalDateTime ncRegdate;
    private LocalDateTime ncModdate;
}