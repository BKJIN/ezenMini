package com.jim.ezenpj.miniCommand;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.BoardDto;
import com.jim.ezenpj.util.Constant;

public class BoardListCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		ArrayList<BoardDto> dtos = mdao.list();
		request.setAttribute("listContent", dtos);
	}

}
