package com.jim.ezenpj.dao;

import java.util.ArrayList;

import com.jim.ezenpj.dto.BoardDto;
import com.jim.ezenpj.dto.JoinDto;
import com.jim.ezenpj.dto.ProductDto;

public interface MiniIDao {
	//====join==========
	public String join(JoinDto dto);
	//===login===
	public JoinDto login(String bId);
	//===board===
	public ArrayList<BoardDto> list();
	
	public void write(String name, String title, String content);
	
	public BoardDto contentView(String id);
	
	public void modify(String bId, String bName, String bTitle, String bContent);
	public void delete(String bId);
	public BoardDto reply_view(String bId);
	public void reply(String bId, String bName, String bTitle, String bContent, String bGroup, String bStep, String bIndent);
	public void upHit(String bId);
	public void replyShape(String bGroup, String bStep);
	public ArrayList<BoardDto> pageList(String pageNo);
	
	//product
	public ArrayList<ProductDto> productList();
	
	public String productWrite(ProductDto pdto);
	
	public ProductDto productDetailView(String rPhoto);
}
