package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.util.Constant;

public class BoardModifyCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		
		String bId = request.getParameter("bId");
		String bName = request.getParameter("bName");
		String bTitle = request.getParameter("bTitle");
		String bContent = request.getParameter("bContent");
		
		mdao.modify(bId, bName, bTitle, bContent);
	}

}
