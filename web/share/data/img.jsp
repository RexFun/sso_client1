<%
MyReq req = new MyReq(request);
long id = req.getLong("id",0);
if(id > 0)
{
	byte[] po = null;
	po = MyFactory.getPaperImageService().getById(id).getByteArray("image");
	ServletOutputStream sender = response.getOutputStream();
	response.setContentType("application/octet-stream");
	sender.write(po);
	sender.flush();
	sender.close();
}
%><%@page language="java" pageEncoding="UTF-8"
import="
chok.devwork.MyReq,admin.MyFactory"%>