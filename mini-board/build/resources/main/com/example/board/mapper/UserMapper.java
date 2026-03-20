package com.example.board.mapper;

import com.example.board.dto.UserDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserMapper {

    // 모든 사용자  조회
    List<UserDto> selectAllUsers();
}