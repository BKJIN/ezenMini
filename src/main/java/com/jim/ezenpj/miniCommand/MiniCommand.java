package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface MiniCommand {
	
	//�߻�޼��� ����
	public void execute(Model model, HttpServletRequest request);
}
