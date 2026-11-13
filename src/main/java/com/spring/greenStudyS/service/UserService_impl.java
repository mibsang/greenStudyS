package com.spring.greenStudyS.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.greenStudyS.dao.UserDAO;
import com.spring.greenStudyS.vo.UserVO;

@Service
public class UserService_impl implements UserService {
	
	@Autowired
	UserDAO userDAO;

	@Override
	public List<UserVO> getUserList(UserVO vo) {
		return userDAO.getUserList(vo);
	}

	@Override
	public List<UserVO> getUserSearch(String mid) {
		return userDAO.getUserSearch(mid);
	}

	@Override
	public int setUserDelete(int idx) {
		return userDAO.setUserDelete(idx);
	}

	@Override
	public int setUserInput(UserVO vo) {
		return userDAO.setUserInput(vo);
	}



}
