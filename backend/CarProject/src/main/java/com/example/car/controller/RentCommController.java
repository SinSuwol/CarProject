package com.example.car.controller;

import com.example.car.dto.RentCommDto;
import com.example.car.service.RentCommService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/rent")
@RequiredArgsConstructor
public class RentCommController {

    private final RentCommService rentCommService;

    //상담 등록
    @PostMapping("/{username}")
    public RentCommDto create(@PathVariable String username, @RequestBody RentCommDto dto) {
        return rentCommService.create(username, dto);
    }

    //상담 조회
    @GetMapping("/{username}")
    public List<RentCommDto> getList(@PathVariable String username) {
        return rentCommService.getAllByUsername(username);
    }

    //상담 수정
    @PutMapping("/{id}")
    public RentCommDto update(@PathVariable Long id, @RequestBody Map<String, String> body) {
        return rentCommService.update(id, body.get("title"), body.get("content"));
    }

    //상담 삭제
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        rentCommService.delete(id);
    }
}