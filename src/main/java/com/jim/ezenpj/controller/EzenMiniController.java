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
	//bean �����Ͽ� Constant�� ����
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
	@Autowired //bean����
	public void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}
	
	private MiniCommand mcom; //command�� �������̽� ��ü�� �����Ͽ� �������� ���� ���� Ŭ���� ��ü�� ���� ���
	
	//========menu=========
	@RequestMapping("/home") //login������ ��α����̳� ȸ�����Խõ���
	public String home() {
		System.out.println("home��û");
		return "index";
	}
	
	@RequestMapping("/folio")
	public String folio() {
		System.out.println("folio��û");
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
		mcom = new JoinCommand(); //join��û�� ���� command Ŭ������ MiniCommand�������̽� ���� Ŭ����
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
	
	@RequestMapping("/Login") //�α��� ���� auth�ʿ� ������ ���ӽõ��� �������� �ڵ� ȣ���ϴ� ��û
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
			//security form�� �ƴ� ��(a href="proceccLogin?log=1")���� �α��� â ��û��
			model.addObject("log", "before login!");
		}
		if(error != null && error != "") { //�α��ν� �����߻��ϸ� security���� ��û(���� 1)
			model.addObject("error", "Invalid username or password!");
		}
		if(logout != null && logout != "") { //�α׾ƿ� ������ security���� ��û(���� 1)
			model.addObject("logout", "You've been logged out successfully.");
		}
		model.setViewName("login_view");
		socialUrl(smodel,session);
		return model;
	}
	
	//https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=sonmit002&logNo=221344583488
	@RequestMapping(value="/redirect",produces = "application/text; charset=UTF8")
	//���ۿ��� ��û�ϴ� ���
	public String googleCallback(Model model, @RequestParam String code, HttpServletResponse response) throws IOException {
		System.out.println("����� googleCallback");
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		AccessGrant accessGrant = //access tokenó����ü
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
		//�� access_Token�� �̿��Ͽ� kakao�� ����� ������ ��
		HashMap<String, Object> userInfo = getKakaoUserInfo(access_Token);
		return "socialLogin";
	}
	
	@RequestMapping("/nredirect")
	public ModelAndView callback(@RequestParam String code, @RequestParam String state, HttpSession session) throws Exception {
		System.out.println("state :" + state);
		OAuth2AccessToken oauthToken = naverLoginBO.getAccessToken(session, code, state);
		String apiResult = naverLoginBO.getUserProfile(oauthToken);
		System.out.println(apiResult);
		//String������ apiResult�� json���·� �ٲ�
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(apiResult);
		JSONObject jsonObj = (JSONObject) obj;
		JSONObject response_obj = (JSONObject) jsonObj.get("response");
		System.out.println("naver user���� : " + response_obj);
		//response�� nickname�� �Ľ�
		String name = (String) response_obj.get("name");
		System.out.println("name: " + name);
		return new ModelAndView("socialLogin", "result", apiResult);
		//addObject�� setViewName�� �ѹ��� ����ϴ� ������ ������ ��� ù��° �Ķ���ʹ� view jsp�̸�, �ι�°�� �Ӽ���, ����°�� �Ӽ���
	}
	
	//social�޼���
	public void socialUrl(Model model, HttpSession session) {
		//���� code ����
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		//OAuth2�� ó�����ϴ� ��ü
		String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);
		//GrantType�� Oauth2ó�� ��� AUTHORIZATION_CODE�� �������̵� ����,googleOAuth2Parameter��
		//�� ������ scope�� redirect������ ���� ��ü
		System.out.println("����:" + url);
		//model�� �����Ͽ� ���� login_view.jsp�� ������ ��
		model.addAttribute("google_url",url);
		
		//kakao code
		//kakao https://tyrannocoding.tistory.com/61
		String kakao_url  = 
				"https://kauth.kakao.com/oauth/authorize"
				+ "?client_id=bf599dd5c6f842390900c27c360f91c1"
				+ "&redirect_uri=https://localhost:8443/ezenpj/kredirect"
				+ "&response_type=code";
		model.addAttribute("kakao_url",kakao_url );
		
		//naver social login���
		//���̹����̵�� ���� URL�� �����ϱ� ���Ͽ� NaverLoginBOŬ������ getAuthorizationUrl�޼ҵ� ȣ��
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		System.out.println("���̹�" + naverAuthUrl);
		model.addAttribute("naver_url", naverAuthUrl);
	}
	
	
	//���ۻ�������� ��� �޼���
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
			if(responseCode ==200) { //200�� ���� ����
				BufferedReader br =
						new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
				String line = "";
				String result = "";
				while((line = br.readLine()) != null) {
					result += line;
				}
				JSONParser parser = new JSONParser(); //���ڿ��� json��üȭ�ϴ� ��ü
				Object obj = parser.parse(result);
				JSONObject jsonObj = (JSONObject) obj;
				//���ۿ��� �� �ڷḦ ���ڿ��� ��ȯ
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
	
	//kakao access_Token �޼���
	public String getKakaoAccessToken (String authorize_code, HttpServletResponse response) {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String access_Token = "";
		String refresh_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//URL������ ����¿� ��� �� �� �ְ�, POST Ȥ�� PUT ��û�� �Ϸ��� setDoOutput�� true�� �����ؾ���.
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			//kakao�� �������ִ� ��
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			sb.append("grant_type=authorization_code");
			sb.append("&client_id=bf599dd5c6f842390900c27c360f91c1"); //������ �߱޹��� key
			sb.append("&redirect_uri=https://localhost:8443/ezenpj/kredirect");
			//������ ������ ���� ���
			sb.append("&code=" + authorize_code);
			bw.write(sb.toString());
			bw.flush();
			//��� �ڵ尡 200�̶�� ����
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode );
			//��û�� ���� ���� JSONŸ���� Response �޼��� �о����
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line = "";
			String result = "";
			while((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println("response body : " + result);
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(result); //parse�޼���� Object��ȯ
			JSONObject jsonObj = (JSONObject) obj;
			access_Token = (String) jsonObj.get("access_token");
			refresh_Token = (String) jsonObj.get("refresh_token");
			System.out.println("access_token : " + access_Token);
			System.out.println("refresh_token : " + refresh_Token);
			//io��ü�� close
			br.close();
			bw.close();
		}
		catch(Exception e) {
			e.getMessage();
		}
		return access_Token;
	}
	
	//kakao access_Token���� ����� ���� ���
	public HashMap<String,Object> getKakaoUserInfo (String access_Token) {
		HashMap<String, Object> userInfo = new HashMap<String, Object>();
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			//��û�� �ʿ��� Header�� ���Ե� ����
			conn.setRequestProperty("Authorization", "Bearer " + access_Token); //Bearer�ڿ� ��ĭ ����� ��..
			int responseCode = conn.getResponseCode(); //200�̸� ����
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
			JSONObject kakao_account = (JSONObject) jsonObj.get("kakao_account"); //�˼��Ŀ� ����
			String accessToken = (String) properties.get("access_token");
			String nickname = (String) properties.get("nickname");
			String email = (String) kakao_account.get("email"); //�˼��Ŀ� ����
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
		//model.addAttribute("user",Constant.username); //�Խ��� content �����Ҷ� ������(�ȵ�)
		return "board";
	}
	
	@RequestMapping("/write_view") //ajax�� ��û�� @ResponseBody ������ jsp��ȯ
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
	
	@RequestMapping("/content_view") //ajax�� �޾� ���� Ŭ���̾�Ʈ�� jsp����
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
		request.setAttribute("user", Constant.username); //���� ���� model�� �־ �ȵ���
		mcom = new BoardReplyViewCommand();
		mcom.execute(model,request); //������ �Խ��� ��Ͽ� ���� ������ �����ͼ� ���â�� ���
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
		
		//id�� role������ ���� ���
		UserDetails userDetails = (UserDetails) authentication.getPrincipal();
		Constant.username = userDetails.getUsername();
		System.out.println(userDetails.getUsername()); //jmdh1004@gmail.com (�α����� ���̵�)
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		String auth = authorities.toString(); //role�� �� ���ڿ��� ��ȯ
		System.out.println(auth); //[ROLE_USER]����
		return "product_view";
	}
	
	@RequestMapping("/pwrite_view")
	public String pwrite_view()	{
		System.out.println("pwrite_view");
		return "pwrite_reg_view";
	}
	
	@RequestMapping("product_write") //upload
	//���ε�ô� MultipartHttpServletRequest��ü�� �Ķ���ͷ� ���
	public String product_write(MultipartHttpServletRequest mtpRequest, Model model) {
		System.out.println("product_write");
		String rcusine = mtpRequest.getParameter("rCusine");
		String rname = mtpRequest.getParameter("rName");
		String rtitle = mtpRequest.getParameter("rTitle");
		String rcontent = mtpRequest.getParameter("rContent");
		String rphoto = null; //DB����� ���ϸ�
		
		//��ȯ�Ǵ� ���� �����ʹ� MultipartFile���̰� getFile(���ϼӼ���)�� ���Ѵ�
		MultipartFile mf = mtpRequest.getFile("rFile");
		//��������
		String path = "C:/ecl/workspace/ezenMini/src/main/webapp/resources/images/";
		//�ʱ� �ż� �������� �ٷ� ���� �ֱ�(war���Ϸ� ��Ĺ������ �����ô� ���ʿ�)
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/ezenMini/resources/images/";
		//���������� �̸��� mf.getOriginalFilename()���� ��ȯ
		String originFileName = mf.getOriginalFilename();
		long prename = System.currentTimeMillis();
		long fileSize = mf.getSize(); //���� ������(����Ʈ ����)
		System.out.println("originFileName : " + originFileName);
		System.out.println("fileSize : " + fileSize);
		
		String safeFile = path + prename + originFileName; //�����̸� �ߺ� �ȵǰ� ��ȯ
		String safeFile1 = path1 + prename + originFileName;
		
		rphoto = prename + originFileName; //db�� ���� �̸�
		
		ProductDto pdto = new ProductDto(rphoto,rcusine,rname,rtitle,rcontent);
		mtpRequest.setAttribute("pdto", pdto);
		mcom = new ProductWriteCommand();
		
		mcom.execute(model, mtpRequest); //mtpRequest�� httpServletRequest���� ��ü
		//model��ü�� ���� �����Ϸ��� asMap()�޼��带 ���
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
	
//	��Ŭ���� �̹��� ���ε� ���ΰ�ħ	
//	Window ���� PreferencesŬ��
//	Workspace���� Refresh using native hooks or polling�� �������ش�.
//	Build���� Save automatically before manual build�� �����ѵ� Apply and CloseŬ��
	
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
	//json�� returnŸ��
	@ResponseBody //jsp���°� �ƴ� �ٸ� ���ڿ��̳� ��ü����
	public JSONObject dashView(HttpServletRequest request, HttpServletResponse response) {
		String subcmd = request.getParameter("subcmd");
		System.out.println(subcmd);
		JSONObject jobj_data = null; //JSONObject�� Map����
		if (subcmd.equals("line")) {
			jobj_data = getAddData(request,response);
		}
		return jobj_data;
	}
	
	private JSONObject getAddData(HttpServletRequest request, HttpServletResponse response) {
		JSONArray datas = new JSONArray();
		JSONObject data1 = new JSONObject();
		//JSONObject�� map�� �����Ѵ� (�� map����)
		//DB�̿�ô� dao�� ���ϰ��� db���� dto�� ���� Arraylist�̹Ƿ� ���⼭ �ݺ� ó��
		data1.put("month", "1��");
		data1.put("pc", "100");
		data1.put("monitor", "80");
		datas.add(data1);

		JSONObject data2 = new JSONObject();
		//JSONObject�� map�� �����Ѵ� (�� map����)
		data2.put("month", "2��");
		data2.put("pc", "80");
		data2.put("monitor", "70");
		datas.add(data2);
		
		JSONObject data3 = new JSONObject();
		//JSONObject�� map�� �����Ѵ� (�� map����)
		data3.put("month", "3��");
		data3.put("pc", "70");
		data3.put("monitor", "60");
		datas.add(data3);
		
		JSONObject data4 = new JSONObject();
		//JSONObject�� map�� �����Ѵ� (�� map����)
		data4.put("month", "4��");
		data4.put("pc", "90");
		data4.put("monitor", "100");
		datas.add(data4);
		
		JSONObject data5 = new JSONObject();
		//JSONObject�� map�� �����Ѵ� (�� map����)
		data5.put("month", "5��");
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
		response.setContentType("text/event-stream"); //event-stream�� �ƴϸ� sse�ȵ�
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		for (int i=0; i < 20; i++) {
			writer.write("data: " + System.currentTimeMillis() + "\n\n");
			//������ ���� System.currentTimeMillis() + "\n\n"�̸� "data: "�� �����Ͷ�� �����ڷ� ��밪�� �ƴ�
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
			
			writer.write("event:up_vote\n"); //event���� write up_vote
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
