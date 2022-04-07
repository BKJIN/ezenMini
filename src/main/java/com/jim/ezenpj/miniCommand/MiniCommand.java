package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface MiniCommand {
	
	//추상메서드 선언
	public void execute(Model model, HttpServletRequest request);
}
