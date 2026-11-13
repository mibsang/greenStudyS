package com.spring.greenStudyS.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class Level0_interceptor extends HandlerInterceptorAdapter {

		@Override
		public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
			// 관리자 : 0, 우수회원 : 1, 정회원 : 2, 준회원 : 3, 탈퇴회원 : 99, 비회원 : 999
			HttpSession session = request.getSession();
			int level = session.getAttribute("sLevel") == null ? 999 : (int)session.getAttribute("sLevel");
			
			//관리자가 아니면 초기화면으로
			if(level != 0 && level != 999 && level != 99) {
				request.getRequestDispatcher("/message/levelNotMatch").forward(request, response);
				return false;
			}
			else if(level == 999 || level == 99){
				request.getRequestDispatcher("/message/memberNo").forward(request, response);
				return false;
			}
			
			return true;
		}
}
