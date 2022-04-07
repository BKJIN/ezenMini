package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.util.Constant;

public class BoardDeleteCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		
		String bid = request.getParameter("bId");
		
		mdao.delete(bid);
	}

}
