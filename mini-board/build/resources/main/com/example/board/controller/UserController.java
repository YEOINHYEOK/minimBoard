package com.example.board.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.board.dto.UserDto;
import com.example.board.service.UserService;

@RestController
public class UserController {

    @Autowired
    private UserService userService;


    // 전체 사용자 조회
    @GetMapping("/users")
    public List<UserDto> getAllUsers() {
        return userService.getAllUsers();
    }
}