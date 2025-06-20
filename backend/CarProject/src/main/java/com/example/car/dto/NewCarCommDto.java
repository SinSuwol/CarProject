package com.example.car.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NewCarCommDto {
    private Long ncId;
    private String username;
    private String ncTitle;
    private String ncContent;
    private LocalDateTime ncRegdate;
    private LocalDateTime ncModdate;
}