<%@ page language="java" contentType="text/plain; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
request.setCharacterEncoding("UTF-8");

String savePath = application.getRealPath("/manage/uploadImgs");
File saveDir = new File(savePath);

if (!saveDir.exists()) {
	saveDir.mkdirs();
}

int maxSize = 10 * 1024 * 1024;

try {
	MultipartRequest mr = 
			new MultipartRequest(request,saveDir.getAbsolutePath(),
					maxSize,"UTF-8",new DefaultFileRenamePolicy());

	String fileName = mr.getFilesystemName("imageFile");

	out.print(fileName);

} catch (Exception e) {
	e.printStackTrace();
	response.setStatus(500);
	out.print("");
}

%>
