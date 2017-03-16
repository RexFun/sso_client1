package auth.action;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import chok.devwork.BaseController;
import chok.sso.AuthUser;

@Scope("prototype")
@Controller
@RequestMapping("/auth")
public class AuthAction extends BaseController<AuthUser> 
{
	public static final String SessionName_CurLoginUser = "CUR_LOGIN_USER";
	
	private AuthUser auth;
	public AuthUser getAuth() 
	{
		return auth;
	}
	public void setAuth(AuthUser auth) 
	{
		this.auth = auth;
	}
	
	@RequestMapping("/login")
	public void login()
	{
		try 
		{
		}
		catch (Exception e)
		{
			result.setSuccess(false);
			result.setMsg(e.getMessage());
			e.printStackTrace();
		}
		printJson(result);
	}
	
	@RequestMapping("/logout")
	public String logout()
	{
		session.removeAttribute(SessionName_CurLoginUser);
		return "redirect:/login.jsp";
	}
	
}