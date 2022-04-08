package com.jim.ezenpj.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.ProductDto;
import com.jim.ezenpj.miniCommand.BoardContentCommand;
import com.jim.ezenpj.miniCommand.BoardDeleteCommand;
import com.jim.ezenpj.miniCommand.BoardListCommand;
import com.jim.ezenpj.miniCommand.BoardModifyCommand;
import com.jim.ezenpj.miniCommand.BoardPageListCommand;
import com.jim.ezenpj.miniCommand.BoardReplyCommand;
import com.jim.ezenpj.miniCommand.BoardReplyViewCommand;
import com.jim.ezenpj.miniCommand.BoardWriteCommand;
import com.jim.ezenpj.miniCommand.JoinCommand;
import com.jim.ezenpj.miniCommand.MiniCommand;
import com.jim.ezenpj.miniCommand.ProductDetailsCommand;
import com.jim.ezenpj.miniCommand.ProductListCommand;
import com.jim.ezenpj.miniCommand.ProductWriteCommand;
import com.jim.ezenpj.naver.NaverLoginBO;
import com.jim.ezenpj.util.Constant;

@Controller
public class EzenMiniController {
	//bean 주입하여 Constant에 설정
	private MiniDao mdao;
	@Autowired
	public void setMdao(MiniDao mdao) {
		this.mdao = mdao;
		Constant.mdao = mdao;
	}
	
	BCryptPasswordEncoder passwordEncoder;
	@Autowired
	public void setPasswordEncoder(BCryptPasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
		Constant.passwordEncoder = passwordEncoder;
	}
	
	//GoogleLogin
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;
	
	//NaverLoginBO
	private NaverLoginBO naverLoginBO;
	@Autowired //bean주입
	public void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}
	
	private MiniCommand mcom; //command의 인터페이스 객체를 선언하여 다형성에 의해 구현 클래스 객체를 대입 사용
	
	//========menu=========
	@RequestMapping("/home") //login성공후 재로그인이나 회원가입시도시
	public String home() {
		System.out.println("home요청");
		return "index";
	}
	
	@RequestMapping("/folio")
	public String folio() {
		System.out.println("folio요청");
		return "folio";
	}
	
	@RequestMapping("/contact")
	public String contact() {
		return "contact";
	}

	//======== join ========
	@RequestMapping("/join_view")
	public String join_view() {
		return "join_view";
	}
	
	@RequestMapping(value= "/join", produces = "application/text; charset=UTF8")
	@ResponseBody
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("join");
		mcom = new JoinCommand(); //join요청에 따른 command 클래스로 MiniCommand인터페이스 구현 클래스
		mcom.execute(model, request);
		String result = (String) request.getAttribute("result");
		System.out.println(result);
		if(result.equals("success"))
			return "join-success";
		else
			return "join-failed";
	}
	
	//======== login ========
	@RequestMapping("/login_view")
	public String login_view(HttpServletRequest request, HttpServletResponse response, 
			HttpSession session, Model model) {
		System.out.println("login_view");
		socialUrl(model,session);
		return "login_view";
	}
	
	@RequestMapping("/Login") //로그인 없이 auth필요 페이지 접속시도시 스프링이 자동 호출하는 요청
	public String Login(HttpServletRequest resquest, HttpServletResponse response, HttpSession session, Model model) {
		System.out.println("Login");
		socialUrl(model,session);
		return "login_view";
	}
	
	@RequestMapping(value="/processLogin", method = RequestMethod.GET)
	public ModelAndView processLogin(
			@RequestParam(value = "log", required = false) String log,
			@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout,
			HttpSession session, Model smodel
			) {
		System.out.println("processLogin");
		ModelAndView model = new ModelAndView();
		if(log != null && log !="") { 
			//security form이 아닌 곳(a href="proceccLogin?log=1")에서 로그인 창 요청시
			model.addObject("log", "before login!");
		}
		if(error != null && error != "") { //로그인시 에러발생하면 security에서 요청(값은 1)
			model.addObject("error", "Invalid username or password!");
		}
		if(logout != null && logout != "") { //로그아웃 성공시 security에서 요청(값은 1)
			model.addObject("logout", "You've been logged out successfully.");
		}
		model.setViewName("login_view");
		socialUrl(smodel,session);
		return model;
	}
	
	//https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=sonmit002&logNo=221344583488
	@RequestMapping(value="/redirect",produces = "application/text; charset=UTF8")
	//구글에서 요청하는 경로
	public String googleCallback(Model model, @RequestParam String code, HttpServletResponse response) throws IOException {
		System.out.println("여기는 googleCallback");
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		AccessGrant accessGrant = //access token처리객체
				oauthOperations.exchangeForAccess(code, googleOAuth2Parameters.getRedirectUri(), null);
		String accessToken = accessGrant.getAccessToken();
		getGoogleUserInfo(accessToken,response);
		return "socialLogin";
	}
	
	@RequestMapping(value="kredirect", produces = "application/json; charset=UTF8")
	public String kredirect(@RequestParam String code, HttpServletResponse response, Model model) throws Exception {
		System.out.println("#########" + code);
		String access_Token = getKakaoAccessToken(code,response);
		System.out.println("###access_Token### : " + access_Token);
		//이 access_Token을 이용하여 kakao의 사용자 정보를 얻어냄
		HashMap<String, Object> userInfo = getKakaoUserInfo(access_Token);
		return "socialLogin";
	}
	
	@RequestMapping("/nredirect")
	public ModelAndView callback(@RequestParam String code, @RequestParam String state, HttpSession session) throws Exception {
		System.out.println("state :" + state);
		OAuth2AccessToken oauthToken = naverLoginBO.getAccessToken(session, code, state);
		String apiResult = naverLoginBO.getUserProfile(oauthToken);
		System.out.println(apiResult);
		//String형식인 apiResult를 json형태로 바꿈
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(apiResult);
		JSONObject jsonObj = (JSONObject) obj;
		JSONObject response_obj = (JSONObject) jsonObj.get("response");
		System.out.println("naver user정보 : " + response_obj);
		//response의 nickname값 파싱
		String name = (String) response_obj.get("name");
		System.out.println("name: " + name);
		return new ModelAndView("socialLogin", "result", apiResult);
		//addObject와 setViewName을 한번에 사용하는 법으로 생성자 사용 첫번째 파라메터는 view jsp이름, 두번째는 속성명, 세번째는 속성값
	}
	
	//social메서드
	public void socialUrl(Model model, HttpSession session) {
		//구글 code 발행
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		//OAuth2를 처리케하는 객체
		String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);
		//GrantType은 Oauth2처리 방식 AUTHORIZATION_CODE는 서버사이드 인증,googleOAuth2Parameter는
		//빈에 설정된 scope와 redirect정보를 가진 객체
		System.out.println("구글:" + url);
		//model에 저장하여 리턴 login_view.jsp에 사용토록 함
		model.addAttribute("google_url",url);
		
		//kakao code
		//kakao https://tyrannocoding.tistory.com/61
		String kakao_url  = 
				"https://kauth.kakao.com/oauth/authorize"
				+ "?client_id=bf599dd5c6f842390900c27c360f91c1"
				+ "&redirect_uri=https://localhost:8443/ezenpj/kredirect"
				+ "&response_type=code";
		model.addAttribute("kakao_url",kakao_url );
		
		//naver social login경로
		//네이버아이디로 인증 URL을 생성하기 위하여 NaverLoginBO클래스의 getAuthorizationUrl메소드 호출
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		System.out.println("네이버" + naverAuthUrl);
		model.addAttribute("naver_url", naverAuthUrl);
	}
	
	
	//구글사용자정보 얻기 메서드
	private void getGoogleUserInfo(String access_Token, HttpServletResponse response) {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		HashMap<String, Object> googleUserInfo = new HashMap<>();
		String reqURL =
			"https://www.googleapis.com/userinfo/v2/me?access_token="+access_Token;
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestProperty("Authorization", "Bearer" + access_Token);
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : "+responseCode);
			if(responseCode ==200) { //200은 연결 성공
				BufferedReader br =
						new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
				String line = "";
				String result = "";
				while((line = br.readLine()) != null) {
					result += line;
				}
				JSONParser parser = new JSONParser(); //문자열을 json객체화하는 객체
				Object obj = parser.parse(result);
				JSONObject jsonObj = (JSONObject) obj;
				//구글에서 온 자료를 문자열로 반환
				String name_obj = (String) jsonObj.get("name");
				String email_obj = (String) jsonObj.get("email");
				String id_obj = "GOOGLE_" + (String) jsonObj.get("id");
				
				googleUserInfo.put("name", name_obj);
				googleUserInfo.put("email", email_obj);
				googleUserInfo.put("id", id_obj);
				
				System.out.println("googleUserInfo : " + googleUserInfo);
//				System.out.println("name : " + name_obj);
//				System.out.println("email : " + email_obj);
//				System.out.println("id : " + id_obj);
				
				
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	//kakao access_Token 메서드
	public String getKakaoAccessToken (String authorize_code, HttpServletResponse response) {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String access_Token = "";
		String refresh_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//URL연결은 입출력에 사용 될 수 있고, POST 혹은 PUT 요청을 하려면 setDoOutput을 true로 설정해야함.
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			//kakao로 응답해주는 값
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			sb.append("grant_type=authorization_code");
			sb.append("&client_id=bf599dd5c6f842390900c27c360f91c1"); //본인이 발급받은 key
			sb.append("&redirect_uri=https://localhost:8443/ezenpj/kredirect");
			//본인이 설정해 놓은 경로
			sb.append("&code=" + authorize_code);
			bw.write(sb.toString());
			bw.flush();
			//결과 코드가 200이라면 성공
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode );
			//요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line = "";
			String result = "";
			while((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println("response body : " + result);
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(result); //parse메서드는 Object반환
			JSONObject jsonObj = (JSONObject) obj;
			access_Token = (String) jsonObj.get("access_token");
			refresh_Token = (String) jsonObj.get("refresh_token");
			System.out.println("access_token : " + access_Token);
			System.out.println("refresh_token : " + refresh_Token);
			//io객체는 close
			br.close();
			bw.close();
		}
		catch(Exception e) {
			e.getMessage();
		}
		return access_Token;
	}
	
	//kakao access_Token으로 사용자 정보 얻기
	public HashMap<String,Object> getKakaoUserInfo (String access_Token) {
		HashMap<String, Object> userInfo = new HashMap<String, Object>();
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			//요청에 필요한 Header에 포함될 내용
			conn.setRequestProperty("Authorization", "Bearer " + access_Token); //Bearer뒤에 한칸 띄워야 됨..
			int responseCode = conn.getResponseCode(); //200이면 정상
			System.out.println("responseCode : " + responseCode);
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line = "";
			String result = "";
			while ((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println("response body : " + result);
			
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(result);
			JSONObject jsonObj = (JSONObject) obj;
			JSONObject properties = (JSONObject) jsonObj.get("properties");
			JSONObject kakao_account = (JSONObject) jsonObj.get("kakao_account"); //검수후에 가능
			String accessToken = (String) properties.get("access_token");
			String nickname = (String) properties.get("nickname");
			String email = (String) kakao_account.get("email"); //검수후에 가능
			userInfo.put("accessToken", access_Token);
			userInfo.put("nickname", nickname);
			userInfo.put("email", email);
			System.out.println("=====================");
			System.out.println("nickname " + nickname);
			System.out.println("email " + email);
			System.out.println("=====================");
		}
		catch(Exception e) {
			e.getMessage();
		}
		return userInfo;
	}
	
	//=======logout========
	@RequestMapping("/logout_view")
	public String logout_view() {
		System.out.println("logout_view");
		return "logout_view";
	}
	
	//======board=======
	@RequestMapping("/board")
	public String board(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("board");
		mcom = new BoardListCommand();
		mcom.execute(model, request);
		//model.addAttribute("user",Constant.username); //게시판 content 수정할때 쓸려고(안됨)
		return "board";
	}
	
	@RequestMapping("/write_view") //ajax로 요청시 @ResponseBody 없으면 jsp반환
	public String write_view(Model model) {
		System.out.println("write_view()");
		model.addAttribute("bName",Constant.username);
		return "write_view";
	}
	
	@RequestMapping("/write")
	public String write(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("write");
		mcom = new BoardWriteCommand();
		mcom.execute(model, request);
		return "redirect:board";
	}
	
	@RequestMapping("/content_view") //ajax로 받아 보낸 클라이언트로 jsp보냄
	public String content_view(HttpServletRequest request, HttpServletResponse response, Model model) {
		mcom = new BoardContentCommand();
		mcom.execute(model, request);
		model.addAttribute("user",Constant.username);
		if(model.containsAttribute("content_view")) {
			String result = "success";
			System.out.println(result);
		}
		return "content_view";
	}
	
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("modify()");
		mcom = new BoardModifyCommand();
		mcom.execute(model,request);
		return "redirect:board";
	}
	
	@RequestMapping("/delete")
	public String delete(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("delete()");
		mcom = new BoardDeleteCommand();
		mcom.execute(model,request);
		return "redirect:board";
	}
	
	
	@RequestMapping("/reply_view") //ajax
	public String reply_view(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("reply_view()");
		//model.addAttribute("user",Constant.username);
		request.setAttribute("user", Constant.username); //샘은 위에 model에 넣어서 안됐음
		mcom = new BoardReplyViewCommand();
		mcom.execute(model,request); //선택한 게시판 목록에 대한 값들을 가져와서 댓글창에 사용
		return "reply_view";
	}
	
	@RequestMapping("/reply")
	public String reply(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("reply()");
		mcom = new BoardReplyCommand();
		mcom.execute(model,request); 
		return "redirect:board";
	}
	
	@RequestMapping("/plist")
	public String plist(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("plist");
		System.out.println(request.getParameter("pageNo"));
		mcom = new BoardPageListCommand();
		mcom.execute(model, request);
		return "plist";
	}
	
	//=======product=======
	@RequestMapping("/product")
	public String product(HttpServletRequest request, HttpServletResponse response,
			Model model, Authentication authentication) {
		System.out.println("product");
		mcom = new ProductListCommand();
		mcom.execute(model, request);
		
		//id와 role정보를 얻어내는 방법
		UserDetails userDetails = (UserDetails) authentication.getPrincipal();
		Constant.username = userDetails.getUsername();
		System.out.println(userDetails.getUsername()); //jmdh1004@gmail.com (로그인한 아이디)
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		String auth = authorities.toString(); //role을 얻어서 문자열로 변환
		System.out.println(auth); //[ROLE_USER]형태
		return "product_view";
	}
	
	@RequestMapping("/pwrite_view")
	public String pwrite_view()	{
		System.out.println("pwrite_view");
		return "pwrite_reg_view";
	}
	
	@RequestMapping("product_write") //upload
	//업로드시는 MultipartHttpServletRequest객체를 파라메터로 사용
	public String product_write(MultipartHttpServletRequest mtpRequest, Model model) {
		System.out.println("product_write");
		String rcusine = mtpRequest.getParameter("rCusine");
		String rname = mtpRequest.getParameter("rName");
		String rtitle = mtpRequest.getParameter("rTitle");
		String rcontent = mtpRequest.getParameter("rContent");
		String rphoto = null; //DB저장용 파일명
		
		//반환되는 파일 데이터는 MultipartFile형이고 getFile(파일속성명)로 구한다
		MultipartFile mf = mtpRequest.getFile("rFile");
		//지속저장
		String path = "C:/ecl/workspace/ezenMini/src/main/webapp/resources/images/";
		//초기 신속 저장으로 바로 보여 주기(war파일로 톰캣서버로 배포시는 불필요)
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/ezenMini/resources/images/";
		//원래파일의 이름은 mf.getOriginalFilename()으로 반환
		String originFileName = mf.getOriginalFilename();
		long prename = System.currentTimeMillis();
		long fileSize = mf.getSize(); //파일 사이즈(바이트 단위)
		System.out.println("originFileName : " + originFileName);
		System.out.println("fileSize : " + fileSize);
		
		String safeFile = path + prename + originFileName; //사진이름 중복 안되게 변환
		String safeFile1 = path1 + prename + originFileName;
		
		rphoto = prename + originFileName; //db에 저장 이름
		
		ProductDto pdto = new ProductDto(rphoto,rcusine,rname,rtitle,rcontent);
		mtpRequest.setAttribute("pdto", pdto);
		mcom = new ProductWriteCommand();
		
		mcom.execute(model, mtpRequest); //mtpRequest는 httpServletRequest하위 객체
		//model객체의 값을 추출하려면 asMap()메서드를 사용
		Map<String, Object> map = model.asMap();
		String res = (String) map.get("result");
		
		if(res.equals("success")) {
			try {
				mf.transferTo(new File(safeFile));
				mf.transferTo(new File(safeFile1));
			}
			catch(Exception e) {
				e.getMessage();
			}
			return "redirect:product";
		}
		else {
			return "product_view";
		}
	}
	
//	이클립스 이미지 업로드 새로고침	
//	Window 에서 Preferences클릭
//	Workspace에서 Refresh using native hooks or polling을 선택해준다.
//	Build에서 Save automatically before manual build를 선택한뒤 Apply and Close클릭
	
	@RequestMapping("/productDetails")
	public String productDetails(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("productDetails");
		mcom = new ProductDetailsCommand();
		mcom.execute(model, request);
		if(model.containsAttribute("product_view")) {
			String result = "success";
			System.out.println(result);
		}
		return "productDetailsView";
	}
	
	//=======DashBoard=======
	@RequestMapping("/dash")
	public String dash() {
		System.out.println("dash");
		return "dashBoard";
	}
	
	@RequestMapping("/bar")
	public String bar() {
		System.out.println("bar");
		return "bar";
	}

	@RequestMapping("/pie")
	public String pie() {
		System.out.println("bar");
		return "pie";
	}
	
	@RequestMapping(value = "/dashView", produces = "application/json; charset=UTF8")
	//json은 return타입
	@ResponseBody //jsp형태가 아닌 다른 문자열이나 객체형시
	public JSONObject dashView(HttpServletRequest request, HttpServletResponse response) {
		String subcmd = request.getParameter("subcmd");
		System.out.println(subcmd);
		JSONObject jobj_data = null; //JSONObject는 Map지원
		if (subcmd.equals("line")) {
			jobj_data = getAddData(request,response);
		}
		return jobj_data;
	}
	
	private JSONObject getAddData(HttpServletRequest request, HttpServletResponse response) {
		JSONArray datas = new JSONArray();
		JSONObject data1 = new JSONObject();
		//JSONObject는 map을 지원한다 (즉 map형임)
		//DB이용시는 dao의 리턴값이 db매핑 dto를 갖는 Arraylist이므로 여기서 반복 처리
		data1.put("month", "1월");
		data1.put("pc", "100");
		data1.put("monitor", "80");
		datas.add(data1);

		JSONObject data2 = new JSONObject();
		//JSONObject는 map을 지원한다 (즉 map형임)
		data2.put("month", "2월");
		data2.put("pc", "80");
		data2.put("monitor", "70");
		datas.add(data2);
		
		JSONObject data3 = new JSONObject();
		//JSONObject는 map을 지원한다 (즉 map형임)
		data3.put("month", "3월");
		data3.put("pc", "70");
		data3.put("monitor", "60");
		datas.add(data3);
		
		JSONObject data4 = new JSONObject();
		//JSONObject는 map을 지원한다 (즉 map형임)
		data4.put("month", "4월");
		data4.put("pc", "90");
		data4.put("monitor", "100");
		datas.add(data4);
		
		JSONObject data5 = new JSONObject();
		//JSONObject는 map을 지원한다 (즉 map형임)
		data5.put("month", "5월");
		data5.put("pc", "40");
		data5.put("monitor", "110");
		datas.add(data5);
		
		JSONObject result = new JSONObject();
		result.put("datas", datas);
		
		return result;
	}
	
	//========Utils=========
	@RequestMapping("/util")
	public String util() {
		System.out.println("util");
		return "util";
	}
	
	//====server sent event====
	@RequestMapping("/sse")
	public String sse() {
		System.out.println("sse");
		return "sseView";
	}
	
	@RequestMapping("/seventEx")
	public void seventEx(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("single event");
		response.setContentType("text/event-stream"); //event-stream이 아니면 sse안됨
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		for (int i=0; i < 20; i++) {
			writer.write("data: " + System.currentTimeMillis() + "\n\n");
			//보내줄 값은 System.currentTimeMillis() + "\n\n"이며 "data: "은 데이터라는 구분자로 사용값은 아님
			writer.flush();
			try {
				Thread.sleep(1000);
			}
			catch(Exception e) {
				e.getMessage();
			}
		}
		writer.close();
	}
	
	@RequestMapping("/meventEx")
	public void meventEx(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("multi event");
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		
		int upVote = 0;
		int downVote = 0;
		
		for (int i = 0; i < 20; i++) {
			upVote += (int)(Math.random() * 10);
			downVote += (int)(Math.random() * 10);
			
			writer.write("event:up_vote\n"); //event종류 write up_vote
			writer.write("data: " + upVote + "\n\n");

			writer.write("event:down_vote\n"); 
			writer.write("data: " + downVote + "\n\n");
			
			writer.flush();
			
			try {
				Thread.sleep(1000);
			}
			catch(InterruptedException e) {
				e.printStackTrace();
			}
		}
		writer.close();
	}
	
	@RequestMapping("/wstorage")
	public String wstorage() {
		System.out.println("wstorage");
		return "wstorageView";
	}
	
	@RequestMapping("/wworker")
	public String wworker() {
		System.out.println("wworker");
		return "wworkerView";
	}
	
	@RequestMapping("/fconvert")
	public String fconvert() {
		System.out.println("fconvert");
		return "fconvertView";
	}
	
}
