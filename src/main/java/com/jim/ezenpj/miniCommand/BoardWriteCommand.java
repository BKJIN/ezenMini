package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.util.Constant;

public class BoardWriteCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		
		String name = request.getParameter("bName");
		String title = request.getParameter("bTitle");
		String content = request.getParameter("bContent");
		
		mdao.write(name,title,content);
	}

}
