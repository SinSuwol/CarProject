package com.example.car.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.car.dto.NewCarCommDto;
import com.example.car.service.NewCarCommService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/newcar")
@RequiredArgsConstructor
public class NewCarCommController {

    private final NewCarCommService newCarCommService;

    @PostMapping("/{username}")
    public NewCarCommDto create(@PathVariable String username, @RequestBody NewCarCommDto dto) {
        return newCarCommService.create(username, dto);
    }

    @GetMapping("/{username}")
    public List<NewCarCommDto> getList(@PathVariable String username) {
        return newCarCommService.getAllByUsername(username);
    }

    @PutMapping("/{id}")
    public NewCarCommDto update(@PathVariable Long id, @RequestBody Map<String, String> body) {
        return newCarCommService.update(id, body.get("title"), body.get("content"));
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        newCarCommService.delete(id);
    }
}