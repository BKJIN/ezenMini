package com.jim.ezenpj.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.jim.ezenpj.dto.BoardDto;
import com.jim.ezenpj.dto.JoinDto;
import com.jim.ezenpj.dto.ProductDto;

public class MiniDao implements MiniIDao {
	@Autowired //필드방식에 의한 Autowired
	private SqlSession sqlSession; //filed autowired 실제는 SqlSessionTemplate객체임(상위 인터페이스)
	//======= join ===========
	@Override
	public String join(JoinDto dto) {
		int res = sqlSession.insert("join",dto); //mapper.xml 호출
		System.out.println(res);
		String result = null;
		if(res > 0)
			result = "success";
		else
			result = "failed";
		
		return result;
	}

	//======= login =======
	@Override
	public JoinDto login(String bId) {
		System.out.println(bId);
		JoinDto result = sqlSession.selectOne("login",bId);
		return result;
	}

	//======= board =======
	@Override
	public ArrayList<BoardDto> list() {
		ArrayList<BoardDto> result = (ArrayList)sqlSession.selectList("list");
		return result;
	}


	@Override
	public void write(String name, String title, String content) {
		BoardDto dto = new BoardDto(0,name,title,content,null,0,0,0,0);
		sqlSession.insert("write",dto);
	}


	@Override
	public BoardDto contentView(String id) {
		upHit(id); //hit수 처리,내용조기에 hit수가 더해져야함
		int idNum = Integer.parseInt(id); //id는 주키인 게시판 번호로 db에서는 number
		BoardDto result = sqlSession.selectOne("contentView",idNum);
		return result;
	}



	@Override
	public void modify(String bId, String bName, String bTitle, String bContent) {
		int idNum = Integer.parseInt(bId); //db와 BoardDto에서는 int이므로 형변환
		BoardDto dto = new BoardDto(idNum, bName, bTitle, bContent, null, 0, 0, 0, 0);
		sqlSession.update("modify",dto); //수정이므로 sqlSession의 update메서드를 사용
	}


	@Override
	public void delete(String bId) {
		int idNum = Integer.parseInt(bId);
		sqlSession.delete("delete",idNum); //삭제 이므로 sqlSession의 delete메서드 사용
	}


	@Override
	public BoardDto reply_view(String bId) {
		int idNum = Integer.parseInt(bId);
		BoardDto result = sqlSession.selectOne("reply_view",idNum);
		//게시판 목록번호에 해당하는 레코드
		return result;
	}


	@Override
	public void reply(String bId, String bName, String bTitle, String bContent, String bGroup, String bStep,
			String bIndent) {
		replyShape(bGroup, bStep);
		//db컬럼이 number인것은 모두 int로 변환(dto와도 일치)
		int idNum = Integer.parseInt(bId);
		int iGroup = Integer.parseInt(bGroup);
		int iStep = Integer.parseInt(bStep);
		int iIndent = Integer.parseInt(bIndent);
		
		BoardDto dto = new BoardDto(idNum, bName, bTitle, bContent, null, 0, iGroup, iStep, iIndent);
		
		sqlSession.insert("reply",dto);
	} 
	
	@Override
	public void upHit(String bId) {
		int idNum = Integer.parseInt(bId);
		sqlSession.update("upHit",idNum);
	}
	
	@Override
	public void replyShape(String bGroup, String bStep) {
		int iGroup = Integer.parseInt(bGroup);
		int iStep = Integer.parseInt(bStep);
		BoardDto dto = new BoardDto(0, null, null, null, null, 0, iGroup, iStep, 0);
		sqlSession.update("replyShape",dto);
	}
	
	@Override
	public ArrayList<BoardDto> pageList(String pageNo) {
		int page = Integer.parseInt(pageNo);
		int start = (page-1) * 10 + 1 ;
		System.out.println("start : " + start);
		ArrayList<BoardDto> result = (ArrayList)sqlSession.selectList("pageList",start);
		System.out.println(result);
		return result;
	}

	//=======product======
	@Override
	public ArrayList<ProductDto> productList() {
		ArrayList<ProductDto> result = (ArrayList)sqlSession.selectList("productList");
		return result;
	}

	@Override
	public String productWrite(ProductDto pdto) {
		System.out.println("productwrite");
		String res;
		int result = sqlSession.insert("productWrite",pdto);
		if(result == 1)
			res = "success";
		else
			res= "failed";
		
		return res;
	}

	@Override
	public ProductDto productDetailView(String rPhoto) {
		ProductDto result = sqlSession.selectOne("productDetailView",rPhoto);
		return result;
	}
	
	
	
	
}
